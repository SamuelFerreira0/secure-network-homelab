# Política de acesso remoto

Documento 3 de 6 (rascunho de 24 de novembro de 2026). Serve de evidência para PR.GA-3 (alinhada com o QNRCS, Quadro de Avaliação de Capacidades do CNCS). Versão 1.

## 1. Objetivo e âmbito

Definir quem pode aceder à infraestrutura a partir de fora das zonas internas, com que âmbito, sob que condições e como se revoga. Cobre dois tipos de acesso:

- **Acesso dos utilizadores da organização:** VPN WireGuard no OPNsense (UDP 51820), um perfil por utilizador.
- **Acesso administrativo ao laboratório:** SSH e painel do hipervisor Proxmox, por Tailscale ou pela rede do computador, e acesso de administração às aplicações (GLPI, painel do Wazuh).

## 2. Regras para os utilizadores da VPN

1. Cada utilizador tem um perfil próprio. O perfil não se partilha nem se empresta.
2. A chave privada fica só no dispositivo do utilizador. Não se envia por email, chat ou suporte, nem se guarda em locais partilhados.
3. A perda ou o roubo do dispositivo comunica-se de imediato à Gestão, que revoga o perfil.
4. O utilizador acede apenas aos recursos do seu departamento. O endereço do perfil define as regras de firewall que se lhe aplicam: Gestão `10.10.90.10` a `.19`, Financeiro `.30` a `.39`, Staff `.40` a `.49`.
5. Horário de referência: dias úteis, das 08:00 às 20:00. Ligações fora deste horário geram alerta (previsto na camada 4). O horário é uma proposta nossa, a validar.
6. O acesso é pessoal e registado. Qualquer tentativa de aceder a recursos fora do perfil é bloqueada e registada.

## 3. Regras de gestão

1. **Pedido e aprovação:** registados no GLPI (passo 1 do onboarding).
2. **Criação:** um par de chaves por utilizador, gerado pelo `onboard-user.sh`, com endereço da gama do departamento. O perfil é registado no OPNsense (chave pública e endereço).
3. **Aceitação:** o utilizador aceita esta política antes de receber o perfil. A aceitação regista-se na tabela da secção 6.
4. **Revisão dos acessos:** mensal (proposta nossa). Compara-se a lista de perfis do OPNsense com o registo de onboarding e com a auditoria de contas (`audit-accounts.sh`). O resultado fica no registo de revisões (documento 4).
5. **Revogação:** no offboarding, o perfil é removido do OPNsense e a ligação deixa de ter *handshake* (verificado no T15). Um perfil sem utilização ativa é revogado na revisão seguinte.
6. **Bloqueio proativo:** a resposta automática do Wazuh bloqueia durante 5 minutos a origem que faça varrimentos ou ligações proibidas, incluindo a partir da VPN. A zona de Gestão e a VPN de Gestão ficam sempre excluídas, para não bloquear a administração.

## 4. Acesso administrativo ao laboratório

| Acesso | Condição | Estado |
|---|---|---|
| SSH e painel do Proxmox (22 e 8006) | Só a partir da rede do computador (`192.168.1.0/24`) e da Tailscale (`100.64.0.0/10`), pela firewall do Proxmox | Ativo |
| SSH do hipervisor | Só por chave, sem palavra-passe | Ativo desde 24 de novembro de 2026 |
| Painel do Proxmox | 2FA (TOTP), com códigos de recuperação | Ativo, reativado a 24 de novembro de 2026 com dois autenticadores (um por elemento do grupo) |
| SSH das VMs | Só a partir de `admin-gestao` | Ativo, com tentativas e tempos limitados nas seis VMs. A palavra-passe ainda é aceite: o acesso só por chave está previsto |
| Administração do GLPI | 2FA (TOTP) na conta de administração | Ativo numa conta; a outra conta de administração por ativar |
| Portal de clientes | Só o fluxo Self-Service, com lista de caminhos permitidos | Ativo desde 24 de novembro de 2026 |

## 5. Controlo e monitorização

- WireGuard autentica por par de chaves e cifra o tráfego com a criptografia padrão do protocolo. Não gera registos de sessão.
- Hoje: os bloqueios da VPN entram no syslog do OPNsense e no Wazuh.
- Previsto (camada 4): script que recolhe o estado dos peers (último *handshake*, endpoint, volume), associa a chave ao utilizador e envia alertas por endpoint novo, fora de horas, mesmo peer em dois endpoints e volume anómalo.

## 6. Registo de aceitação

Cada utilizador da VPN aceita esta política antes de receber o perfil. O utilizador declara que leu e aceita a versão da política indicada, que não partilha o perfil e que comunica de imediato a perda do dispositivo.

| Utilizador | Departamento | Pedido (GLPI) | Data de aceitação | Versão da política | Endereço VPN | Revogado em |
|---|---|---|---|---|---|---|
| (sem entradas) | | | | | | |

O servidor WireGuard não tem perfis ativos neste momento, porque os de teste foram removidos. As primeiras entradas surgem quando se criarem os perfis para os testes de dezembro (T19 a T21). A tabela preenchida fica no registo de onboarding versionado, sem chaves.

## 7. Limitações

- Sem segundo fator na VPN. A mitigação é uma chave por utilizador, âmbito do departamento, revogação no offboarding e auditoria. O MFA no jump host é uma decisão por tomar.
- Autenticação federada não se aplica: não existe serviço de identidade central.
- O caminho de gestão do hipervisor pela Tailscale não é monitorizado pelo Wazuh.
- A segunda conta de administração do GLPI ainda não tem 2FA.
- A auditoria de contas ainda não verifica as chaves WireGuard.
