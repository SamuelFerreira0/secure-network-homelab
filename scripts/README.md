# Scripts

## `opn-block.py`

Resposta automática a varrimentos. Está instalado no Wazuh como `/var/ossec/active-response/bin/opn-block.sh` (é Python, o nome com `.sh` é o que está configurado no `ossec.conf`).

- É chamado pelo Wazuh quando dispara a regra 100100 (ver `configs/wazuh/`).
- Acrescenta o IP de origem ao alias `H_BLOQUEADOS` do OPNsense pela API e remove-o ao fim de 300 segundos.
- Nunca bloqueia: origens fora de `10.10.0.0/16`, a zona de Gestão, a de Monitorização, endereços terminados em `.1` (gateways) e os hosts `10.10.90.10` a `10.10.90.19` (perfis VPN da Gestão).
- Usa o `check_keys` do Wazuh para não bloquear duas vezes o mesmo IP.
- Lê as credenciais de `/var/ossec/etc/opnsense-ar.conf`, que não está no repositório.
- Regista em `/var/ossec/logs/active-responses.log`.

## `audit-accounts.sh`

Auditoria de contas Samba. Compara as contas com o registo de onboarding e assinala como alerta uma conta desativada no registo mas ainda ativa, e como aviso as contas sem registo e as palavras-passe com mais de `MAXDIAS` dias (90 por omissão). Corre na VM `ficheiros`.

## `onboarding/`

Scripts de onboarding e offboarding de utilizadores, escritos por Hugo Carvalho.

- `onboard-user.sh <utilizador> <departamento> [aprovador]`: cria o utilizador Samba, o grupo, o par de chaves WireGuard (com o endereço da gama do departamento), o ficheiro de configuração do cliente e o guia, e regista tudo.
- `offboard-user.sh <utilizador>`: desativa a conta, retira-a do grupo, arquiva os ficheiros e apaga o ficheiro VPN.
- `onboarding.conf` e `wg-cliente.conf.tpl`: configuração e modelo do ficheiro WireGuard do cliente.

O GLPI e o perfil VPN no OPNsense continuam a ser passos manuais, que os scripts lembram no fim.

## `testes/`

Scripts usados nos ensaios da semana 6 (ver `docs/plano-de-testes.md`).

- `scan-staff.sh`: varrimento de portas a partir do `cliente-staff` (T09)
- `teste-camada2.sh`: abre durante uns segundos a saída da VM 213 na firewall do Proxmox, corre o varrimento e restaura a firewall no fim. Só para teste. Depende de um `vm-run.sh` (corre um script dentro da VM pelo agente QEMU) que não está incluído.
- `teste-bloqueio.sh`: testa a saída para a Internet, para ver se a origem está bloqueada (T09)
- `teste-ssh.sh`: dez tentativas de SSH com utilizadores inexistentes (T10)
- `simula-ransom.sh`: cria, altera e apaga 30 ficheiros numa partilha (T11)
