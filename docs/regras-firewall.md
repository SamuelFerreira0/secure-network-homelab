# Regras de firewall

Política geral: tudo é bloqueado por omissão (*default deny*). Só passa o que está na matriz abaixo, e todos os bloqueios são registados.

- Regras com estado: o tráfego de resposta é permitido, mas ninguém inicia ligações para a zona de Gestão.
- As regras usam aliases (um por zona e por serviço), para que cada fluxo seja legível e justificável.
- Em cada interface, o bloqueio geral é a última regra.
- Cada VM tem também a firewall do Proxmox com entrada e saída bloqueadas, como segunda camada.

## Matriz de fluxos

Todas as regras estão implementadas, exceto onde se indica.

| Origem | Destino | Permitido | Justificação |
|---|---|---|---|
| Gestão | OPNsense | SSH (22) e interface web (443) | Administração |
| Gestão | Servidores | SSH (22), HTTPS (443) para `glpi`, SMB (445) para `ficheiros` | Administração e partilha `ti` |
| Gestão | Monitorização | SSH (22), HTTPS (443) para o painel do `wazuh`, 1514 (TCP) para o agente do `admin-gestao` | Administração e monitorização |
| Gestão | DMZ | SSH (22) | Administração |
| Gestão | Internet | HTTP e HTTPS | Atualizações |
| Qualquer zona | Gestão | Nada (apenas respostas) | Proteger a administração |
| Gestão, Financeiro, Staff, Servidores e Monitorização | OPNsense | DNS (53) e NTP (123) | Resolução de nomes e hora |
| Financeiro | Servidores | SMB (445) para `ficheiros`, HTTPS (443) para `glpi` | Trabalho diário |
| Staff | Servidores | Os mesmos fluxos do Financeiro | Trabalho diário |
| Financeiro | Internet | HTTPS | Mais restrito do que o Staff |
| Staff | Internet | HTTP e HTTPS | Navegação |
| Financeiro e Staff | Entre si | Nada | Separação de departamentos |
| Convidados | Internet | HTTP, HTTPS e DNS (53) para o resolvedor público | Acesso de visitantes |
| Convidados | Zonas internas | Nada | Isolamento total |
| Gestão, Financeiro, Staff e Servidores | Monitorização | 1514 (TCP) para o `wazuh`. A 1515 abre-se só durante o registo dos agentes | Agentes de monitorização. Convidados e DMZ ficam sem agente |
| Servidores | Internet | HTTP e HTTPS (atualizações). **Em curso:** restringir aos repositórios (alias FQDN) e NTP para o OPNsense | Sem saída arbitrária |
| Servidores | Outras zonas | Nada (apenas respostas), exceto 1514 (TCP) para a Monitorização | Evitar movimento lateral |
| Monitorização | Internet | HTTP e HTTPS, sem redes privadas | Atualizações |
| Monitorização | Outras zonas | Nada (apenas respostas), exceto HTTPS (443) do `wazuh` para o OPNsense | A exceção serve a API da resposta automática |
| Internet (WAN) | DMZ | 80 e 443 para `portal`, por NAT | Portal de clientes |
| DMZ | Servidores | HTTPS (443) para `glpi` | Backend do portal |
| DMZ | OPNsense | DNS (53) | Resolução de nomes |
| DMZ | Restantes zonas e Internet | Nada | Limitar o dano de um portal comprometido |
| OPNsense | Monitorização | Syslog (UDP 514), só a partir do gateway da Monitorização | Registos da firewall |
| VPN (por perfil) | Zonas internas | As regras do departamento do perfil | Âmbito mínimo do acesso remoto |

## Segunda camada (Proxmox)

Cada VM tem a firewall do Proxmox com entrada e saída bloqueadas, DHCP permitido e só os fluxos da matriz. Para os bloqueios aparecerem nos registos, as regras explícitas levam `-log info`, porque só a política por omissão é registada por defeito.

## Exposição ao exterior

- NAT 80/443 do exterior para o portal (DMZ) e UDP 51820 para a VPN.
- O Proxmox nunca é exposto à Internet. A administração é só por Tailscale e pela rede de casa.

## Resposta automática

Quando a regra 100100 do Wazuh dispara, a origem é acrescentada ao alias `H_BLOQUEADOS` do OPNsense pela API. Uma regra floating bloqueia esse alias nas zonas Financeiro, Staff, Servidores, DMZ e VPN. Ao fim de 5 minutos a origem é retirada. A Gestão (incluindo a VPN da Gestão), a Monitorização e os gateways ficam sempre excluídos. Passos de configuração em `docs/configuracao-manual.md` e script em `scripts/opn-block.py`.

## Porquê estas regras

### DMZ (VLAN 60)

O portal é o único serviço publicado para a Internet por NAT, por isso é o ponto mais exposto da rede. Por essa razão só pode falar com o GLPI na porta 443 e com mais nada. Se for comprometido, o atacante fica preso à DMZ: não chega aos servidores de ficheiros, à Gestão nem aos postos de trabalho. Se esta regra fosse alargada, por exemplo a toda a VLAN dos servidores, um portal comprometido passava a ser uma porta de entrada para as partilhas.

### Gestão (VLAN 10)

A Gestão administra tudo, por isso é a zona mais valiosa: quem a controla controla a infraestrutura. Ninguém inicia ligações para lá, só entram as respostas às ligações que ela própria abre. Assim, um posto comprometido noutra zona não consegue sequer tentar ligar-se às máquinas de administração. Se o Staff pudesse iniciar ligações para a Gestão, um único posto comprometido passava a atacar diretamente a máquina de onde se administra tudo. A zona fica também sempre excluída do bloqueio automático do Wazuh, para que um falso positivo não deixe a administração sem acesso à rede.

### Financeiro e Staff (VLAN 30 e 40)

São dois departamentos com dados e permissões diferentes, e não têm razão para comunicar entre si. Se um posto do Staff for comprometido, não consegue varrer nem atacar os postos do Financeiro, onde estão os dados mais sensíveis. Cada zona só chega às partilhas e ao GLPI de que precisa. Sem esta regra, um único posto comprometido permitia movimento lateral entre departamentos, que é o passo seguinte típico de ataques como o do Target.

## Em curso

- Corte da saída dos servidores para a Internet
