#!/bin/bash
set -euo pipefail
BASE=/opt/onboarding
REG="$BASE/registo.csv"

if [ "$(id -u)" -ne 0 ]; then echo "correr como root"; exit 1; fi
if [ $# -ne 1 ]; then echo "uso: offboard-user.sh <utilizador>"; exit 1; fi

U="$1"
[[ "$U" =~ ^[a-z][a-z0-9_-]{2,19}$ ]] || { echo "nome invalido"; exit 1; }

LINHA=$(grep -E "^[^,]*,$U,[^,]*,[^,]*,[^,]*,[^,]*,ativo$" "$REG" || true)
if [ -z "$LINHA" ]; then echo "o utilizador $U nao esta ativo no registo"; exit 1; fi

D=$(echo "$LINHA" | cut -d, -f3)
IP=$(echo "$LINHA" | cut -d, -f5)
PUB=$(echo "$LINHA" | cut -d, -f6)
HOJE=$(date +%F)

smbpasswd -d "$U" >/dev/null
usermod -L "$U"
gpasswd -d "$U" "$D" >/dev/null

ARQ="$BASE/arquivo/$U-$HOJE.tar.gz"
LISTA=$(mktemp)
find /srv/samba -user "$U" -print0 > "$LISTA"
if [ -s "$LISTA" ]; then
  tar --null -czf "$ARQ" -T "$LISTA" 2>/dev/null
  chmod 600 "$ARQ"
  N=$(tr -cd '\0' < "$LISTA" | wc -c)
else
  N=0
fi
rm -f "$LISTA"

rm -rf "$BASE/out/$U"

sed -E -i "s#^([^,]*,$U,[^,]*,[^,]*,[^,]*,[^,]*,)ativo\$#\1desativado-$HOJE#" "$REG"

FLAGS=$(pdbedit -L -v -u "$U" | grep 'Account Flags' | sed 's/^[^:]*: *//')
GRUPOS=$(id -nG "$U")

echo "================================================"
echo "Offboarding: $U ($D)"
if [[ "$FLAGS" == *D* ]]; then echo "Conta Samba: desativada $FLAGS"; else echo "ATENCAO: conta Samba nao ficou desativada $FLAGS"; fi
if echo " $GRUPOS " | grep -q " $D "; then echo "ATENCAO: ainda esta no grupo $D"; else echo "Grupo $D: removido"; fi
echo "Ficheiros arquivados: $N"
echo "Ficheiro VPN com a chave privada: apagado"
echo "------------------------------------------------"
echo "Falta fazer a mao:"
echo " 1. GLPI: desativar a conta de $U"
echo " 2. OPNsense: remover o perfil VPN (IP $IP, chave publica $PUB)"
echo "================================================"
