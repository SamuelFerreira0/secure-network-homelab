chk(){ timeout 3 bash -c "</dev/tcp/$1/$2" 2>/dev/null && echo "ABERTO     $1:$2" || echo "BLOQUEADO  $1:$2"; }
pg(){ ping -c1 -W2 $1 >/dev/null 2>&1 && echo "PING OK     $1" || echo "PING FALHA  $1"; }
echo "Máquina: $(hostname)  $(date)"
echo "--- Financeiro para Staff (deve estar BLOQUEADO)"; pg 10.10.40.100; chk 10.10.40.100 445; chk 10.10.40.100 22
