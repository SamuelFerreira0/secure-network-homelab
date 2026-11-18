# Configurações

Exemplos de configuração, com os valores sensíveis retirados.

## Incluído

- `wazuh/local_rules.xml`: regras próprias 100100 (varrimentos entre zonas internas) e 100110 (alteração em massa nas partilhas)
- `wazuh/ossec-snippets.xml`: receção do syslog da firewall, comando e resposta ativa que ligam a regra 100100 ao script `scripts/opn-block.py`
- `wazuh/ossec-agente-ficheiros.xml`: integridade em tempo real das partilhas, no agente do `ficheiros`
- `wazuh/opnsense-ar.conf.example`: formato do ficheiro de credenciais da API (o real fica no Wazuh)
- `samba/smb.conf`: configuração efetiva do servidor de ficheiros
- `nginx/portal.conf`: proxy inverso da DMZ para o GLPI
- `ssh/10-reforco.conf`: reforço do SSH aplicado nas seis VMs

## Limitações conhecidas

- `nginx/portal.conf`: `proxy_ssl_verify off`, porque o GLPI usa um certificado autoassinado. A ligação do portal ao GLPI não valida o certificado.
- `scripts/opn-block.py`: a ligação à API do OPNsense também não valida o certificado.
- `samba/smb.conf`: a assinatura SMB obrigatória ainda não está ativa.
- `ssh/10-reforco.conf`: limita tentativas e tempos, mas o SSH ainda aceita palavra-passe. O acesso só por chave está previsto.
