exec 2>&1
echo "== $(hostname) =="
command -v nmap && nmap --version | head -1 || echo "sem nmap"
