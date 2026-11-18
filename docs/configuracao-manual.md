# Configuração manual

Passos feitos nas interfaces, que não têm ficheiro para importar.

## OPNsense: resposta automática

A configuração fica guardada no `config.xml` do OPNsense.

1. **Firewall, Aliases:** `H_BLOQUEADOS`, tipo Host(s), com o endereço de documentação `192.0.2.1` só para a lista não ficar vazia.
2. **Firewall, Rules, Floating:** Block, Quick, direção `in`, interfaces Financeiro, Staff, Servidores, DMZ e VPN (nunca Gestão nem Monitorização), origem `H_BLOQUEADOS`, destino any, log ligado.
3. **Firewall, Rules, Monitorização** (acima do bloqueio geral): Pass, TCP, origem o alias do Wazuh, destino o endereço da Monitorização, porta HTTPS, log ligado.
4. **System, Access, Users:** utilizador `wazuh-ar`, sem shell, só com os privilégios `Firewall: Alias: Edit`, `Firewall: Aliases` e `Diagnostics: PF Table IP addresses`, e uma chave API.
5. A chave API vai para o Wazuh, em `/var/ossec/etc/opnsense-ar.conf` (formato em `configs/wazuh/opnsense-ar.conf.example`), com `chown root:wazuh` e `chmod 640`.
6. **Services, Remote logging:** syslog UDP 514 para o Wazuh, com os registos da firewall.

## Proxmox: firewall por VM

Os ficheiros ficam em `/etc/pve/firewall/`. Cada VM tem `<vmid>.fw` com `policy_in` e `policy_out` em DROP, DHCP permitido e só os fluxos da matriz. As regras explícitas de DROP precisam de `-log info` para aparecerem no `pve-firewall.log`. O daemon aplica as alterações com cerca de 10 segundos de atraso.

Regras acrescentadas à VM do Wazuh:

```
IN ACCEPT -p udp -dport 514 -source 10.10.70.1
OUT ACCEPT -p tcp -dest 10.10.70.1 -dport 443
```
