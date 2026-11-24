exec 2>&1
t(){ if timeout $3 bash -c "exec 3<>/dev/tcp/$1/$2" 2>/dev/null; then echo "$1:$2 ABERTO"; else echo "$1:$2 BLOQUEADO"; fi; }
echo "== $(hostname) $(date '+%F %T') =="
echo "-- esperado ABERTO"
t deb.debian.org 80 5
t security.debian.org 80 5
t packages.wazuh.com 443 5
t 10.10.70.10 1514 5
echo "-- esperado BLOQUEADO"
t example.com 443 1
t 1.1.1.1 443 1
t 8.8.8.8 80 1
echo "-- apt update"
apt-get -o Acquire::http::Timeout=10 -o Acquire::https::Timeout=10 -o Acquire::Retries=0 update 2>&1 | tail -5
