exec 2>&1
echo "== T11 $(hostname) $(date '+%F %T') =="
cp -p /etc/samba/smb.conf /root/smb.conf.bak-t11
echo "original:  $(sha256sum < /etc/samba/smb.conf)"
echo "# t11 teste $(date +%s)" >> /etc/samba/smb.conf
echo "alterado:  $(sha256sum < /etc/samba/smb.conf)"
sleep 10
cp -p /root/smb.conf.bak-t11 /etc/samba/smb.conf
echo "reposto:   $(sha256sum < /etc/samba/smb.conf)"
testparm -s >/dev/null 2>&1 && echo "testparm OK"
