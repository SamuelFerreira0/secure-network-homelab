# Evidências

Saídas de texto dos testes descritos em `docs/plano-de-testes.md` e das verificações feitas para o perfil QNRCS (`docs/qnrcs/perfil-atual.md`), guardadas no momento em que cada uma foi feita. Não foram editadas, a não ser para retirar segredos (o repositório é público).

## Testes e verificações já no repositório

| Ficheiros | Teste | Subcategorias QNRCS que sustenta |
|---|---|---|
| `T01-convidados.txt` | T01 | PR.TP-4, PR.GA-5 |
| `T02-controlo.txt`, `T02-financeiro.txt`, `T02-staff.txt` | T02 | PR.TP-4, PR.GA-5 |
| `T03-financeiro.txt`, `T03-staff.txt` | T03 | PR.TP-4, PR.GA-5 |
| `T04-211.txt` a `T04-214.txt`, `T04-nomes-servicos.txt` | T04 | PR.GA-5 |
| `T05-partilhas.txt` | T05 | PR.GA-5 |
| `T06-smb.txt` | T06 | PR.TP-4 |
| `semana4-t07-portal.txt` | T07 | PR.TP-4 |
| `semana4-t08-dmz.txt` | T08 | PR.TP-4 |
| `semana6-deteccao-varrimento.txt`, `semana6-resposta-automatica.txt` | T09 | DE.MC-1, DE.MC-7, DE.AE-1, DE.AE-3 |
| `semana6-ssh.txt` | T10 | DE.MC-3, DE.MC-7 |
| `semana6-integridade.txt` | T11 | DE.MC-1, DE.MC-7 |
| `semana5-t13-onboarding.txt` | T13 | PR.GA-3 |
| `semana5-vpn-perfis.txt` | T14 | PR.GA-3 |
| `semana5-t15-offboarding-samba.txt`, `semana5-t15-offboarding-vpn.txt` | T15 | PR.GA-3 |
| `semana6-auditoria-contas.txt` | T15 | DE.MC-3, DE.MC-7, PR.GA-3 |
| `semana4-ssh-mariadb.txt` | Verificação de portas por máquina (SSH e MariaDB dos servidores) | PR.TP-4 |

Os testes T01 a T04 são anteriores à mudança do Wazuh para a VLAN 70, por isso o `wazuh` aparece em `10.10.20.40`.

## Semana 8

Ficheiros `semana8-*` produzidos no hipervisor e verificados antes de entrarem aqui (sem segredos).

| Ficheiro | Para quê | Subcategorias QNRCS |
|---|---|---|
| `semana8-portal-fw-entrada.txt`, `semana8-portal-fw-saida.txt` | Firewall do Proxmox do portal (A1) | PR.TP-4, PR.GA-5 |
| `semana8-caso3-portal.txt` | Repetição do caso 3 com a firewall do portal | PR.GA-5 |
| `semana8-portal-nginx-caminhos.txt`, `semana8-portal-cliente-fluxo.txt` | Lista de caminhos permitidos do proxy (A2) e fluxo do cliente | PR.TP-4, PR.GA-5 |
| `semana8-pve-ssh.txt` | SSH do hipervisor só por chave | PR.GA-3 |
| `semana8-wazuh-ar-privilegios.txt`, `semana8-wazuh-ar-exclusoes.txt` | Privilégios da conta da resposta automática e exclusões da resposta | PR.GA-5, DE.MC-1 |
| `semana8-fim-ficheiros.txt` | Exclusões da integridade de ficheiros | DE.MC-7 |
| `semana8-limpeza-admin-gestao.txt` | Limpeza da VM de administração | PR.GA-5 |
| `semana8-opnsense-recursos.txt`, `semana8-volume-logs.txt` | CPU, RAM e volume de registos por dia | PR.TP-1 |
| `semana8-glpi-2fa.txt` | Estado do 2FA por conta do GLPI (transcrição, nomes trocados por papel) | PR.GA-3 |
| `semana8-pve-2fa.txt` | Fatores 2FA do Proxmox (dois autenticadores TOTP e códigos de recuperação, sem segredos nem identificadores) | PR.GA-3 |

## A recolher a 1 de dezembro

Cópia de `/var/log/pve-firewall.log*` do hipervisor, antes de a rotação (7 dias) apagar o período da linha de base. Ver `docs/politicas/02-politica-registos.md`.

## A partir da semana 9

Os testes T17 a T23 e as medições das camadas entram aqui com o prefixo `semanaN-` e passam a constar desta tabela, ligados à subcategoria que sustentam.
