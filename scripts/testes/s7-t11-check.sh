exec 2>&1
echo "== alertas de integridade do smb.conf $(date '+%F %T') =="
awk '/^20[0-9][0-9] [A-Z][a-z][a-z] [0-9]+ /{ts=$1" "$2" "$3" "$4} /^Rule: /{r=$2" "$3" "$4} /^File/ && /smb\.conf/{print ts, "regra", r, $0}' /var/ossec/logs/alerts/alerts.log | tail -6
