# Modelo de referência de fluxos

Documento 1 de 6 (rascunho de 24 de novembro de 2026). Serve de evidência para DE.AE-1, ID.GA-3 e PR.GA-5 (alinhada com o QNRCS, Quadro de Avaliação de Capacidades do CNCS). Versão 1.

## 1. Objetivo e âmbito

O modelo de referência descreve os fluxos de comunicação que a organização aceita como normais. Tudo o que não está nele é bloqueado por omissão. Serve para duas coisas: justificar cada regra de firewall e permitir detetar desvios. Parte da matriz de fluxos do projeto e acrescenta o que mudou na semana 8. As alterações seguintes registam-se no documento 4.

## 2. Zonas

| VLAN | Zona | Sub-rede |
|---|---|---|
| 10 | Gestão | `10.10.10.0/24` |
| 20 | Servidores | `10.10.20.0/24` |
| 30 | Financeiro | `10.10.30.0/24` |
| 40 | Staff | `10.10.40.0/24` |
| 50 | Convidados | `10.10.50.0/24` |
| 60 | DMZ | `10.10.60.0/24` |
| 70 | Monitorização | `10.10.70.0/24` |
| VPN | WireGuard | `10.10.90.0/24` |

## 3. Fluxos de referência

| Id | Origem | Destino | Serviço e porta | Justificação |
|---|---|---|---|---|
| F01 | Gestão | OPNsense | SSH 22, HTTPS 443 | Administração |
| F02 | Gestão | Servidores | SSH 22; HTTPS 443 para `glpi`; SMB 445 para `ficheiros` | Administração e partilha `ti` |
| F03 | Gestão | Monitorização | SSH 22; HTTPS 443 para `wazuh`; TCP 1514 | Administração e agente do `admin-gestao` |
| F04 | Gestão | DMZ | SSH 22 | Administração |
| F05 | Gestão | Internet | HTTP, HTTPS | Atualizações |
| F06 | Qualquer zona | Gestão | Nada (só respostas) | Proteger a administração |
| F07 | Gestão, Financeiro, Staff, Servidores, Monitorização | OPNsense | DNS 53, NTP 123 | Nomes e hora |
| F08 | Financeiro e Staff | Servidores | SMB 445 para `ficheiros`; HTTPS 443 para `glpi` | Trabalho diário |
| F09 | Gestão, Financeiro, Staff, Servidores | Monitorização | TCP 1514 para `wazuh` (1515 fechada) | Agentes |
| F10 | Financeiro | Internet | HTTPS | Mais restrito do que o Staff |
| F11 | Staff | Internet | HTTP, HTTPS | Navegação |
| F12 | Financeiro e Staff | Entre si | Nada | Separação de departamentos |
| F13 | Convidados | Internet | HTTP, HTTPS, DNS 53 para `9.9.9.9` | Acesso de visitantes |
| F14 | Convidados | Zonas internas | Nada | Isolamento total |
| F15 | Servidores | Internet | HTTP e HTTPS só para `H_REPOS`; NTP para o OPNsense | Atualizações, sem saída arbitrária |
| F16 | Servidores | Outras zonas | Nada (só respostas), exceto F09 | Evitar movimento lateral |
| F17 | Monitorização | Internet | HTTP, HTTPS | Atualizações |
| F18 | Monitorização | OPNsense | HTTPS 443 | API da resposta automática |
| F19 | OPNsense | `wazuh` | Syslog UDP 514, só de `10.10.70.1` | Registos da firewall |
| F20 | Internet (WAN) | DMZ | 80 e 443 para `portal`, por NAT | Portal de clientes |
| F21 | DMZ (`portal`) | Servidores | HTTPS 443 para `glpi` | Backend do portal |
| F22 | DMZ (`portal`) | OPNsense | DNS 53 | Nomes |
| F23 | DMZ | Restantes zonas e Internet | Nada | Limitar o dano de um portal comprometido |
| F24 | VPN (por perfil) | Zonas internas | As regras do departamento do perfil | Âmbito mínimo do acesso remoto |
| F25 | Rede do computador e Tailscale | Hipervisor | TCP 22 e 8006 | Administração do laboratório (firewall do Proxmox, `cluster.fw`) |
| F26 | Zonas internas | Internet | DNS 53 e 853 bloqueados (exceto Convidados) | DNS forçado |

Notas:

- F20 a F23 mudaram na semana 8: o portal tem agora firewall do Proxmox (entrada 80 e 443, saída só DNS e `glpi:443`) e o proxy só encaminha os caminhos do Self-Service (registo A1 e A2, documento 4).
- F25 é um caminho de gestão fora do OPNsense e não é monitorizado pelo Wazuh. Fica declarado como limitação.
- O DNS sobre HTTPS (443) não se distingue por porta, por isso F26 não o cobre.
- `H_REPOS` (F15) resolve nomes para IP de CDN partilhados, por isso permite mais destinos do que os repositórios pretendidos. Limitação declarada.

## 4. Como se deteta um desvio

- **Hoje:** o tráfego bloqueado fica registado no OPNsense e no Wazuh. A regra 100100 (15 bloqueios da mesma origem interna em 30 s) deteta varrimentos e comunicações proibidas, e a resposta automática bloqueia a origem durante 5 minutos.
- **Lacuna (ponto cego 1):** o tráfego permitido, mas fora do padrão normal (por exemplo, uma cópia em massa de uma partilha por uma porta já permitida), não é detetado.
- **Previsto:** NetFlow no OPNsense (camada 2) e a linha de base de 24 h de tráfego normal (T23) para comparar com o modelo. T18 testa a exfiltração por volume.

## 5. Revisão e versões

O modelo revê-se com as regras (documento 4): no fim de cada semana de projeto e depois de qualquer alteração que abra um fluxo. Cada alteração aprovada atualiza esta tabela e incrementa a versão.

| Versão | Data | Alteração |
|---|---|---|
| 1 | 2026-11-24 | Formalização da matriz de fluxos do projeto, com as alterações do portal da semana 8 |

## 6. Limitações

- O modelo descreve fluxos permitidos por porta e zona. Não tem volumes nem horários normais, que só existem depois do T23.
- A formação dos colaboradores para tratar desvios está fora de âmbito (PR.FC). O guia de tratamento de alertas (documento 6) cobre essa lacuna.
