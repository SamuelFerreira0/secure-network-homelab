exec 2>&1
date '+%F %T'
/var/ossec/bin/agent_control -i 004 | grep -E 'Status|Last keep alive'
