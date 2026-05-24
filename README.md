# 🚀 Fábrica Antigravity (Antigravity-Factory)

[![Antigravity Core](https://img.shields.io/badge/Antigravity-Core-blueviolet?style=for-the-badge)](https://github.com/gaitolini/antigravity-factory)
[![OS Support](https://img.shields.io/badge/OS-Windows%20%7C%20Linux%20%7C%20macOS-blue?style=for-the-badge)](#)

Uma ferramenta automatizada e de alto desempenho projetada para inicializar instantaneamente a estrutura padrão do **Google Antigravity** em novos projetos. Com suporte a versionamento Git isolado, estruturas encapsuladas organizadas por espaços de trabalho e instalação direta de pacotes de skills.

---

## ⚡ Instalação Rápida (One-Liner)

Escolha o terminal de sua preferência para rodar a Fábrica diretamente do GitHub no diretório raiz do seu novo projeto:

### 🐧 Terminal Bash (Linux / macOS / Git Bash / WSL)
```bash
curl -sSL https://raw.githubusercontent.com/gaitolini/antigravity-factory/main/init_antigravity.sh | bash -s -- --interactive
```
*Dica: Você pode pular a interatividade fornecendo parâmetros diretamente:*
```bash
curl -sSL https://raw.githubusercontent.com/gaitolini/antigravity-factory/main/init_antigravity.sh | bash -s -- --delphi --encapsulated --git --skills l
```

### 🪟 Windows PowerShell (Nativo)
```powershell
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/gaitolini/antigravity-factory/main/init_antigravity.ps1" | Invoke-Expression
```
*Dica: Se quiser rodar com parâmetros específicos no Windows:*
```powershell
# Baixa e executa o script na sessão passando argumentos nomeados
$script = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/gaitolini/antigravity-factory/main/init_antigravity.ps1"
Invoke-Expression "& { $script -Delphi -Encapsulated -GitInit -SkillsPack 'local' }"
```

---

## 📐 Opções de Layout de Pastas

A versão 2.0 da Fábrica oferece duas formas inteligentes de estruturar seu workspace:

### 💼 Opção A: Estrutura Encapsulada (`--encapsulated` / `-Encapsulated`)
Este layout é recomendado para manter as diretrizes do Agente (`.agents`) e o código fonte do projeto (`.projeto`) em pastas separadas, permitindo inclusive **versioná-los em repositórios Git independentes**.

```
[Pasta Raiz: Meu Projeto]
 ├── .agents/                          # Armazena todas as configurações do agente
 │    ├── .git/                        # Repositório Git do Agente (Isolado)
 │    ├── .gitignore
 │    ├── hooks.json
 │    ├── rules/
 │    └── skills/
 ├── .projeto/                         # Armazena apenas o código-fonte real do projeto
 │    ├── .git/                        # Repositório Git do Projeto (Isolado)
 │    ├── .gitignore                   # Regras de build específicas (Delphi, Python, etc.)
 │    └── [arquivos e pastas do seu projeto]
 └── meu_projeto.code-workspace        # Arquivo de Workspace do VS Code
```
*Dica: Para trabalhar de forma integrada na IDE, basta abrir o arquivo `.code-workspace` gerado automaticamente na raiz!*

### 🌍 Opção B: Estrutura Global / Plana (Padrão)
Um layout clássico onde o agente fica em uma subpasta oculta e o código-fonte do projeto reside diretamente na raiz:

```
[Pasta Raiz: Meu Projeto]
 ├── .git/                             # Repositório Git Global
 ├── .gitignore
 ├── .agents/
 │    ├── hooks.json
 │    ├── rules/
 │    └── skills/
 └── [arquivos e pastas do seu projeto diretamente na raiz]
```

---

## 📦 Integração com o `antigravity-awesome-skills`

Agora você pode puxar automaticamente o pacote de habilidades pré-configuradas do ecossistema:

* **Local (`--skills l`)**: Roda `npx antigravity-awesome-skills --path .agents/skills` para baixar todas as skills diretamente no seu projeto local, facilitando o ajuste fino de cada uma delas.
* **Global (`--skills g`)**: Executa `npx antigravity-awesome-skills` para uso e referência global.

---

## 🛠️ Customização com Stacks Específicas

A Fábrica vem equipada com suporte para geração inteligente de diretrizes e arquivos `.gitignore` específicos:

* **`--delphi` | `-Delphi`**: Configura automaticamente regras rígidas de segurança contra SQL Injection, injeção de dependências, transações curtas no Firebird e o padrão mandatório de codificação **Windows-1252 (ANSI)** para arquivos fonte Delphi. Também gera um `.gitignore` que ignora pastas `__history`, `dcu` e arquivos temporários Delphi.
* **`--python` | `-Python`**: Configura as melhores práticas da **PEP 8**, gerenciamento de ambientes virtuais (`.venv`) e tipagem estática (Type Hints). Gera um `.gitignore` que descarta `.venv`, `__pycache__` e cache de testes.

---

## 🤝 Contribuição e Autoria

Este projeto foi idealizado e desenvolvido sob medida para o ecossistema Antigravity.

* **Autor**: [gaitolini](https://github.com/gaitolini)
* **Tecnologia**: Desenvolvido em parceria com o **Google Antigravity Agent**.
