chk(){ timeout 3 bash -c "</dev/tcp/$1/$2" 2>/dev/null && echo "ABERTO     $1:$2" || echo "BLOQUEADO  $1:$2"; }
pg(){ ping -c1 -W2 $1 >/dev/null 2>&1 && echo "PING OK     $1" || echo "PING FALHA  $1"; }
echo "Máquina: $(hostname)  $(date)"
echo "--- admin-gestao para servidores (deve estar ABERTO)"; chk 10.10.20.20 22; chk 10.10.20.30 22; chk 10.10.20.40 22
