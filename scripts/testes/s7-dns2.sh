exec 2>&1
echo "== $(hostname) =="
grep nameserver /etc/resolv.conf
getent ahostsv4 example.com | head -1 || echo "sem resolucao"
