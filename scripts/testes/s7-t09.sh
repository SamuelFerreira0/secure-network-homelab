exec 2>&1
c(){ if timeout 2 bash -c "exec 3<>/dev/tcp/$1/$2" 2>/dev/null; then echo "$1:$2 ABERTO"; else echo "$1:$2 BLOQUEADO"; fi; }
echo "== T09 $(hostname) $(date '+%F %T') =="
echo "-- controlo antes: Internet 443 (esperado ABERTO)"
c 1.1.1.1 443
echo "-- nmap -p 445 sobre VLAN 10 e VLAN 30 ($(date '+%T'))"
nmap -Pn -n -T4 -p 445 --max-retries 1 -oG /tmp/t09.gnmap 10.10.10.0/24 10.10.30.0/24 >/dev/null
echo "fim $(date '+%T'): hosts=$(grep -c 'Ports:' /tmp/t09.gnmap) filtered=$(grep -c '445/filtered' /tmp/t09.gnmap) open=$(grep -c '445/open' /tmp/t09.gnmap) closed=$(grep -c '445/closed' /tmp/t09.gnmap)"
sleep 20
echo "-- controlo depois: Internet 443 (esperado BLOQUEADO se a resposta automatica atuou)"
c 1.1.1.1 443
rm -f /tmp/t09.gnmap
