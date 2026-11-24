# Procedimento de gestão e correlação de eventos

Documento 6 de 6 (rascunho de 24 de novembro de 2026). Serve de evidência para DE.AE-3 e, com o guia da secção 5, para DE.AE-1 (alinhada com o QNRCS, Quadro de Avaliação de Capacidades do CNCS). Versão 1.

## 1. Objetivo e âmbito

Definir como se recolhem, correlacionam e tratam os eventos de segurança, que fontes alimentam o Wazuh e como se aprende com cada incidente.

## 2. Fontes de eventos

| Fonte | Evento | Mecanismo | Estado |
|---|---|---|---|
| OPNsense (syslog UDP 514) | Bloqueios da firewall | Decoder `pf` do Wazuh, regras 87701 e 100100 | Ativo |
| Agentes Wazuh (5 máquinas) | Autenticação SSH falhada | Regras 5710 e 5712 | Ativo |
| Agentes Wazuh | Integridade de ficheiros (sistema e partilhas) | Regras 550 e 100110 | Ativo |
| Servidor Wazuh | Agente parado ou desligado | Regras 506, 504 e 503 | Ativo |
| Firewall do Proxmox | Descartes de política | `/var/log/pve-firewall.log`, sem envio para o Wazuh | A implementar (camada 1) |
| Suricata (IDS) | Alertas de rede, `eve.json` | Regras ET Open | A implementar (camada 3) |
| NetFlow | Fluxos entre zonas | Coletor open source | A implementar (camada 2) |
| Identidade VPN | Sessões WireGuard por utilizador | Script próprio, decoders e regras próprios | A implementar (camada 4) |

`cliente-convidado` e `portal` não têm agente, de propósito: a atividade deles vê-se nos registos da firewall.

## 3. Correlação

| Regra | O que correlaciona | Resposta |
|---|---|---|
| 100100 (nível 10) | 15 bloqueios da firewall com a mesma origem em `10.10.0.0/16`, em 30 s | A origem entra em `H_BLOQUEADOS` durante 5 minutos, por API |
| 100110 (nível 12) | 20 eventos de integridade em `/srv/samba` em 30 s | Alerta |
| 5710 e 5712 | Tentativas repetidas de SSH falhadas | Alerta |
| 504, 506 e 503 | Agente desligado, parado e recuperado | Alerta |

Limites da resposta automática: não bloqueia a Gestão (inclui a VPN de Gestão), a Monitorização, os gateways `.1` nem origens fora de `10.10.0.0/16`. O bloqueio dura 300 s a contar do último disparo.

A correlação de várias fontes (fluxo, IDS e identidade) entra na camada 5, com um painel e um playbook por caso de uso.

## 4. Procedimento de tratamento de um alerta

1. **Ver:** abrir o alerta no painel do Wazuh e identificar a regra, a origem, o destino e a hora.
2. **Confirmar:** verificar se a origem está no inventário (documento 5) e se o fluxo está no modelo de referência (documento 1).
3. **Classificar:** falso positivo, tentativa legítima mal configurada ou incidente.
4. **Responder:** se a resposta automática atuou, confirmar o bloqueio e a saída da lista em `/var/ossec/logs/active-responses.log` (aparece `delete` ao fim de 300 s). Se não atuou e é incidente, bloquear a origem em `H_BLOQUEADOS` e isolar o ativo.
5. **Registar:** uma linha no registo de incidentes (secção 6).
6. **Aprender:** se foi falso positivo ou o alerta chegou tarde, ajustar a regra ou a lista de exclusões e registar a alteração no documento 4.

Nos testes, uma ligação bloqueada faz-se com um só SYN por destino e não se repete antes de aparecer o `delete`, porque cada disparo reinicia o temporizador de 5 minutos.

## 5. Guia curto de tratamento de alertas

Para quem não conhece o sistema, a ordem é: ver a regra e a origem, perguntar "está no inventário?", perguntar "este fluxo é normal?", conferir se o bloqueio automático atuou e só então decidir. Quem não sabe decidir não desbloqueia nem altera regras: regista o alerta e chama a Gestão. Como a formação formal está fora de âmbito (PR.FC), este guia é a medida declarada em substituição de um registo de formação.

## 6. Registo de incidentes

| Id | Data | Regra | Origem e destino | Classificação | Resposta | Lição |
|---|---|---|---|---|---|---|
| (sem incidentes reais) | | | | | | |

Os eventos dos testes ficam nos ficheiros de evidência (`evidencias/`). Este registo é para incidentes reais, e a organização é simulada.

## 7. Lições já incorporadas (melhoria contínua)

- A regra nativa 87702 dispara com o ruído da WAN e fica quatro minutos calada, o que escondia varrimentos internos. Passou a usar-se a regra 100100 própria, só para origens internas.
- O alerta de agente desligado demorou cerca de 24 minutos com `agents_disconnection_time` a 15m. Com 5m desceu para cerca de 9 minutos (T12). Ficou a 5m.
- O bloqueio no agente seria feito na máquina do atacante. A resposta passou a ser na firewall central, pela API do OPNsense.
- A integridade de ficheiros gerava ruído em ficheiros `.log` e `.swp`. Passaram a ser excluídos, e a exclusão fica declarada como ponto cego (documentada na semana 8).
- O ficheiro isco do plano (opcional, nível 3 de DE.AE-3) fica por fazer, caso haja tempo.

## 8. Limitações

- Hoje só há correlação dentro de uma fonte ou de uma regra. A correlação entre fontes depende das camadas 2 a 4.
- O Wazuh guarda alertas, não todos os eventos (a confirmar com o `logall`).
- Os tempos medidos de deteção são de laboratório.
