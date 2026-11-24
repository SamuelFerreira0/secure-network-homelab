exec 2>&1
echo "== alertas no Wazuh $(date '+%F %T') =="
awk '/^20[0-9][0-9] [A-Z][a-z][a-z] [0-9]+ /{ts=$1" "$2" "$3" "$4} /^Rule: (5710|5712) /{print ts, $2, $3, $4}' /var/ossec/logs/alerts/alerts.log | grep "$(date '+%b %d' | sed 's/ 0/ /')" | tail -12
