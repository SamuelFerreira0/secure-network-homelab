exec 2>&1
chk(){ P=$(grep 'Palavra-passe' /root/.onb-$1.txt | sed 's/.*: //'); if smbclient "//127.0.0.1/$2" -U "$1%$P" -m SMB3 -c 'ls' >/dev/null 2>&1; then R=ACESSO; else R=NEGADO; fi; echo "$1 -> $2: $R (esperado $3) $([ $R = $3 ] && echo OK || echo FALHA)"; }
echo "=== T15 offboarding de tstaff $(date '+%F %T') ==="
echo "--- antes ---"
chk tstaff staff ACESSO; chk tstaff geral ACESSO; chk tstaff ti NEGADO
echo "--- offboarding ---"
/usr/local/bin/offboard-user.sh tstaff
echo "--- depois ---"
chk tstaff staff NEGADO; chk tstaff geral NEGADO; chk tstaff ti NEGADO
echo "--- registo ---"
grep ',tstaff,' /opt/onboarding/registo.csv | cut -d, -f1-5,7
ls /opt/onboarding/out | tr '\n' ' '; echo
ls -l /opt/onboarding/arquivo | grep tstaff || echo "sem arquivo (nenhum ficheiro do utilizador)"
echo "--- auditoria ---"
/usr/local/bin/audit-accounts.sh
