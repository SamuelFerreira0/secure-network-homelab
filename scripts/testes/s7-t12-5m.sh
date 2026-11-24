exec 2>&1
cp -a /var/ossec/etc/ossec.conf /root/ossec.conf.bak-t12
echo "== antes =="
grep -E 'disconnection' /var/ossec/etc/ossec.conf
sed -i 's|<agents_disconnection_time>[^<]*<|<agents_disconnection_time>5m<|' /var/ossec/etc/ossec.conf
echo "== depois =="
grep -E 'disconnection' /var/ossec/etc/ossec.conf
systemctl restart wazuh-manager
sleep 20
systemctl is-active wazuh-manager
/var/ossec/bin/agent_control -l
