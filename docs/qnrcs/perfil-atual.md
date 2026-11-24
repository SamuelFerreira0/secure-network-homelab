# Perfil atual QNRCS (o "antes")

Rascunho v1 de 24 de novembro de 2026. Fica fixado como o "antes" a 1 de dezembro de 2026. Os critérios de cada nível estão na [matriz](matriz-conformidade.md).

Escala do Quadro de Avaliação de Capacidades do CNCS (v1.0, janeiro de 2020): 1 Inicial, 2 Intermédio, 3 Avançado, níveis cumulativos. "Parcial" quer dizer que parte das evidências exigidas pelo nível seguinte existe. Linguagem: alinhado com o QNRCS, nunca "conforme".

Evidências: os ficheiros das semanas 4 a 6 estão em `evidencias/`. Os da semana 8 (`semana8-*`) também. Ver o [índice](../../evidencias/README.md).

## 1. Resumo

| Código | Professor | Nossa avaliação | Alvo | O que falta para o alvo |
|---|---|---|---|---|
| DE.AE-1 | 0 a 1 | 1 (nível 2 por cumprir) | 2 | Modelo de referência formal, deteção de desvios em fluxos permitidos |
| DE.MC-1 | 1 | 1 a 2 | 2 a 3 | IDS de rede, correlação de várias fontes |
| PR.TP-4 | 1 a 2 | 2 | 2 | Nada para o alvo (nível 3 viável com registos de revisão) |
| DE.MC-3 | 1 | 1 | 2 | Atribuição a utilizador, padrões e métricas formalizados |
| DE.MC-7 | 1 | 1 a 2 | 2 | IDS, registos de acesso do lado SMB, relatórios de incidente |
| PR.GA-3 | 1 a 2 | 1 (formal) | 3 | Política e registo de aceitação, MFA na VPN, monitorização da VPN |
| PR.GA-5 | 2 | 2 parcial | 3 | Registo formal de alterações, revisões das regras, registos do Proxmox no Wazuh |
| ID.GA-3 | 2 | 2 parcial | 3 | Procedimento e política de inventário, descoberta automática |
| DE.AE-3 | 2 | 1 (nível 2 parcial) | 3 | Política e procedimento de correlação, lista de fontes |
| PR.TP-1 | 2 | 1 | 3 | Política de registos, integridade dos registos |

## 2. Detalhe

### DE.AE-1 Modelo de referência de fluxos
- Nível atribuído: 1. O nível 1 não tem critérios aplicáveis; o nível 2 não é cumprido.
- Evidência: matriz de fluxos e arquitetura (`docs/arquitetura.md`, `docs/regras-firewall.md`), deteção de bloqueios com a regra 100100 (`evidencias/semana6-deteccao-varrimento.txt`).
- Falta: matriz formalizada como modelo de referência com revisão (documento 1), deteção de desvios nos fluxos permitidos (camada 2, T18, T23). A evidência de formação cai fora de âmbito (PR.FC) e é declarada como limitação.

### DE.MC-1 Monitorização para detetar incidentes
- Nível atribuído: 1 a 2. Há monitorização central e resposta automática, mas não há IDS de rede.
- Evidência: Wazuh com syslog do pf e agentes, regras 100100 e 100110, resposta ativa (`evidencias/semana6-deteccao-varrimento.txt`, `evidencias/semana6-resposta-automatica.txt`, `evidencias/semana6-integridade.txt`).
- Falta: Suricata (camada 3), correlação de várias fontes (camada 5). "Equipa dedicada" e "dispositivos cadastrados" do nível 3 são lacunas justificadas.

### PR.TP-4 Redes de comunicações protegidas
- Nível atribuído: 2, com confiança média. Depende de a exigência "IDS/IPS, firewalls, proxies ou WAFs" ser alternativa. Se o Quadro exigir IDS, o nível desce para 1 a 2. A confirmar no PDF do Quadro antes de congelar.
- Evidência: diagrama com zonas (`docs/arquitetura.md`), firewall do OPNsense por zona e firewall do Proxmox por VM e contentor (`configs/proxmox/firewall/`), DMZ (`evidencias/semana4-t08-dmz.txt`), portal com lista de caminhos permitidos (`semana8-portal-nginx-caminhos.txt`, `semana8-portal-fw-entrada.txt`, `semana8-portal-fw-saida.txt`, `configs/nginx/`), HTTPS no GLPI.
- Falta para o nível 3: registos de revisão periódica das configurações e processo de alteração com validação (documento 4).
- Limitação a declarar: a versão do GLPI em uso tem correções de segurança entretanto publicadas, que ainda não foram aplicadas. O risco está mitigado pela lista de caminhos do portal (só o Self-Service chega ao GLPI) e pela falta de saída para a Internet na VM. A atualização fica prevista como alteração A3, depois da congelação.

### DE.MC-3 Atividade dos colaboradores
- Nível atribuído: 1.
- Evidência: Wazuh central e agentes em 5 máquinas, registos de autenticação SSH (`evidencias/semana6-ssh.txt`), auditoria de contas (`evidencias/semana6-auditoria-contas.txt`).
- Falta: a firewall só vê IP, não utilizador (camada 4, identidade da VPN, e registos de SMB com utilizador). Documento com padrões e métricas (documento 2).

### DE.MC-7 Acessos não autorizados
- Nível atribuído: 1 a 2.
- Evidência: regras 5710 e 5712 para SSH (`evidencias/semana6-ssh.txt`), auditoria de contas, integridade de ficheiros (`evidencias/semana6-integridade.txt`, com exclusões de `.log` e `.swp` documentadas em `semana8-fim-ficheiros.txt`), bloqueio automático (`evidencias/semana6-resposta-automatica.txt`).
- Falta: IDS (camada 3), registos de acesso a servidores do lado SMB, relatórios de incidente por teste (T17 a T21).

### PR.GA-3 Acessos remotos
- Nível atribuído: 1 (formal). Há controlos técnicos de nível 2 e 3, mas faltam os documentos que o Quadro pede como evidência fixada (política e registo de aceitação, documento 3).
- Evidência: WireGuard com perfis por departamento (`evidencias/semana5-vpn-perfis.txt`), onboarding e offboarding (`evidencias/semana5-t13-onboarding.txt`, `evidencias/semana5-t15-offboarding-vpn.txt`), bloqueio automático que inclui a VPN. Semana 8: SSH do hipervisor só por chave (`semana8-pve-ssh.txt`), 2FA do GLPI ativo numa conta de administração (`semana8-glpi-2fa.txt`), 2FA do Proxmox ativo desde 24 de novembro com dois autenticadores (`semana8-pve-2fa.txt`).
- Falta: registo de aceitação preenchido (sem perfis VPN ativos), MFA na VPN, monitorização específica (camada 4), registo de revisões.
- Limitações a declarar: a segunda conta de administração do GLPI ainda sem 2FA; o caminho de gestão do hipervisor pela Tailscale (`100.64.0.0/10` permitido no `cluster.fw`) não é monitorizado pelo Wazuh; autenticação federada fora de âmbito.

### PR.GA-5 Integridade das redes
- Nível atribuído: 2 parcial. O nível 2 pede registos de pedidos de alteração, que ainda não existiam como documento formal.
- Evidência: regras por zona com registo, matriz de fluxos, snapshots antes de cada alteração, registos semanais, testes T01 a T16, configurações exportadas para o Git. Semana 8: firewall do portal (`semana8-portal-fw-*.txt`, repetição do caso 3 em `semana8-caso3-portal.txt`), privilégios da conta `wazuh-ar` documentados (`semana8-wazuh-ar-privilegios.txt`).
- Falta: registo formal de alterações e de revisões das regras (documento 4), registos da firewall do Proxmox no Wazuh (camada 1, T22), relatório do teste de intrusão interno.
- Limitações a declarar: `wazuh-ar` pode editar qualquer alias (redução prevista até 8 de dezembro, depois da congelação); a firewall do Proxmox descarta SMB (135, 139, 445) sem registar; o `cluster.fw` ainda permite 8006 e 22 a partir da rede do computador e da Tailscale; versão do GLPI por atualizar (ver PR.TP-4).

### ID.GA-3 Redes e fluxos mapeados
- Nível atribuído: 2 parcial.
- Evidência: mapa de IP, topologia com zonas, matriz de fluxos (`docs/arquitetura.md`, `docs/regras-firewall.md`), aliases `H_*` e `P_*`, configurações exportadas (`configs/proxmox/`).
- Falta: procedimento de mapeamento e política de inventário (documento 5), descoberta automática (camada 2), relatório periódico dos fluxos.

### DE.AE-3 Eventos coletados e correlacionados
- Nível atribuído: 1. O nível 1 (recolha central) cumpre-se. Do nível 2 existe o sistema de correlação, faltam política, procedimento e registo das fontes (documento 6).
- Evidência: Wazuh com syslog do pf e agentes, correlação da regra 100100 (15 bloqueios da mesma origem em 30 s), lições nos registos semanais.
- Falta: documento 6 fixado, depois correlação de fluxo, IDS e identidade (camada 5). O ficheiro isco do plano é a evidência de honeypot do nível 3.

### PR.TP-1 Registos de auditoria
- Nível atribuído: 1. A recolha central existe. As políticas e os procedimentos documentados só existem em rascunho (documento 2).
- Evidência: Wazuh central, NTP no OPNsense, fuso horário uniforme. Medições da semana 8 (`semana8-opnsense-recursos.txt`, `semana8-volume-logs.txt`): OPNsense com 0,3 a 11,3 MB de registos por dia de utilização (média de cerca de 4,3 MB), firewall do Proxmox com 50 a 100 KB por dia, alertas do Wazuh com 0 a 517 KB por dia. O OPNsense tem 4 GB de RAM atribuídos, cerca de 0,6 GB em uso e 98,9% de CPU livre em repouso.
- Falta: política de registos fixada, integridade dos registos (por exemplo SHA-256 diário), retenção. Risco: o log da firewall do Proxmox só guarda 7 rotações diárias, por isso os registos do período da linha de base desaparecem cerca de 8 de dezembro se não forem copiados no dia do congelamento.

## 3. Pendentes antes de congelar

1. Critério de PR.TP-4 no PDF do Quadro (firewalls contam como evidência de nível 2?).
2. Confirmação do Hugo das partes dele (2FA da conta dele no GLPI, chave SSH do hipervisor, `audit-accounts.sh`).
3. Copiar `/var/log/pve-firewall.log*` para as evidências a 1 de dezembro.
