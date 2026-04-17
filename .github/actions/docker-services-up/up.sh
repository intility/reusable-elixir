#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${SERVICES_YAML:-}" ]]; then
  echo "SERVICES_YAML is empty, nothing to do"
  exit 0
fi

command -v yq >/dev/null || {
  echo "::error::yq is required but not installed"
  exit 1
}
command -v docker >/dev/null || {
  echo "::error::docker is required but not installed"
  exit 1
}

count=$(yq 'length' <<<"$SERVICES_YAML")
if [[ "$count" == "0" || "$count" == "null" ]]; then
  echo "No services declared"
  exit 0
fi

echo "Starting $count service(s)"

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
  echo "  (container start will be implemented in the next task)"
  echo "::endgroup::"
done
