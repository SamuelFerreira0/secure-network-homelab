exec 2>&1
echo "== T10 $(hostname) $(date '+%F %T') =="
for i in 1 2 3 4 5 6 7 8 9 10; do
  ssh -o BatchMode=yes -o ConnectTimeout=3 -o StrictHostKeyChecking=no t10falso$i@10.10.20.20 true 2>&1 | tail -1
done
