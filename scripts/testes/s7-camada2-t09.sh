#!/bin/bash
F=/etc/pve/firewall/213.fw
cp $F /root/213.fw.bak-t09
restaurar() { cp /root/213.fw.bak-t09 $F; echo ">> firewall da 213 restaurada"; }
trap restaurar EXIT
sed -i '/^\[RULES\]/a OUT ACCEPT -dest 10.10.0.0/16' $F
echo ">> camada 1 aberta, a esperar 20 s"
sleep 20
T=150 /root/vm-run.sh 213 /root/s7-t09.sh
