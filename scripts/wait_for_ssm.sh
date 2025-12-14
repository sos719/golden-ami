#!/usr/bin/env bash
set -euo pipefail

INSTANCE_ID="${1:?Usage: wait_for_ssm.sh <instance-id> [timeout-seconds] [region]}"
TIMEOUT="${2:-420}"
REGION="${3:-${AWS_REGION:-us-east-1}}"

start="$(date +%s)"
echo "Waiting for SSM Online for instance: ${INSTANCE_ID} (timeout: ${TIMEOUT}s) in ${REGION}"

while true; do
  now="$(date +%s)"
  elapsed=$((now - start))
  if (( elapsed > TIMEOUT )); then
    echo "ERROR: Timed out waiting for SSM Online for ${INSTANCE_ID}"
    exit 1
  fi

  status="$(aws ssm describe-instance-information \
    --region "${REGION}" \
    --filters "Key=InstanceIds,Values=${INSTANCE_ID}" \
    --query "InstanceInformationList[0].PingStatus" \
    --output text 2>/dev/null || true)"

  if [[ "${status}" == "Online" ]]; then
    echo "SSM is Online for ${INSTANCE_ID}"
    exit 0
  fi

  echo "SSM status: ${status:-None}. Waiting..."
  sleep 10
done