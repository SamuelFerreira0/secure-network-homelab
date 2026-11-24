exec 2>&1
find /srv/samba -type f -print0 | sort -z | xargs -0 sha256sum
