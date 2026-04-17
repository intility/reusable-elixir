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

count=$(yq 'length' <<<"$SERVICES_YAML")
if [[ "$count" == "0" || "$count" == "null" ]]; then
  echo "No services declared"
  exit 0
fi

# Create shared network (idempotent).
if ! docker network inspect "$NETWORK" >/dev/null 2>&1; then
  docker network create "$NETWORK" >/dev/null
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

  if [[ "${DRY_RUN:-}" == "1" ]]; then
    echo "DRY_RUN: docker ${args[*]} $image"
  else
    docker "${args[@]}" "$image" >/dev/null
  fi

  echo "::endgroup::"
done
