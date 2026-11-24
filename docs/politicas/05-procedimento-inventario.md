# Procedimento de mapeamento e inventário de rede

Documento 5 de 6 (rascunho de 24 de novembro de 2026). Serve de evidência para ID.GA-3 (alinhada com o QNRCS, Quadro de Avaliação de Capacidades do CNCS). Versão 1.

## 1. Objetivo e âmbito

Manter uma lista fiável dos ativos da infraestrutura, da zona em que estão e dos fluxos que usam, e verificar que corresponde ao que existe de facto. Cobre VMs, contentores, o hipervisor, o OPNsense e os dispositivos que se ligam por VPN ou por Tailscale.

## 2. Inventário

A criticidade é uma proposta nossa, pela importância para o serviço e pelo risco. A "área" indica quem mantém o componente em termos de desenho (rede ou serviços e monitorização).

| Ativo | Id | Zona | Endereço | Função | Criticidade | Área |
|---|---|---|---|---|---|---|
| `opnsense` | VM 100 | Trunk de todas as VLANs | Gateways `.1` de cada VLAN | Firewall, router, DHCP, DNS, NTP, VPN, syslog | Alta | Rede |
| Hipervisor (`pve`) | Proxmox VE | Rede do computador | `192.168.1.10` | Aloja todas as VMs | Alta | Rede |
| `admin-gestao` | VM 211 | Gestão (10) | `10.10.10.10` | Administração (jump host) | Alta | Rede |
| `ficheiros` | VM 221 | Servidores (20) | `10.10.20.20` | Samba, partilhas | Alta (dados) | Serviços |
| `glpi` | VM 222 | Servidores (20) | `10.10.20.30` | Pedidos de suporte | Média | Serviços |
| `wazuh` | VM 223 | Monitorização (70) | `10.10.70.10` | Arquivo e análise de registos | Alta | Monitorização |
| `portal` | LXC 230 | DMZ (60) | `10.10.60.10` | Proxy do portal de clientes, o host mais exposto | Média | Rede |
| `cliente-financeiro` | VM 212 | Financeiro (30) | DHCP | Posto de trabalho | Baixa | Rede |
| `cliente-staff` | VM 213 | Staff (40) | DHCP | Posto de trabalho | Baixa | Rede |
| `cliente-convidado` | VM 214 | Convidados (50) | DHCP | Posto de visitante | Baixa | Rede |
| Modelos | VM 200 e VM 900 | Não correm | n/a | Templates Debian | Baixa | Rede |
| Perfis VPN | WireGuard | VPN (`10.10.90.0/24`) | Por utilizador | Acesso remoto | Média | Rede |

Neste momento o servidor WireGuard não tem perfis ativos. Dispositivos de administração fora da rede interna (portáteis dos autores, na Tailscale) estão fora do inventário de rede e declaram-se como caminho de gestão no documento 3.

## 3. Procedimento

1. **Registar ao criar:** todo o ativo novo (VM, contentor, perfil VPN) entra no inventário antes de ligar à rede, com zona, endereço, função e criticidade. A criação passa pelo registo de alterações (documento 4).
2. **Atribuir endereço e zona:** os servidores têm IP fixo abaixo de `.100`, e os clientes recebem reserva ou DHCP da sua VLAN. Os fluxos permitidos do ativo ficam no modelo de referência (documento 1).
3. **Verificar o que existe:** comparar o inventário com as fontes reais.
   - No hipervisor: `qm list` e `pct list`. Esperados, em execução: 100, 211, 212, 213, 214, 221, 222, 223 e 230.
   - No OPNsense: lista de concessões e reservas do Kea, por VLAN.
   - No Wazuh: `/var/ossec/bin/agent_control -l`. Esperados: cinco agentes ativos (`ficheiros`, `glpi`, `admin-gestao`, `cliente-financeiro`, `cliente-staff`).
4. **Tratar diferenças:** um ativo no sistema que não está no inventário, ou o contrário, abre um registo no documento 4. Um dispositivo desconhecido trata-se como incidente (documento 6) e a origem bloqueia-se.
5. **Remover ao desativar:** o ativo sai do inventário, e o endereço e as regras associadas são retirados.

## 4. Periodicidade e registo

A verificação do ponto 3 faz-se no fim de cada semana de projeto, junto com a revisão das regras. O resultado fica no registo de revisões (documento 4). Os diagramas e a tabela de endereçamento atualizam-se quando a rede muda.

## 5. Descoberta automática

Hoje o inventário verifica-se por comparação manual entre fontes. A descoberta automática está prevista na camada 2: NetFlow do OPNsense para um coletor open source, que passa a listar os endereços que realmente comunicam, e o relatório periódico dos fluxos.

## 6. Limitações

- A verificação não deteta um dispositivo que se ligue a uma VLAN com DHCP e não deixe concessão registada, até haver descoberta automática.
- Reservas por MAC e controlo de acesso à rede (NAC) estão em espera, por isso não há garantia de que só dispositivos registados acedem.
- A criticidade não resulta de uma avaliação de risco formal. A aferição do risco faz-se na semana 9.
