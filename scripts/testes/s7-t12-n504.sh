exec 2>&1
grep -c '^Rule: 504 ' /var/ossec/logs/alerts/alerts.log
