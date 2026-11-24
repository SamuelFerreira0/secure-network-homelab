exec 2>&1
echo "-- referencias a 10.10.20 nas regras e no script de resposta"
grep -n '10\.10\.20' /var/ossec/etc/rules/local_rules.xml /var/ossec/active-response/bin/opn-block.sh
echo "-- exclusoes no script de resposta"
grep -n -iE 'exclu|protegid|skip|ignore|10\.10\.10|10\.10\.70' /var/ossec/active-response/bin/opn-block.sh
