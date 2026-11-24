# Matriz de maturidade QNRCS

Rascunho de 24 de novembro de 2026. Critérios dos níveis tirados do Quadro de Avaliação de Capacidades do CNCS (v1.0, janeiro de 2020), com os códigos do QNRCS 2019. Falta a coluna de equivalência com a versão de 2026 (Anexo I do Regulamento n.º 756/2026). Linguagem: alinhado com o QNRCS, nunca "conforme".

O que existe hoje, com evidência, está no [perfil atual](perfil-atual.md). Esta matriz diz o que cada nível pede e o que levanta cada nível. As colunas "Alcançado" e "Estado" (cumpre, parcial, lacuna justificada) preenchem-se na reavaliação final.

## 1. Resumo

| Código | Professor | Atual (nossa) | Alvo | Camada ou teste | Alcançado | Estado |
|---|---|---|---|---|---|---|
| DE.AE-1 | 0 a 1 | 1 | 2 | Camadas 2 e 3, T18, T23 | por medir | por avaliar |
| DE.MC-1 | 1 | 1 a 2 | 2 a 3 | Camadas 3 e 5, T17 | por medir | por avaliar |
| PR.TP-4 | 1 a 2 | 2 | 2 (3 viável) | Camada 3, T17 | por medir | por avaliar |
| DE.MC-3 | 1 | 1 | 2 | Camadas 4 e 5, T17, T20 | por medir | por avaliar |
| DE.MC-7 | 1 | 1 a 2 | 2 | Camadas 1 e 3, T18, T19 | por medir | por avaliar |
| PR.GA-3 | 1 a 2 | 1 | 3 | Camada 4, MFA, T19, T20, T21 | por medir | por avaliar |
| PR.GA-5 | 2 | 2 parcial | 3 | Camada 1, T22 | por medir | por avaliar |
| ID.GA-3 | 2 | 2 parcial | 3 | Camada 2 | por medir | por avaliar |
| DE.AE-3 | 2 | 1 | 3 | Camada 5, T21, T23 | por medir | por avaliar |
| PR.TP-1 | 2 | 1 | 3 | Camadas 1 e 5, T22 | por medir | por avaliar |

Diferenças face à estimativa do professor, a defender: PR.GA-3, DE.AE-3 e PR.TP-1 ficam abaixo, porque o nível 2 pede documentos de política ou procedimento que só agora passam a existir como evidência fixada. DE.MC-1 e DE.MC-7 ficam um pouco acima, porque a deteção e o bloqueio automático já funcionam e têm testes.

## 2. O que cada nível pede

### ID.GA-3 Redes e fluxos mapeados
- Nível 2: mapa de IP, topologia com zonas e ativos críticos, mapa de fluxo de comunicações, procedimentos de mapeamento, documento do fluxo seguro de dados, política de inventários.
- Nível 3: inventário mantido com ferramentas automáticas de descoberta, indicadores, revisão periódica, relatórios de acompanhamento dos fluxos.

### PR.GA-5 Integridade das redes
- Nível 2: topologia e regras documentadas, qualquer alteração de regras registada, equipamentos que produzem registos de operação e auditoria, registos de pedidos de alteração.
- Nível 3: revisões das regras, monitorização dos equipamentos de rede, alterações só após validação, relatórios de testes de intrusão, testes dos controlos.

### PR.TP-4 Redes de comunicações protegidas
- Nível 2: diagrama com segmentação por zonas, IDS/IPS, firewalls, proxies ou WAFs a filtrar dados em trânsito. A leitura "ou" está por confirmar no PDF do Quadro.
- Nível 3: revisão periódica das configurações dos filtros e alterações com processo de validação sistematizado, com registo da gestão de alteração.

### DE.AE-1 Modelo de referência de fluxos
- Nível 1: sem critérios aplicáveis.
- Nível 2: alterações nos fluxos detetadas, colaboradores capazes de tratar desvios (evidência: registo de formação), modelos de referência estabelecidos, padrões e procedimentos.
- Nível 3: revisão periódica dos modelos de referência, com registos de alteração.

### DE.MC-1 Monitorização para detetar incidentes
- Nível 2: sistemas de monitorização e proteção da rede (IDS/IPS, WAF).
- Nível 3: associação de eventos de origens distintas, acessos a ativos só para dispositivos cadastrados e registados, equipa dedicada à gestão de incidentes.

### DE.MC-3 Atividade dos colaboradores
- Nível 2: registos de eventos que identificam o responsável, padrões e métricas de monitorização formalizados, armazenamento central.

### DE.MC-7 Acessos não autorizados
- Nível 2: pedidos de acesso a infraestruturas e servidores monitorizados, dados centralizados, IDS, registos de acesso aos servidores.
- Nível 3: sistema de correlação e relatórios de incidentes.

### PR.GA-3 Acessos remotos
- Nível 2: política de acesso remoto com registo de aceitação, controlo centralizado, VPN com criptografia adequada.
- Nível 3: bloqueio proativo, autenticação federada, MFA, monitorização específica, revisão regular dos acessos e do tráfego, registos de revisões.

### DE.AE-3 Eventos coletados e correlacionados
- Nível 1: eventos coletados centralmente.
- Nível 2: política e procedimento de gestão e correlação, registo das fontes usadas, sistema de correlação.
- Nível 3: melhoria contínua com lições de eventos anteriores, mecanismos de controlo de um evento. As evidências incluem honeypots geridos.

### PR.TP-1 Registos de auditoria
- Nível 2: políticas e normas de coleta e análise, procedimentos documentados, sistema de coleta e análise.
- Nível 3: controlos técnicos de integridade dos registos (hash, sincronização de relógios, timestamping), armazenamento e correlação centralizados.

## 3. Documentos que levantam vários níveis de uma vez

| Documento | Subcategorias |
|---|---|
| [1. Modelo de referência de fluxos](../politicas/01-modelo-referencia-fluxos.md) | DE.AE-1, ID.GA-3, PR.GA-5 |
| [2. Política de registos](../politicas/02-politica-registos.md) | PR.TP-1, DE.MC-3 |
| [3. Política de acesso remoto](../politicas/03-politica-acesso-remoto.md) | PR.GA-3 |
| [4. Registo de alterações e de revisões](../politicas/04-registo-alteracoes-revisoes.md) | PR.GA-5, PR.TP-4, DE.AE-1 |
| [5. Procedimento de inventário](../politicas/05-procedimento-inventario.md) | ID.GA-3 |
| [6. Procedimento de correlação de eventos](../politicas/06-procedimento-correlacao-eventos.md) | DE.AE-3, DE.AE-1 |

## 4. Lacunas a declarar como limitação

- Equipa dedicada de gestão de incidentes (DE.MC-1, nível 3): o grupo tem duas pessoas.
- Dispositivos cadastrados e registados (DE.MC-1, nível 3): só com NAC ou reservas por MAC, em espera.
- Formação dos colaboradores (DE.AE-1, nível 2): PR.FC fora de âmbito. O guia de tratamento de alertas (documento 6) é a medida declarada em substituição.
- Autenticação federada (PR.GA-3, nível 3): sem serviço de identidade central.
- Testes de intrusão (PR.GA-5, nível 3): só internos, feitos pelos próprios autores.
