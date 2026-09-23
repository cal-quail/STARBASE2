#!/usr/bin/env bash
# Manual fan control for Dell R720xd via iDRAC 7 IPMI.
# Credentials come from ../.env (git-ignored). See .env.example.
#
# Usage:
#   fan-control.sh manual <percent>   # e.g. manual 20
#   fan-control.sh auto               # hand control back to iDRAC
#   fan-control.sh status             # show temperatures and fan speeds
set -euo pipefail

ENV_FILE="$(dirname "$0")/../.env"
[[ -f "$ENV_FILE" ]] || { echo "Missing .env (copy .env.example)" >&2; exit 1; }
# shellcheck disable=SC1090
source "$ENV_FILE"
: "${IDRAC_HOST:?}" "${IDRAC_USER:?}" "${IDRAC_PASS:?}"

ipmi() { ipmitool -I lanplus -H "$IDRAC_HOST" -U "$IDRAC_USER" -E "$@"; }
export IPMI_PASSWORD="$IDRAC_PASS"   # -E reads it from env, keeps it out of `ps`

case "${1:-}" in
  manual)
    pct="${2:?percent required}"
    (( pct >= 10 && pct <= 100 )) || { echo "Percent must be 10-100" >&2; exit 1; }
    ipmi raw 0x30 0x30 0x01 0x00
    ipmi raw 0x30 0x30 0x02 0xff "$(printf '0x%02x' "$pct")"
    echo "Fans set to ${pct}%. Watch temps: $0 status"
    ;;
  auto)
    ipmi raw 0x30 0x30 0x01 0x01
    echo "Fan control returned to iDRAC."
    ;;
  status)
    ipmi sdr type temperature
    ipmi sdr type fan
    ;;
  *)
    sed -n '5,8p' "$0"; exit 1 ;;
esac
