#!/usr/bin/env bash
set -euo pipefail

REGION="${1:-${AWS_REGION:-us-east-1}}"
BUILDER_ID="${2:-}"
VALIDATOR_ID="${3:-}"

terminate_if_set () {
  local id="$1"
  if [[ -n "${id}" && "${id}" != "None" && "${id}" != "null" ]]; then
    echo "Terminating instance ${id}..."
    aws ec2 terminate-instances --region "${REGION}" --instance-ids "${id}" >/dev/null || true
  fi
}

terminate_if_set "${BUILDER_ID}"
terminate_if_set "${VALIDATOR_ID}"

echo "Cleanup done."
