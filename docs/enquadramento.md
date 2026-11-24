# Enquadramento

## Pergunta

Visibilidade do tráfego inter-VLAN e do acesso remoto por VPN numa pequena organização: como evolui a maturidade de cibersegurança com ferramentas open source, alinhada com o QNRCS. A base do projeto (7 zonas, matriz de fluxos, testes T01 a T16) mantém-se e não se refaz.

## Pontos cegos

1. Tráfego inter-VLAN permitido: a firewall regista sobretudo o que bloqueia. O WannaCry propagou-se por SMB.
2. Acesso remoto por VPN: o WireGuard não gera eventos de sessão (quem, de onde, quando, chave copiada).
3. Tráfego dentro da mesma VLAN: só a firewall do Proxmox o vê e os registos não chegam ao Wazuh.

## Objetivos

| Id | Objetivo |
|---|---|
| O1 | Caracterizar os pontos cegos e o risco, ligados a casos reais (Target 2013, WannaCry 2017, Colonial Pipeline 2021) |
| O2 | Avaliar o perfil atual nas subcategorias em foco, com o Quadro de Avaliação de Capacidades |
| O3 | Implementar soluções open source em camadas |
| O4 | Validar com cenários de ataque e métricas (deteção, tempo, atribuição, falsos positivos, custo) |
| O5 | Reavaliar o perfil e mostrar a evolução (antes e depois), com as limitações assumidas |

## Referenciais

- **QNRCS 2019**, com cinco objetivos: Identificar, Proteger, Detetar, Responder, Recuperar.
- **Quadro de Avaliação de Capacidades do CNCS** (v1.0, janeiro de 2020): três níveis cumulativos por subcategoria (1 Inicial, 2 Intermédio, 3 Avançado), cada um com as evidências exigidas.
- **Versão nova do QNRCS:** Anexo I do Regulamento n.º 756/2026 (execução do DL n.º 125/2025, que transpõe a NIS2), alinhada com o NIST CSF 2.0 e com códigos diferentes. Os códigos usados neste repositório são os de 2019. A equivalência entre versões ainda não foi feita.
- **Linguagem:** "alinhado com o QNRCS", nunca "conforme". A conformidade formal não foi avaliada.

## Método

Os sete passos do QNRCS 2019: prioridade e âmbito, linhas orientadoras, perfil atual, aferição do risco, perfil alvo, lacunas, plano de ação. O perfil atual fixa-se a 1 de dezembro de 2026 e a partir daí qualquer alteração fica no [registo de alterações](politicas/04-registo-alteracoes-revisoes.md).

## Subcategorias em foco

DE.AE-1, DE.MC-1, PR.TP-4, DE.MC-3, DE.MC-7, PR.GA-3, PR.GA-5, ID.GA-3, DE.AE-3 e PR.TP-1. O detalhe está na [matriz](qnrcs/matriz-conformidade.md) e no [perfil atual](qnrcs/perfil-atual.md).

Fora de âmbito, declarado: acesso físico, formação, governação e cadeia logística.

## Camadas de implementação

Tudo open source e a convergir no Wazuh.

| Camada | O que faz | Estado |
|---|---|---|
| 1. Registos | Registo nas regras entre zonas e na interface WireGuard do OPNsense. Agente Wazuh no hipervisor para os registos da firewall do Proxmox. Medição do volume | Planeada (semana 9) |
| 2. Fluxos | NetFlow v9 do OPNsense para o analisador local e para um coletor open source na VLAN 70 (ntopng Community ou nfdump) | Planeada (semana 9) |
| 3. Inspeção | Suricata em modo IDS nas interfaces das VLANs e do WireGuard, regras ET Open, `eve.json` para o Wazuh. Medição da carga de CPU | Planeada (semana 10) |
| 4. Identidade da VPN | Script que lê o estado do WireGuard (último handshake, endpoint, bytes por peer), associa a chave ao utilizador e envia por syslog ao Wazuh, com decoders e regras próprios | Planeada (semana 10) |
| 5. Correlação e resposta | Regras Wazuh que juntam fluxo, IDS e identidade, painel dedicado, integração com a resposta automática existente, playbook por caso de uso | Planeada (semana 11) |

Variante opcional, só depois das camadas 1 a 4: sensor com Zeek na VLAN 70, alimentado por espelho da porta trunk (exige Open vSwitch).

## Validação

Cada teste tem controlo positivo (confirmar que o tráfego chegou ao ponto de observação) e repete-se pelo menos 5 vezes, com média e dispersão. Métricas em todos: deteção (sim ou não), tempo até ao alerta, atribuição correta ao utilizador, falsos positivos, carga de CPU e memória no OPNsense, volume de registos por dia. Ver [plano de testes](plano-de-testes.md).

## Documentos de política e procedimento

Os documentos curtos que o Quadro pede como evidência e que levantam vários níveis de uma vez.

| Documento | Subcategorias |
|---|---|
| [1. Modelo de referência de fluxos](politicas/01-modelo-referencia-fluxos.md) | DE.AE-1, ID.GA-3, PR.GA-5 |
| [2. Política de registos](politicas/02-politica-registos.md) | PR.TP-1, DE.MC-3 |
| [3. Política de acesso remoto](politicas/03-politica-acesso-remoto.md) | PR.GA-3 |
| [4. Registo de alterações e de revisões](politicas/04-registo-alteracoes-revisoes.md) | PR.GA-5, PR.TP-4, DE.AE-1 |
| [5. Procedimento de inventário](politicas/05-procedimento-inventario.md) | ID.GA-3 |
| [6. Procedimento de correlação de eventos](politicas/06-procedimento-correlacao-eventos.md) | DE.AE-3, DE.AE-1 |
