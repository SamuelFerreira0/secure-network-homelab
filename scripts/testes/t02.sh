chk(){ timeout 3 bash -c "</dev/tcp/$1/$2" 2>/dev/null && echo "ABERTO     $1:$2" || echo "BLOQUEADO  $1:$2"; }
pg(){ ping -c1 -W2 $1 >/dev/null 2>&1 && echo "PING OK     $1" || echo "PING FALHA  $1"; }
echo "Máquina: $(hostname)  $(date)"
GW=$(ip route | awk '/default/{print $3}')
echo "--- para admin-gestao"; chk 10.10.10.10 22; chk 10.10.10.10 443
echo "--- para OPNsense ($GW)"; chk $GW 22; chk $GW 443
