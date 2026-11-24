#!/bin/bash
F=/etc/pve/firewall/230.fw
cp $F /root/230.fw.bak
restaurar() {
  cp /root/230.fw.bak $F
  pct exec 230 -- rm -f /root/s7-portal.sh
  diff -q /root/230.fw.bak $F && echo ">> 230.fw igual ao original"
}
trap restaurar EXIT
sed -i '/^\[RULES\]/a OUT ACCEPT -dest 10.10.0.0/16' $F
echo ">> saida do portal aberta no Proxmox, a esperar 20 s"
sleep 20
pct push 230 /root/s7-portal.sh /root/s7-portal.sh
pct exec 230 -- bash /root/s7-portal.sh
sleep 8
echo "== Wazuh =="
T=60 /root/vm-run.sh 223 /root/s8-ar-log.sh
