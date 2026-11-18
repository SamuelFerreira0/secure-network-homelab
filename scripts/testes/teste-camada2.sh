#!/bin/bash
# Abre durante uns segundos a saida interna da VM 213 (camada 1), corre o varrimento e restaura.
F=/etc/pve/firewall/213.fw
cp $F /root/213.fw.bak
restaurar() { cp /root/213.fw.bak $F; echo ">> firewall da 213 restaurada"; }
trap restaurar EXIT
sed -i '/^\[RULES\]/a OUT ACCEPT -dest 10.10.0.0/16' $F
echo ">> camada 1 aberta, a esperar 20 s"
sleep 20
T=90 /root/vm-run.sh 213 /root/scan-staff.sh
sleep 5
