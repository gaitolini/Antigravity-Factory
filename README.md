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
curl -sSL https://raw.githubusercontent.com/gaitolini/antigravity-factory/main/init_antigravity.sh | bash -s -- --encapsulated --git --skills local
```

### 🪟 Windows PowerShell (Nativo)
```powershell
$s = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/gaitolini/antigravity-factory/main/init_antigravity.ps1"; & ([scriptblock]::Create($s)) -Interactive
```
*Dica: Se quiser rodar passando argumentos diretamente no PowerShell:*
```powershell
$s = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/gaitolini/antigravity-factory/main/init_antigravity.ps1"; & ([scriptblock]::Create($s)) -Encapsulated -GitInit -SkillsPack 'local'
```

---

## 📐 Opções de Layout de Pastas

A Fábrica oferece duas formas inteligentes de estruturar seu workspace:

### 💼 Opção A: Estrutura Encapsulada (`--encapsulated` / `-Encapsulated`)
Este layout é recomendado para manter as diretrizes do Agente (`.agents`) e o código fonte do projeto (`.projeto`) em pastas separadas, permitindo **versioná-los em repositórios Git independentes**.

```
[Pasta Raiz: Meu Projeto]
 ├── .agents/                          # Armazena todas as configurações do agente
 │    ├── .git/                        # Repositório Git do Agente (Isolado)
 │    ├── .gitignore
 │    ├── README.md                    # Documentação do Agente
 │    ├── hooks.json
 │    ├── rules/
 │    └── skills/
 ├── .projeto/                         # Armazena apenas o código-fonte real do projeto
 │    ├── .git/                        # Repositório Git do Projeto (Isolado)
 │    ├── .gitignore
 │    ├── README.md                    # Documentação do Projeto
 │    └── [arquivos e pastas do seu projeto diretamente aqui]
 ├── README.md                         # Documentação Geral do Workspace
 └── meu_projeto.code-workspace        # Arquivo de Workspace do VS Code
```
*Dica: Para trabalhar de forma integrada na IDE, basta abrir o arquivo `.code-workspace` gerado automaticamente na raiz!*

### 🌍 Opção B: Estrutura Global / Plana (Padrão)
Um layout clássico onde o agente fica em uma subpasta oculta e o código-fonte do projeto reside diretamente na raiz:

```
[Pasta Raiz: Meu Projeto]
 ├── .git/                             # Repositório Git Global
 ├── .gitignore
 ├── README.md                         # Documentação Geral do Projeto
 ├── .agents/
 │    ├── hooks.json
 │    ├── rules/
 │    └── skills/
 └── [arquivos e pastas do seu projeto diretamente na raiz]
```

---

## 📦 Integração com o `antigravity-awesome-skills`

Agora você pode puxar automaticamente o pacote de habilidades pré-configuradas do ecossistema:

* **Local (`--skills local`)**: Roda `npx antigravity-awesome-skills --path .agents/skills` para baixar todas as skills diretamente no seu projeto local, facilitando o ajuste fino de cada uma delas.
* **Global (`--skills global`)**: Executa `npx antigravity-awesome-skills` para uso e referência global.

---

## 🤝 Contribuição e Autoria

Este projeto foi idealizado e desenvolvido sob medida para o ecossistema Antigravity.

* **Autor**: [gaitolini](https://github.com/gaitolini)
* **Tecnologia**: Desenvolvido em parceria com o **Google Antigravity Agent**.
