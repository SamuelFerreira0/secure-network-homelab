# Plano de testes

16 testes, com cenários baseados em incidentes reais (Target, WannaCry, Colonial Pipeline). Cada teste tem procedimento, resultado esperado, estado e evidência.

A evidência é a saída de texto guardada no momento do teste, em `evidencias/`. Não são capturas de ecrã. Os scripts usados estão em `scripts/testes/`.

## Estados

- **Passou:** executado com evidência e resultado igual ao esperado.
- **Parcial:** executado só em parte, falta o que está indicado.
- **Ensaio informal:** feito com evidência, mas ainda não segue o procedimento do plano.
- **Por fazer.**

## Resumo

| ID | Teste | Estado | Data | Evidência |
|---|---|---|---|---|
| T01 | Isolamento dos Convidados | Passou | 22 out | `T01-convidados.txt` |
| T02 | Proteção da Gestão | Passou | 22 out | `T02-*.txt` |
| T03 | Separação Financeiro e Staff | Passou | 22 out | `T03-*.txt` |
| T04 | DNS | Passou | 22 out | `T04-*.txt` |
| T05 | Permissões das partilhas | Passou | 25 out | `T05-partilhas.txt` |
| T06 | SMB1 recusado | Passou | 25 out | `T06-smb.txt` |
| T07 | Portal na DMZ | Passou | 30 out | `semana4-t07-portal.txt` |
| T08 | Contenção da DMZ | Parcial | 30 out | `semana4-t08-dmz.txt` |
| T09 | Varrimento e bloqueio automático | Ensaio informal | 14 nov | `semana6-deteccao-varrimento.txt`, `semana6-resposta-automatica.txt` |
| T10 | Autenticação SSH falhada | Ensaio informal | 14 nov | `semana6-ssh.txt` |
| T11 | Integridade de ficheiros | Ensaio informal | 14 nov | `semana6-integridade.txt` |
| T12 | Equipamento sem comunicação | Por fazer | | |
| T13 | Onboarding | Passou (lado Samba) | 3 nov | `semana5-t13-onboarding.txt` |
| T14 | VPN com âmbito limitado | Parcial | 10 e 11 nov | `semana5-vpn-perfis.txt` |
| T15 | Offboarding e revogação | Passou | 3, 11 e 14 nov | `semana5-t15-*.txt`, `semana6-auditoria-contas.txt` |
| T16 | Backup, restauro e falha | Por fazer | | |

Os testes T01 a T04 foram feitos antes de o Wazuh passar para a VLAN 70 (semana 4). Nas evidências desses testes o `wazuh` ainda aparece em `10.10.20.40`.

## Detalhe

### T01. Isolamento dos Convidados

- **Procedimento:** de `cliente-convidado`, ping, SSH (22) e SMB (445) para as VLANs 10, 20, 30 e 40, e acesso à Internet.
- **Esperado:** zonas internas bloqueadas e registadas, Internet a funcionar.
- **Observado:** ping e portas 22 e 445 bloqueados para as quatro zonas. A porta 443 de um endereço externo abre e o DNS externo resolve.
- **Estado:** passou (22 out).

### T02. Proteção da Gestão

- **Procedimento:** de `cliente-financeiro` e `cliente-staff`, SSH e HTTPS para `admin-gestao` e para a interface do OPNsense. De `admin-gestao`, SSH para os servidores.
- **Esperado:** bloqueado a partir do Financeiro e do Staff, a funcionar a partir da Gestão.
- **Observado:** portas 22 e 443 bloqueadas para `admin-gestao` e para o gateway da própria VLAN. A Gestão abre o SSH para os servidores.
- **Estado:** passou (22 out).

### T03. Separação Financeiro e Staff

- **Procedimento:** ping, SSH e SMB entre `cliente-financeiro` e `cliente-staff`, nos dois sentidos.
- **Esperado:** bloqueado nos dois sentidos.
- **Observado:** ping falha e as portas 22 e 445 ficam bloqueadas nos dois sentidos.
- **Estado:** passou (22 out).

### T04. DNS

- **Procedimento:** resolver `ficheiros.escritorio.test` e um domínio externo em cada zona.
- **Esperado:** as zonas internas resolvem os dois, os Convidados só o externo.
- **Observado:** Gestão, Financeiro e Staff resolvem os dois nomes. Os Convidados não resolvem o nome interno e resolvem o externo.
- **Estado:** passou (22 out).

### T05. Permissões das partilhas

- **Procedimento:** cada utilizador de teste tenta ler e escrever em todas as partilhas.
- **Esperado:** só acede às partilhas do seu grupo, com as permissões da tabela de acessos.
- **Observado:** o utilizador da Gestão lê e escreve em `ti` e `geral`. O do Financeiro e o do Staff leem e escrevem só na partilha do seu departamento e leem `geral` sem poder escrever. Tudo o resto é negado.
- **Estado:** passou (25 out).

### T06. SMB1 recusado

- **Procedimento:** forçar o protocolo SMB1 com `smbclient` contra `ficheiros`.
- **Esperado:** ligação recusada.
- **Observado:** o servidor está em SMB3 e só escuta na porta 445. O pedido SMB1 falha na negociação do protocolo.
- **Estado:** passou (25 out).

### T07. Portal na DMZ

- **Procedimento:** a partir da rede do anfitrião, aceder ao portal e testar outras portas.
- **Esperado:** o portal funciona, as restantes portas ficam bloqueadas.
- **Observado:** o Nginx responde com 200 e com o redirecionamento 301. A porta 8443 não liga e o SSH não responde.
- **Nota:** a evidência guarda os códigos HTTP. O login do cliente externo no GLPI através do portal não ficou registado.
- **Estado:** passou (30 out).

### T08. Contenção da DMZ

- **Procedimento:** a partir de `portal` (assumido comprometido), tentar alcançar o `glpi` fora da 443 e as zonas Gestão, Financeiro, Staff, Servidores e Monitorização.
- **Esperado:** bloqueado e registado, com eventos visíveis no Wazuh.
- **Observado:** só a porta 443 do `glpi` abre. O SSH e a base de dados do `glpi`, o SMB do `ficheiros`, a porta 1514 do `wazuh`, o SSH da Gestão e os gateways do Financeiro e do Staff ficam filtrados.
- **Falta:** mostrar os eventos no Wazuh.
- **Estado:** parcial (30 out).

### T09. Varrimento e bloqueio automático

- **Procedimento previsto:** de `cliente-staff`, `nmap -p 445` sobre as VLANs 10 e 30.
- **Procedimento do ensaio:** varrimento de 20 portas a `admin-gestao` e a `cliente-financeiro` com um script, com a saída da VM aberta durante o teste (ver `docs/problemas.md`, problema 5).
- **Esperado:** portas filtradas, alerta de possível varrimento no Wazuh e bloqueio temporário da origem.
- **Observado:** todas as portas bloqueadas. O Wazuh gerou alertas da regra 100100 (nível 10) para a origem do Staff. O registo da resposta mostra o IP da origem acrescentado ao alias do OPNsense e retirado ao fim de 5 minutos, e depois o acesso do Staff à Internet funciona.
- **Falta:** repetir com `nmap -p 445` e registar o bloqueio da origem a acontecer (correr `scripts/testes/teste-bloqueio.sh` enquanto o bloqueio está ativo e outra vez depois).
- **Estado:** ensaio informal (14 nov).

### T10. Autenticação SSH falhada

- **Procedimento:** 10 tentativas de SSH com utilizadores inexistentes, de `admin-gestao` para `ficheiros`.
- **Esperado:** alerta no Wazuh.
- **Observado:** 9 alertas da regra 5710 e 1 da regra 5712 (força bruta), ambas regras nativas do Wazuh.
- **Estado:** ensaio informal (14 nov).

### T11. Integridade de ficheiros

- **Procedimento previsto:** alterar a configuração do Samba em `ficheiros`.
- **Procedimento do ensaio:** criar, alterar e apagar 30 ficheiros em `/srv/samba/geral`.
- **Esperado:** alerta de integridade no Wazuh.
- **Observado:** alerta da regra 100110 (nível 12, alteração em massa) e os alertas nativos de ficheiro alterado, apagado e acrescentado.
- **Falta:** o ensaio com a configuração do Samba.
- **Estado:** ensaio informal (14 nov).

### T12. Equipamento sem comunicação

- **Procedimento:** parar um cliente e depois repô-lo.
- **Esperado:** alerta de agente desligado e posterior recuperação.
- **Estado:** por fazer.

### T13. Onboarding

- **Procedimento:** executar o procedimento para um utilizador novo em cada departamento.
- **Esperado:** lista de verificação cumprida nos três casos.
- **Observado:** três utilizadores criados com grupo, endereço VPN da gama do departamento, ficheiro de configuração e guia gerados, e registo no ficheiro de onboarding. O acesso às partilhas é o esperado nos três.
- **Falta:** os passos manuais (conta no GLPI e perfil VPN no OPNsense).
- **Estado:** passou do lado Samba (3 nov).

### T14. VPN com âmbito limitado

- **Procedimento previsto:** ligar com o perfil de um utilizador Staff e tentar alcançar os recursos de cada zona.
- **Procedimento feito:** perfis Gestão e Financeiro, a partir de fora da rede do laboratório.
- **Observado:** o perfil da Gestão alcança o SSH dos servidores e da DMZ, o painel do Wazuh e o GLPI. O do Financeiro só alcança as partilhas e o GLPI. O DNS responde pela VPN.
- **Falta:** o perfil do Staff.
- **Estado:** parcial (10 e 11 nov).

### T15. Offboarding e revogação

- **Procedimento:** offboarding de um utilizador de teste, depois `audit-accounts.sh`.
- **Esperado:** login Samba falha, `wg show` sem handshake, a VPN não liga, conta inativa listada pela auditoria.
- **Observado (Samba, 3 nov):** conta desativada, grupo removido, ficheiros arquivados, ficheiro VPN apagado, segundo offboarding recusado, acesso negado depois.
- **Observado (VPN, 11 nov):** peer removido no OPNsense, sem handshake e a porta 445 passa de aberta a fechada.
- **Observado (auditoria, 14 nov):** a conta de um utilizador desativado e reativada de propósito aparece como alerta, e deixa de aparecer quando é desativada outra vez.
- **Estado:** passou.

### T16. Backup, restauro e falha

- **Procedimento:** backup de `ficheiros` e da configuração do OPNsense, parar o Unbound e medir o efeito, apagar `ficheiros` e restaurar.
- **Esperado:** sem DNS os clientes perdem a resolução de nomes. Depois do restauro os serviços voltam e os checksums dos dados coincidem.
- **Estado:** por fazer.


## Testes planeados (reorientação QNRCS)

Os testes T01 a T16 mantêm-se e repetem-se na bateria final (semana 12). Os T17 a T23 testam os três pontos cegos e dependem das camadas 1 a 5 (ver `docs/enquadramento.md`). Estado de todos: planeado.

Regras comuns: controlo positivo antes de cada teste (confirmar que o tráfego chegou ao ponto de observação), pelo menos 5 repetições com média e dispersão. Métricas: deteção (sim ou não), tempo até ao alerta, atribuição correta ao utilizador, falsos positivos, carga de CPU e memória no OPNsense, volume de registos por dia.

| Teste | Cenário | Subcategorias QNRCS | Camadas |
|---|---|---|---|
| T17 | Movimento lateral por porta permitida: assinaturas conhecidas de Staff para `ficheiros`:445, alerta do IDS com origem, destino e utilizador | DE.MC-1, DE.MC-3, DE.MC-7, PR.TP-4 | 3, 5 |
| T18 | Exfiltração por volume: cópia massiva da partilha por um posto interno e por um utilizador VPN, alerta por desvio ao modelo de fluxos | DE.AE-1, DE.MC-7 | 2, 5 |
| T19 | Chave WireGuard copiada e usada em dois locais, alerta de endpoint alternado | PR.GA-3, DE.MC-7 | 4 |
| T20 | Utilizador VPN fora de horas e a tentar recursos fora do perfil, alerta com o nome e bloqueio registado | PR.GA-3, DE.MC-3 | 4, 5 |
| T21 | Varrimento a partir da VPN, deteção e bloqueio automático com utilizador identificado | PR.GA-3, DE.AE-3 | 4, 5 |
| T22 | Ligação entre duas VMs da mesma VLAN, bloqueio da firewall do Proxmox visível no Wazuh | PR.GA-5, PR.TP-1 | 1 |
| T23 | Linha de base de 24 h de tráfego normal simulado, contagem de falsos positivos | DE.AE-1, DE.AE-3 | 2, 5 |
