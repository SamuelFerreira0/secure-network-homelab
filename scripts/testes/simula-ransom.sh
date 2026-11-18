#!/bin/bash
exec 2>&1
D=/srv/samba/geral/teste-fim
mkdir -p $D
for i in $(seq 1 30); do echo "conteudo $i" > $D/f$i.txt; done
sleep 3
for i in $(seq 1 30); do echo "cifrado" >> $D/f$i.txt; done
sleep 3
rm -rf $D
echo "simulacao feita"
