exec 2>&1
find /srv/samba -type f -name 't16-*' -delete
echo "ficheiros em /srv/samba depois de apagar: $(find /srv/samba -type f | wc -l)"
