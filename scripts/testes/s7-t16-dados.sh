exec 2>&1
for s in financeiro geral ti staff; do
  head -c 2097152 /dev/urandom > /srv/samba/$s/t16-$s.bin
  echo "ficheiro de teste t16 em $s" > /srv/samba/$s/t16-$s.txt
  chown --reference=/srv/samba/$s /srv/samba/$s/t16-$s.bin /srv/samba/$s/t16-$s.txt
  chmod 660 /srv/samba/$s/t16-$s.bin /srv/samba/$s/t16-$s.txt
done
sync
echo "--- checksums ---"
find /srv/samba -type f -print0 | sort -z | xargs -0 sha256sum
echo "--- dono, grupo e permissoes ---"
find /srv/samba -type f -printf '%u:%g %m %p\n' | sort -k3
