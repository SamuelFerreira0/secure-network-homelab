exec 2>&1
cp /var/ossec/etc/ossec.conf /root/ossec.conf.bak-t11
grep -q '/etc/samba</directories>' /var/ossec/etc/ossec.conf || sed -i 's#^\(\s*\)<directories realtime="yes" check_all="yes">/srv/samba</directories>#&\n\1<directories realtime="yes" check_all="yes">/etc/samba</directories>#' /var/ossec/etc/ossec.conf
grep -n 'directories realtime' /var/ossec/etc/ossec.conf
N0=$(grep -c 'Real-time file integrity monitoring started' /var/ossec/logs/ossec.log)
systemctl restart wazuh-agent
for i in $(seq 1 30); do sleep 5; [ "$(grep -c 'Real-time file integrity monitoring started' /var/ossec/logs/ossec.log)" -gt "$N0" ] && echo "tempo real ativo apos $((i*5)) s" && break; done
systemctl is-active wazuh-agent
tail -n 6 /var/ossec/logs/ossec.log
