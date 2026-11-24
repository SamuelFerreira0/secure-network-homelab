exec 2>&1
find /srv/samba -type f | wc -l
find /srv/samba -maxdepth 2 | head -20
df -h /srv/samba | tail -1
