# 🚀 Fábrica Antigravity (Antigravity-Factory)

[![Antigravity Core](https://img.shields.io/badge/Antigravity-Core-blueviolet?style=for-the-badge)](https://github.com/gaitolini/antigravity-factory)
[![OS Support](https://img.shields.io/badge/OS-Windows%20%7C%20Linux%20%7C%20macOS-blue?style=for-the-badge)](#)

Uma ferramenta automatizada e de alto desempenho projetada para inicializar instantaneamente a estrutura padrão do **Google Antigravity** em novos projetos. Com um único comando, configure regras personalizadas, skills e bundles de plugins otimizados para guiar seus agentes de Inteligência Artificial de forma precisa e eficiente.

---

## ⚡ Instalação Rápida (One-Liner)

Escolha o terminal de sua preferência para rodar a Fábrica diretamente do GitHub no diretório raiz do seu novo projeto:

### 🐧 Terminal Bash (Linux / macOS / Git Bash / WSL)
```bash
curl -sSL https://raw.githubusercontent.com/gaitolini/antigravity-factory/main/init_antigravity.sh | bash -s -- --interactive
```
*Dica: Você pode pular a interatividade fornecendo parâmetros diretamente:*
```bash
curl -sSL https://raw.githubusercontent.com/gaitolini/antigravity-factory/main/init_antigravity.sh | bash -s -- --delphi --plugin meu-erp
```

### 🪟 Windows PowerShell (Nativo)
```powershell
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/gaitolini/antigravity-factory/main/init_antigravity.ps1" | Invoke-Expression
```
*Dica: Se quiser rodar com parâmetros específicos:*
```powershell
# Baixa e executa o script na sessão passando argumentos nomeados
$script = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/gaitolini/antigravity-factory/main/init_antigravity.ps1"
Invoke-Expression "& { $script -Delphi -PluginName 'meu-erp' }"
```

---

## 📁 Entendendo a Estrutura `.agents/` Gerada

A pasta oculta `.agents/` no diretório raiz é o núcleo de customização local do Antigravity. O script cria o seguinte layout inteligente:

```
[Diretório Raiz do Projeto]
 └── .agents/
      ├── hooks.json                     # Interceptadores globais de execução
      ├── rules/
      │    └── regras_projeto.md         # Diretrizes de estilo e arquitetura
      ├── skills/
      │    └── core-skill/
      │         └── SKILL.md             # Instruções específicas para tarefas complexas
      └── plugins/                       # (Opcional) Extensões agrupadas
           └── [nome-do-plugin]/
                ├── plugin.json          # Metadados e manifesto do plugin
                ├── mcp_config.json      # Configuração local de servidores MCP
                ├── hooks.json           # Hooks específicos deste plugin
                └── sidecars/
                     └── exemplo/
                          └── sidecar.json # Tarefas automáticas em background (e.g. compilação)
```

### 🧩 Componentes do Ecossistema

1. **`rules/`**: Arquivos Markdown com restrições e guias arquiteturais. O Agente de IA consome essas regras dinamicamente a cada turno para garantir conformidade de estilo (por exemplo, obrigando a codificação de arquivos Delphi em Windows-1252 ANSI).
2. **`skills/`**: Habilidades personalizadas que ampliam o raciocínio do Agente. Cada pasta de skill contém um `SKILL.md` com cabeçalho YAML (`name` e `description`). O Agente lê a descrição no início do chat e aciona as instruções da skill apenas quando necessário.
3. **`hooks.json`**: Permite rodar comandos personalizados de validação (como linters, testes de compilação ou checagens de segurança) antes ou depois que o Agente utiliza suas ferramentas.
4. **`plugins/`**: Super-pacotes modulares. Permitem que você distribua Skills, Rules, conexões de servidores MCP (`mcp_config.json`) e Sidecars em um único diretório isolado.

---

## 🛠️ Customização com Stacks Específicas

A Fábrica vem equipada com suporte para geração inteligente de diretrizes baseadas na sua tecnologia principal:

* **`--delphi` | `-Delphi`**: Configura automaticamente regras rígidas de segurança contra SQL Injection, injeção de dependências, injeção de transações curtas no Firebird e o padrão mandatório de codificação **Windows-1252 (ANSI)** para arquivos fonte Delphi.
* **`--python` | `-Python`**: Configura as melhores práticas da **PEP 8**, gerenciamento de ambientes virtuais (`.venv`) e tipagem estática (Type Hints).

---

## 🤝 Contribuição e Autoria

Este projeto foi idealizado e desenvolvido sob medida para o ecossistema Antigravity.

* **Autor**: [gaitolini](https://github.com/gaitolini)
* **Tecnologia**: Desenvolvido em parceria com o **Google Antigravity Agent**.
