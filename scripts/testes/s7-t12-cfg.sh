exec 2>&1
echo "== config do manager =="
grep -E 'disconnection' /var/ossec/etc/ossec.conf || echo "sem agents_disconnection (valores por omissao)"
echo "== regras de agente =="
grep -A3 -E '<rule id="50[1346]"' /var/ossec/ruleset/rules/0016-wazuh_rules.xml | grep -E 'rule id|description'
echo "== agentes =="
/var/ossec/bin/agent_control -l
