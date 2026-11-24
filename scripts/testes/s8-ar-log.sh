exec 2>&1
echo "-- resposta automatica (ultimas linhas)"
grep opn-block /var/ossec/logs/active-responses.log | tail -4
echo "-- alertas 100100 com origem 10.10.60.10"
grep '"id":"100100"' /var/ossec/logs/alerts/alerts.json | grep -c '10.10.60.10'
