# Registo de alterações e de revisões das regras

Documento 4 de 6 (rascunho de 24 de novembro de 2026). Serve de evidência para PR.GA-5, PR.TP-4 e DE.AE-1 (alinhada com o QNRCS, Quadro de Avaliação de Capacidades do CNCS).

## 1. Objetivo e âmbito

Garantir que qualquer alteração às regras que filtram ou vigiam o tráfego fica pedida, testada e registada, e que as regras são revistas de forma periódica. Cobre:

- firewall do OPNsense (regras por zona, aliases `H_*` e `P_*`, `H_BLOQUEADOS`);
- firewall do Proxmox (`cluster.fw` e um ficheiro `.fw` por VM ou contentor);
- lista de caminhos permitidos do proxy do portal (nginx);
- regras próprias do Wazuh (`local_rules.xml`) e respostas ativas.

As configurações estão no repositório (`configs/`), por isso o histórico do Git é a segunda fonte de verdade deste registo.

## 2. Procedimento de alteração

1. Pedido: descrever a alteração e o motivo (um teste novo, um risco detetado, uma correção).
2. Preparação: snapshot da VM ou do contentor afetado com o nome `pre-sN-<assunto>` e cópia do ficheiro de configuração antes de o tocar.
3. Alteração: uma de cada vez e só por quem está no registo de responsáveis.
4. Teste: confirmar o que deve passar e o que deve ser bloqueado, com controlo positivo (confirmar que o tráfego chega ao ponto de observação) e guardar o resultado num ficheiro de evidência.
5. Reversão: deixar escrito o comando de reversão antes de alterar. Se o teste falhar, reverter e registar o motivo.
6. Registo: acrescentar uma linha à tabela da secção 5 e exportar a configuração nova para o Git.

## 3. Procedimento de revisão

- Periodicidade proposta: uma revisão no fim de cada semana de projeto e após qualquer alteração que abra um fluxo. Depois do projeto, mensal. Esta periodicidade é uma proposta nossa, ajustável.
- O que se verifica: regras abertas que já não são necessárias, regras sem registo ativo onde deviam tê-lo, privilégios de contas de serviço, caminhos expostos no portal, e a coerência entre a matriz de fluxos e as regras reais.
- Saída: uma linha na tabela da secção 6, com as decisões e o prazo de cada uma.

## 4. Responsabilidades

- Quem altera: Samuel e Hugo, cada um nos componentes que mantém.
- Quem confirma: o outro elemento do grupo, antes de uma alteração passar a fazer parte da linha de base.

## 5. Registo de alterações

Este registo começa a 24 de novembro de 2026 (semana 8). As alterações anteriores constam dos registos semanais (semanas 4 a 7) e do histórico do Git. As horas são as dos snapshots indicados (fuso WET).

| Id | Data | Componente | Alteração | Motivo | Snapshot | Evidência | Reversão |
|---|---|---|---|---|---|---|---|
| A1 | 2026-11-24, 13:25 | LXC 230 (portal) | Firewall do Proxmox ativada (`230.fw`, `firewall=1` na `net0`), política de entrada e saída DROP. Entrada: 80 e 443. Saída: DNS para `10.10.60.1` e 443 para o GLPI (`10.10.20.30`) | O portal, o host mais exposto, só tinha a proteção do OPNsense | `pre-s8-fw` | `semana8-portal-fw-entrada.txt`, `semana8-portal-fw-saida.txt`, `semana8-caso3-portal.txt` | `pct set 230` com `firewall=0` na `net0` |
| A2 | 2026-11-24, 13:31 | LXC 230 (nginx do portal) | Proxy do portal limitado a uma lista de caminhos do Self-Service (resto responde 403). Depois do teste do fluxo do cliente foram acrescentados `ajax/timeline.php` e `front/itilfollowup.form.php` | O portal passava todo o GLPI à frente, incluindo a administração | `pre-s8-nginx` | `semana8-portal-nginx-caminhos.txt`, `semana8-portal-cliente-fluxo.txt` | Restaurar a cópia de segurança do ficheiro do site e `nginx -s reload` |

Alterações previstas depois da congelação de 1 de dezembro (serão registadas aqui quando feitas): A3 atualização do GLPI; redução dos privilégios da conta `wazuh-ar`; regra explícita com registo para SMB na firewall do Proxmox; as camadas 1 a 5.

## 6. Registo de revisões

| Id | Data | Âmbito | Revisor | Resultado | Decisões e prazo |
|---|---|---|---|---|---|
| R1 | 2026-11-24 | Revisão inicial, antes da congelação da linha de base | Samuel (confirmação do Hugo pendente) | Quatro pontos abertos, nenhum bloqueante | 1) `cluster.fw` ainda permite 22 e 8006 a partir de `192.168.1.0/24` e `100.64.0.0/10`: mantém-se, declarado como limitação de PR.GA-3. 2) A conta `wazuh-ar` pode editar qualquer alias do OPNsense: reduzir privilégios até 8 de dezembro, depois da congelação. 3) A firewall do Proxmox descarta SMB (135, 139, 445) sem registar: acrescentar regra explícita com registo depois da congelação. 4) Regras novas do portal verificadas (A1 e A2). |

## 7. Limitações

- Não há aprovação formal por uma terceira pessoa: a confirmação é entre os dois elementos do grupo.
- O registo é manual. A comparação automática entre a configuração ativa e a do Git está prevista como melhoria, não existe ainda.
