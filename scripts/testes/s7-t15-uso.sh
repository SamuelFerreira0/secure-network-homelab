exec 2>&1
sed -n '1,40p' /usr/local/bin/offboard-user.sh
echo "== audit =="
sed -n '1,15p' /usr/local/bin/audit-accounts.sh
