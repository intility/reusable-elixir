#!/usr/bin/env bash
set -euo pipefail

readonly NETWORK=ci-services
readonly LABEL=reusable-elixir-ci=1

if [[ -z "${SERVICES_YAML:-}" ]]; then
  echo "SERVICES_YAML is empty, nothing to do"
  exit 0
fi

command -v yq >/dev/null || { echo "::error::yq is required but not installed"; exit 1; }
command -v docker >/dev/null || { echo "::error::docker is required but not installed"; exit 1; }

# Output one entry per line from a field that may be:
#   - missing (no output)
#   - a scalar string (possibly multiline; split by newline)
#   - a sequence of strings (one per entry)
extract_lines() {
  local idx="$1" field="$2"
  yq -r "
    .[$idx].$field
    | ((select(tag == \"!!seq\") | .[]),
       (select(tag == \"!!str\") | split(\"\n\") | .[]))
    | sub(\"\\s+$\"; \"\")
    | select(. != \"\" and . != null)
  " <<<"$SERVICES_YAML"
}

count=$(yq 'length' <<<"$SERVICES_YAML")
if [[ "$count" == "0" || "$count" == "null" ]]; then
  echo "No services declared"
  exit 0
fi

# Create shared network (idempotent).
if ! docker network inspect "$NETWORK" >/dev/null 2>&1; then
  docker network create "$NETWORK" >/dev/null
fi

# Remove stale containers from a previous job (runner may not have cleaned up).
stale=$(docker ps -aq --filter "label=$LABEL" || true)
if [[ -n "$stale" ]]; then
  echo "Removing stale containers from a previous job: $stale"
  docker rm -f $stale >/dev/null
fi

echo "Starting $count service(s) on network $NETWORK"

for i in $(seq 0 $((count - 1))); do
  name=$(yq ".[$i].name // \"\"" <<<"$SERVICES_YAML")
  image=$(yq ".[$i].image // \"\"" <<<"$SERVICES_YAML")

  if [[ -z "$name" ]]; then
    echo "::error::services[$i] is missing required field 'name'"
    exit 1
  fi
  if [[ -z "$image" ]]; then
    echo "::error::services[$i] (name=$name) is missing required field 'image'"
    exit 1
  fi

  echo "::group::Starting service: $name ($image)"

  args=(run -d --name "$name" --network "$NETWORK" --label "$LABEL")

  # Ports
  while IFS= read -r port; do
    [[ -z "$port" ]] && continue
    args+=(-p "$port")
  done < <(extract_lines "$i" ports)

  # Env (via --env-file to avoid argv exposure)
  env_file=$(mktemp)
  while IFS= read -r kv; do
    [[ -z "$kv" ]] && continue
    printf '%s\n' "$kv" >>"$env_file"
  done < <(extract_lines "$i" env)
  if [[ -s "$env_file" ]]; then
    args+=(--env-file "$env_file")
  fi

  # Volumes
  while IFS= read -r vol; do
    [[ -z "$vol" ]] && continue
    args+=(-v "$vol")
  done < <(extract_lines "$i" volumes)

  # Raw extra options (split by whitespace/newlines; caller owns quoting).
  while IFS= read -r opt; do
    [[ -z "$opt" ]] && continue
    # shellcheck disable=SC2206
    args+=($opt)
  done < <(extract_lines "$i" options)

  if [[ "${DRY_RUN:-}" == "1" ]]; then
    echo "DRY_RUN: docker ${args[*]} $image"
  elif ! docker "${args[@]}" "$image" >/dev/null; then
    rm -f "$env_file"
    echo "::error::Failed to start service '$name' (image=$image)"
    exit 1
  fi

  # After docker run, env file is no longer needed.
  rm -f "$env_file"

  echo "::endgroup::"
done
