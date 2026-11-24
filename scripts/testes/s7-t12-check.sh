exec 2>&1
date '+%F %T'
/var/ossec/bin/agent_control -l | grep cliente-financeiro
awk '/^20[0-9][0-9] [A-Z][a-z][a-z] [0-9]+ /{hdr=$0} /^Rule: 50[0-9] /{print hdr " | " $0}' /var/ossec/logs/alerts/alerts.log | grep "$(date '+%b %d' | sed 's/ 0/ /')" | tail -8
