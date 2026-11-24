exec 2>&1
. /opt/onboarding/onboarding.conf
echo "SERVER_PUBKEY=${SERVER_PUBKEY:-<vazio>}"
echo "ENDPOINT=${ENDPOINT:-<vazio>}"
echo "VPN_DNS=${VPN_DNS:-<vazio>}"
