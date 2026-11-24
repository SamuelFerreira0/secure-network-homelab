exec 2>&1
grep -n -iE 'ignore|nodiff|/srv/samba|realtime' /var/ossec/etc/ossec.conf
