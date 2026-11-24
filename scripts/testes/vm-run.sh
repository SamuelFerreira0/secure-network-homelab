#!/bin/bash
# uso: vm-run.sh <vmid> <script>
B=$(base64 -w0 "$2")
qm guest exec "$1" --timeout ${T:-120} -- bash -c "echo $B | base64 -d | bash" | python3 -c 'import sys,json;t=json.load(sys.stdin)["out-data"];print(t.encode("latin-1").decode("utf-8"),end="")'
