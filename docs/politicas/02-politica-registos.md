# Política de registos

Documento 2 de 6 (rascunho de 24 de novembro de 2026). Serve de evidência para PR.TP-1 e DE.MC-3 (alinhada com o QNRCS, Quadro de Avaliação de Capacidades do CNCS).

Cada ponto indica o estado atual ou o que está previsto. O que ainda não existe fica marcado "a implementar", com a camada ou a semana em que entra, e passa a ser registado como alteração (documento 4) porque só avança depois da congelação da linha de base de 1 de dezembro.

## 1. Objetivo e âmbito

Definir o que se regista, onde se guarda, durante quanto tempo, quem revê e como se protege a integridade dos registos. Aplica-se à infraestrutura do projeto: OPNsense, hipervisor Proxmox, servidores (GLPI, ficheiros, portal) e Wazuh.

## 2. O que se regista e onde

| Fonte | O que gera | Onde fica | Estado |
|---|---|---|---|
| OPNsense (firewall) | Tráfego bloqueado e regras com registo ativo | `/var/log/filter/filter_AAAAMMDD.log` no OPNsense e syslog para o Wazuh | Ativo |
| Firewall do Proxmox | Descartes de política por VM e contentor | `/var/log/pve-firewall.log` no hipervisor | Ativo, sem envio para o Wazuh (camada 1) |
| Agentes Wazuh (5 máquinas) | Autenticação SSH, integridade de ficheiros, auditoria de contas | Wazuh, `/var/ossec/logs/alerts/` | Ativo |
| Wazuh (manager) | Alertas e respostas ativas | `/var/ossec/logs/alerts/` e `active-responses.log` | Ativo |
| VPN (WireGuard) | Estado dos peers e identidade do utilizador | Wazuh, por script próprio | A implementar (camada 4) |
| IDS (Suricata) e fluxos (NetFlow) | Alertas e fluxos | Wazuh e coletor de fluxos | A implementar (camadas 2 e 3) |

O Wazuh grava alertas, não todos os eventos recebidos (a confirmar: não encontrámos ficheiros de arquivo). O que não chega a ser alerta fica apenas nos ficheiros da fonte.

## 3. Volumes medidos (semana 8)

| Fonte | Volume por dia |
|---|---|
| OPNsense, ficheiros de filtro | 0,3 a 11,3 MB (média de cerca de 4,3 MB, só nos dias em que o laboratório esteve ligado) |
| Firewall do Proxmox | 50 a 100 KB |
| Alertas do Wazuh | 0 a 517 KB (valores dos dias já comprimidos estão subestimados) |

O OPNsense tem 4 GB de RAM atribuídos, cerca de 0,6 GB em uso e 98,9% de CPU livre em repouso. Os valores servem de referência para medir o efeito das camadas novas.

## 4. Retenção

| Fonte | Hoje | Regra proposta |
|---|---|---|
| OPNsense, ficheiros de filtro | Mantidos desde 3 de outubro (28 ficheiros) | 90 dias |
| Alertas do Wazuh | Mantidos no mês corrente e anteriores | 90 dias |
| Firewall do Proxmox | 7 rotações diárias (o mais antigo é cerca de 17 de novembro) | 90 dias (a implementar na camada 1, ajuste do `logrotate`) |

O prazo de 90 dias é uma proposta nossa: com os volumes medidos, o armazenamento necessário é de poucas centenas de MB. Não vem de nenhuma exigência do Quadro nem de regulamento. Os registos do período da linha de base são copiados para as evidências a 1 de dezembro, para que a rotação do Proxmox não os apague.

## 5. Relógios e fuso horário

Os sistemas sincronizam a hora por NTP com o OPNsense como origem e usam o mesmo fuso horário, para os registos de fontes diferentes se poderem correlacionar. A verificação do desvio de relógio entre fontes passa a fazer parte da revisão semanal.

## 6. Integridade dos registos

- Hoje: o Wazuh tem verificação de integridade nos ficheiros das partilhas, mas não nos próprios registos.
- A implementar (camada 1): cálculo diário de um SHA-256 dos ficheiros de alertas e dos ficheiros de filtro, guardado fora do sistema que os produz.

## 7. Acesso e revisão

- Acesso: só Samuel e Hugo, por conta nominal. Os registos incluem IP, utilizador e nomes de domínio, por isso não se copiam para fora do grupo.
- Revisão semanal dos alertas do Wazuh, no fim de cada semana de projeto, com o registo no documento 4.
- Métricas acompanhadas: alertas por dia, bloqueios automáticos por dia, volume de registos por fonte por dia, autenticações falhadas por origem e, quando existir a identidade da VPN (camada 4), acessos por utilizador e fora do horário definido na política de acesso remoto.

## 8. Limitações

- A firewall do Proxmox descarta SMB (135, 139, 445) sem registar: faltam registos desse tráfego até haver regra explícita.
- Hoje a firewall só vê o IP de origem, não o utilizador. A atribuição a utilizador depende da camada 4.
- O volume do OPNsense é de laboratório. Os testes de varrimento e bloqueio aumentam-no, por isso não representa uma organização real.
