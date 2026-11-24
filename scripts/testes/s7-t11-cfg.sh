exec 2>&1
echo "== $(hostname) syscheck =="
sed -n '/<syscheck>/,/<\/syscheck>/p' /var/ossec/etc/ossec.conf | grep -E 'frequency|directories|ignore|scan_on_start'
