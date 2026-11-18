#!/bin/bash
set -euo pipefail
BASE=/opt/onboarding
. "$BASE/onboarding.conf"
REG="$BASE/registo.csv"

if [ "$(id -u)" -ne 0 ]; then echo "correr como root"; exit 1; fi
if [ $# -lt 2 ] || [ $# -gt 3 ]; then echo "uso: onboard-user.sh <utilizador> <departamento> [aprovador]"; exit 1; fi

U="$1"
D="$2"
APROV="${3:-por-indicar}"

[[ "$U" =~ ^[a-z][a-z0-9_-]{2,19}$ ]] || { echo "nome invalido (3 a 20 caracteres: minusculas, numeros, _ ou -)"; exit 1; }
[[ "$APROV" =~ ^[A-Za-z0-9._-]+$ ]] || { echo "aprovador invalido (sem espacos nem virgulas)"; exit 1; }

case "$D" in
  gestao) LABEL="Gestão"; START=10; END=19 ;;
  financeiro) LABEL="Financeiro"; START=30; END=39 ;;
  staff) LABEL="Staff"; START=40; END=49 ;;
  *) echo "departamento invalido (gestao, financeiro ou staff)"; exit 1 ;;
esac

if id "$U" >/dev/null 2>&1; then echo "o utilizador $U ja existe"; exit 1; fi

if [ ! -f "$REG" ]; then
  echo "data,utilizador,departamento,aprovador,ip_vpn,chave_publica,estado" > "$REG"
  chmod 640 "$REG"
fi

IP=""
for n in $(seq "$START" "$END"); do
  if ! grep -q ",10.10.90.$n," "$REG"; then IP="10.10.90.$n"; break; fi
done
if [ -z "$IP" ]; then echo "sem enderecos livres na gama do departamento"; exit 1; fi

CREATED=0
cleanup() { if [ "$CREATED" -eq 1 ]; then userdel "$U" 2>/dev/null || true; fi; }
trap cleanup ERR

useradd -M -s /usr/sbin/nologin -G "$D" "$U"
CREATED=1

set +o pipefail
PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 16)
set -o pipefail

printf '%s\n%s\n' "$PASS" "$PASS" | smbpasswd -a -s "$U" >/dev/null

PRIV=$(wg genkey)
PUB=$(printf '%s' "$PRIV" | wg pubkey)

umask 077
OUT="$BASE/out/$U"
mkdir -p "$OUT"
FICH="wg-$U.conf"

SK="$SERVER_PUBKEY"
if [ -z "$SK" ]; then SK="A_PREENCHER_COM_A_CHAVE_DO_SERVIDOR"; fi

sed -e "s|@@PRIVADA@@|$PRIV|" -e "s|@@IP@@|$IP|" -e "s|@@DNS@@|$VPN_DNS|" -e "s|@@CHAVE_SERVIDOR@@|$SK|" -e "s|@@ENDPOINT@@|$ENDPOINT|" "$BASE/templates/wg-cliente.conf.tpl" > "$OUT/$FICH"
sed -e "s|@@UTILIZADOR@@|$U|g" -e "s|@@DEPARTAMENTO@@|$LABEL|g" -e "s|@@DATA@@|$(date +%F)|g" -e "s|@@FICHEIRO_VPN@@|$FICH|g" "$BASE/templates/guia-$D.md" > "$OUT/guia-$U.md"

echo "$(date +%F),$U,$D,$APROV,$IP,$PUB,ativo" >> "$REG"
CREATED=0

echo "================================================"
echo "Utilizador criado: $U ($LABEL)"
echo "Palavra-passe (so aparece agora): $PASS"
echo "IP VPN: $IP"
echo "Chave publica: $PUB"
echo "Ficheiros em: $OUT"
echo "------------------------------------------------"
echo "Falta fazer a mao:"
echo " 1. GLPI: criar a conta com o perfil do departamento"
echo " 2. OPNsense: registar o perfil VPN (chave publica e IP acima)"
echo " 3. Entregar a palavra-passe, o $FICH e o guia ao utilizador"
echo "================================================"
