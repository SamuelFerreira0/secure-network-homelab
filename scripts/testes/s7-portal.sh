exec 2>&1
c(){ if timeout 1 bash -c "exec 3<>/dev/tcp/$1/$2" 2>/dev/null; then echo "$1:$2 ABERTO"; else echo "$1:$2 BLOQUEADO"; fi; }
echo "== portal $(date '+%F %T') =="
echo "-- controlo antes (esperado ABERTO)"
c 10.10.20.30 443
echo "-- varrimento a partir do portal: Staff, Financeiro e Gestao"
for h in 10.10.40.100 10.10.30.100 10.10.10.10; do for p in 21 22 23 25 53 80 135 139 443 445 3306 3389; do c $h $p >/dev/null; done; done
echo "varrimento terminado $(date '+%T')"
sleep 20
echo "-- controlo depois (esperado BLOQUEADO se a resposta automatica atuou)"
c 10.10.20.30 443
