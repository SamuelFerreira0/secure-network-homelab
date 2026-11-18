# Problemas e soluções

Formato: sintoma, causa, solução.

## 1. DNS por DHCP

- **Sintoma:** os clientes não recebiam DNS.
- **Causa:** o Pi-hole inicial não chegava às outras redes.
- **Solução:** o DNS passou para o Unbound do OPNsense, com um servidor por zona.

## 2. VPN sem handshake

- **Sintoma:** a VPN WireGuard não fazia handshake.
- **Causa:** uma opção estava desligada.
- **Solução:** ativar a opção.

## 3. VPN sem DNS

- **Sintoma:** o DNS não respondia na interface da VPN.
- **Causa:** a interface da VPN não estava atribuída no Unbound.
- **Solução:** atribuir a interface no Unbound.

## 4. Bloqueios sem registo no Proxmox

- **Sintoma:** a firewall do Proxmox não registava os bloqueios.
- **Causa:** só a política por omissão é registada. As regras explícitas não.
- **Solução:** acrescentar `-log info` às regras.

## 5. Varrimentos que o Wazuh não via

- **Sintoma:** os varrimentos de teste não apareciam no Wazuh.
- **Causa:** morriam na firewall da própria VM e nunca chegavam ao OPNsense.
- **Solução:** para provar a segunda camada, a saída da VM foi aberta só durante o teste.

## 6. Regra do Wazuh abafada pelo ruído

- **Sintoma:** a regra nativa para bloqueios repetidos não disparava.
- **Causa:** era abafada pelo ruído da rede exterior.
- **Solução:** regra própria, só para origens internas. Ver `configs/`.

## 7. API do OPNsense com 403

- **Sintoma:** o desbloqueio automático falhava com erro 403.
- **Causa:** faltava um privilégio ao utilizador da API.
- **Solução:** atribuir o privilégio em falta. O desbloqueio só funcionou depois de implementado o "aperto de mão" entre o Wazuh e o OPNsense.

## 8. Isolamento do Wazuh (decisão)

- **Contexto:** um servidor comprometido não deve conseguir alcançar os registos.
- **Solução:** o Wazuh ficou numa VLAN própria. Convidados e portal ficaram sem agente de propósito, para manter o isolamento.
