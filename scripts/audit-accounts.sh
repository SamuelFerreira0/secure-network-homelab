#!/bin/bash
CSV=/opt/onboarding/registo.csv
MAXDIAS=${MAXDIAS:-90}
hoje=$(date +%s)
alertas=0
declare -A flags pwd
user=""
while IFS= read -r l; do
  case "$l" in
    "Unix username:"*) user=$(echo "${l#*:}" | xargs) ;;
    "Account Flags:"*) flags[$user]=$(echo "${l#*:}" | xargs) ;;
    "Password last set:"*) pwd[$user]=$(echo "${l#*:}" | xargs) ;;
  esac
done < <(pdbedit -L -v)
echo "Auditoria de contas em $(date '+%F %H:%M') (limite de idade: $MAXDIAS dias)"
for u in $(printf '%s\n' "${!flags[@]}" | sort); do
  f=${flags[$u]}
  estado=$(awk -F, -v u="$u" '$2==u{e=$7} END{print e}' "$CSV")
  if [ -z "$estado" ]; then
    echo "AVISO  $u: conta Samba sem registo de onboarding"
  elif [[ "$estado" == desativado* ]] && [[ "$f" != *D* ]]; then
    echo "ALERTA $u: desativado no registo ($estado) mas ativo no Samba"
    alertas=$((alertas+1))
  fi
  if [[ "$f" != *D* ]]; then
    d=$(date -d "$(echo "${pwd[$u]}" | sed -E 's/ (WET|WEST)$//')" +%s 2>/dev/null)
    if [ -n "$d" ] && [ $(( (hoje-d)/86400 )) -gt "$MAXDIAS" ]; then
      echo "AVISO  $u: palavra-passe com mais de $MAXDIAS dias"
    fi
  fi
done
for u in $(awk -F, 'NR>1 && $7=="ativo"{print $2}' "$CSV"); do
  [ -z "${flags[$u]}" ] && echo "AVISO  $u: ativo no registo mas sem conta no Samba"
done
echo "Resumo: $alertas alerta(s)"
logger -t audit-accounts "resumo: $alertas alerta(s)"
[ "$alertas" -eq 0 ]
