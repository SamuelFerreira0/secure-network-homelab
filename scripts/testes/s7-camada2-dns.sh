#!/bin/bash
ID=$1
F=/etc/pve/firewall/$ID.fw
cp $F /root/$ID.fw.bak-dns
restaurar() { cp /root/$ID.fw.bak-dns $F; echo ">> firewall da $ID restaurada"; }
trap restaurar EXIT
sed -i '/^\[RULES\]/a OUT ACCEPT -dest 1.1.1.1' $F
echo ">> camada 1 aberta para 1.1.1.1, a esperar 20 s"
sleep 20
T=60 /root/vm-run.sh $ID /root/s7-dns.sh
sleep 5
