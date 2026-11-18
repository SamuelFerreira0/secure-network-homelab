#!/bin/bash
exec 2>&1
for ip in 10.10.30.100 10.10.10.10; do
  for p in 21 22 23 25 53 80 110 111 135 139 143 389 443 445 993 1433 3306 3389 5900 8006; do
    timeout 1 bash -c "echo > /dev/tcp/$ip/$p" 2>/dev/null && echo "$ip:$p ABERTA" || echo "$ip:$p bloqueada"
  done
done
