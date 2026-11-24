exec 2>&1
find / -xdev \( -name 'offboard*' -o -name 'onboard*' -o -name 'audit-accounts*' \) -not -path '/proc/*' 2>/dev/null
