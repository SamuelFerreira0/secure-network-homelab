exec 2>&1
umask 077
echo "== T13 onboarding $(date '+%F %T') =="
for par in "tgestao gestao" "tfinanceiro financeiro" "tstaff staff"; do
  set -- $par
  /usr/local/bin/onboard-user.sh $1 $2 teste > /root/.onb-$1.txt 2>&1 || echo "FALHOU $1"
  grep -v 'Palavra-passe' /root/.onb-$1.txt
done
chk(){ P=$(grep 'Palavra-passe' /root/.onb-$1.txt | sed 's/.*: //'); if smbclient "//127.0.0.1/$2" -U "$1%$P" -m SMB3 -c 'ls' >/dev/null 2>&1; then R=ACESSO; else R=NEGADO; fi; echo "$1 -> $2: $R (esperado $3) $([ $R = $3 ] && echo OK || echo FALHA)"; }
echo "== acesso as partilhas"
chk tgestao ti ACESSO; chk tgestao geral ACESSO; chk tgestao financeiro NEGADO
chk tfinanceiro financeiro ACESSO; chk tfinanceiro geral ACESSO; chk tfinanceiro staff NEGADO
chk tstaff staff ACESSO; chk tstaff geral ACESSO; chk tstaff ti NEGADO
echo "== ficheiros gerados"
for u in tgestao tfinanceiro tstaff; do echo "$u: $(ls /opt/onboarding/out/$u | tr '\n' ' ') | $(grep '^Address' /opt/onboarding/out/$u/wg-$u.conf) | marcadores no guia: $(grep -c '@@' /opt/onboarding/out/$u/guia-$u.md) | chave do servidor por preencher: $(grep -c A_PREENCHER /opt/onboarding/out/$u/wg-$u.conf)"; done
echo "== grupos"; getent group gestao financeiro staff
echo "== registo"; tail -3 /opt/onboarding/registo.csv
shred -u /root/.onb-tgestao.txt /root/.onb-tfinanceiro.txt
