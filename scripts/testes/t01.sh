chk(){ timeout 3 bash -c "</dev/tcp/$1/$2" 2>/dev/null && echo "ABERTO     $1:$2" || echo "BLOQUEADO  $1:$2"; }
pg(){ ping -c1 -W2 $1 >/dev/null 2>&1 && echo "PING OK     $1" || echo "PING FALHA  $1"; }
echo "Máquina: $(hostname)  $(date)"
for ip in 10.10.10.10 10.10.20.20 10.10.30.100 10.10.40.100; do pg $ip; chk $ip 22; chk $ip 445; done
echo "--- Internet"; chk 1.1.1.1 443; getent hosts example.com || echo "DNS externo FALHOU"
