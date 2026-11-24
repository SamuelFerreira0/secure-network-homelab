chk(){ timeout 3 bash -c "</dev/tcp/$1/$2" 2>/dev/null && echo "ABERTO     $1:$2" || echo "BLOQUEADO  $1:$2"; }
pg(){ ping -c1 -W2 $1 >/dev/null 2>&1 && echo "PING OK     $1" || echo "PING FALHA  $1"; }
echo "Máquina: $(hostname)  $(date)"
getent hosts ficheiros.escritorio.test || echo "ficheiros.escritorio.test: NAO RESOLVE"
getent hosts example.com || echo "example.com: NAO RESOLVE"
