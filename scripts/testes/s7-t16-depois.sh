exec 2>&1
echo "--- checksums ---"
find /srv/samba -type f -print0 | sort -z | xargs -0 sha256sum
echo "--- dono, grupo e permissoes ---"
find /srv/samba -type f -printf '%u:%g %m %p\n' | sort -k3
echo "--- servicos ---"
systemctl is-active smbd wazuh-agent
