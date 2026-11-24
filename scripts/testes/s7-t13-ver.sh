exec 2>&1
ls /opt/onboarding /opt/onboarding/templates
echo "--- registo.csv (cabecalho e ultimas linhas) ---"
head -1 /opt/onboarding/registo.csv; tail -6 /opt/onboarding/registo.csv
