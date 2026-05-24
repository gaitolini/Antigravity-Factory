#!/bin/bash

# ==============================================================================
# FÁBRICA ANTIGRAVITY - SCRIPT DE INICIALIZAÇÃO BASH
# Repositório: gaitolini/antigravity-factory
# ==============================================================================

# Cores para o terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m' # Sem Cor

echo -e "${PURPLE}============================================================${NC}"
echo -e "${CYAN}   🚀  Fábrica de Estrutura Antigravity - Inicializador  🚀   ${NC}"
echo -e "${PURPLE}============================================================${NC}"

# Valores padrão
PROJECT_NAME="Novo Projeto Antigravity"
PLUGIN_NAME=""
TECH_STACK=""
INTERACTIVE=false

# Ajuda
show_help() {
    echo -e "Uso: $0 [opções]"
    echo -e ""
    echo -e "Opções:"
    echo -e "  -n, --name <nome>      Nome do projeto (Padrão: '$PROJECT_NAME')"
    echo -e "  -pl, --plugin <nome>   Nome do plugin a ser criado (opcional)"
    echo -e "  -d, --delphi           Configura templates específicos para Delphi"
    echo -e "  -p, --python           Configura templates específicos para Python"
    echo -e "  -i, --interactive      Modo interativo perguntando opções"
    echo -e "  -h, --help             Exibe esta mensagem de ajuda"
    echo -e ""
    echo -e "Exemplo rápido:"
    echo -e "  curl -sSL https://raw.githubusercontent.com/gaitolini/antigravity-factory/main/init_antigravity.sh | bash -s -- --delphi --plugin meu-erp"
}

# Parse de argumentos
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -n|--name) PROJECT_NAME="$2"; shift ;;
        -pl|--plugin) PLUGIN_NAME="$2"; shift ;;
        -d|--delphi) TECH_STACK="delphi" ;;
        -p|--python) TECH_STACK="python" ;;
        -i|--interactive) INTERACTIVE=true ;;
        -h|--help) show_help; exit 0 ;;
        *) echo -e "${RED}❌ Opção desconhecida: $1${NC}"; show_help; exit 1 ;;
    esac
    shift
done

# Modo interativo se solicitado
if [ "$INTERACTIVE" = true ]; then
    echo -e "${YELLOW}📝 Entrando no modo interativo...${NC}"
    read -p "Digite o nome do projeto [$PROJECT_NAME]: " temp_name
    [ -n "$temp_name" ] && PROJECT_NAME="$temp_name"

    read -p "Deseja inicializar um plugin específico? (Deixe em branco para nenhum): " temp_plugin
    [ -n "$temp_plugin" ] && PLUGIN_NAME="$temp_plugin"

    echo -e "Selecione uma stack de tecnologia:"
    echo -e "  1) Nenhuma (Genérico)"
    echo -e "  2) Delphi (Windows-1252, ERP, Firebird)"
    echo -e "  3) Python (venv, pip/poetry, Clean Code)"
    read -p "Opção (1-3): " opt_tech
    case $opt_tech in
        2) TECH_STACK="delphi" ;;
        3) TECH_STACK="python" ;;
        *) TECH_STACK="" ;;
    esac
fi

# Função auxiliar para criar arquivos se eles não existirem
create_if_not_exists() {
    local filepath="$1"
    local content="$2"
    
    # Criar pasta pai se não existir
    mkdir -p "$(dirname "$filepath")"
    
    if [ ! -f "$filepath" ]; then
        echo -e "$content" > "$filepath"
        echo -e "  ${GREEN}✅ Criado:${NC} $filepath"
    else
        echo -e "  ${YELLOW}⚡ Já existe (ignorado):${NC} $filepath"
    fi
}

echo -e "\n${BLUE}📁 1. Criando estrutura de diretórios padrão...${NC}"
mkdir -p .agents/skills
mkdir -p .agents/rules

if [ -n "$PLUGIN_NAME" ]; then
    echo -e "  ${CYAN}📦 Configurando estrutura do plugin '$PLUGIN_NAME'...${NC}"
    mkdir -p ".agents/plugins/$PLUGIN_NAME/skills"
    mkdir -p ".agents/plugins/$PLUGIN_NAME/rules"
    mkdir -p ".agents/plugins/$PLUGIN_NAME/sidecars"
fi

# ==========================================
# 2. CONFIGURAÇÕES EM NÍVEL DE WORKSPACE
# ==========================================
echo -e "\n${BLUE}⚙️ 2. Gerando arquivos de configuração globais...${NC}"

# Hooks padrão do workspace
HOOKS_CONTENT='{
  "PreToolUse": [],
  "PostToolUse": []
}'
create_if_not_exists ".agents/hooks.json" "$HOOKS_CONTENT"

# Regras do Projeto (globais)
if [ "$TECH_STACK" = "delphi" ]; then
    RULES_CONTENT="# Regras do Projeto - Delphi (ANSI Windows-1252)

Estas regras orientam o Agente de IA no desenvolvimento deste workspace.

## 1. Padrões de Codificação e Arquivos
- **Codificação Obrigatória**: Todos os arquivos Delphi (\`.pas\`, \`.dfm\`, \`.dpr\`, \`.dproj\`) e scripts SQL devem ser codificados em **Windows-1252 (ANSI)** para compatibilidade com o Delphi 10.3+.
- **Arquivos de IA/Markdown**: Toda a documentação gerada pela IA (\`.md\`, \`.txt\`) deve ser codificada em **UTF-8**.
- **Nomenclatura**:
  - Units: \`UFrmCliente.pas\` (Views), \`UDMCliente.pas\` (DataModules), \`UControllerCliente.pas\` (Controllers).
  - Componentes: Prefixo minúsculo de 3 letras (ex: \`edtNome\`, \`btnSalvar\`, \`qryConsulta\`).

## 2. Padrão Arquitetural
- Utilize o padrão **MVC (Model-View-Controller)** ou **MVVM**.
- Regras de negócio NUNCA devem estar acopladas diretamente à View (formulário).
- Utilize injeção de dependências e interfaces para comunicação desacoplada.

## 3. Segurança e Banco de Dados (Firebird 3.0)
- Toda consulta SQL dinâmica deve usar **Parâmetros** (\`Params\`) para evitar SQL Injection.
- Controle rigoroso de escopo de conexões (abrir transação o mais tarde possível, fechar imediatamente após uso)."
elif [ "$TECH_STACK" = "python" ]; then
    RULES_CONTENT="# Regras do Projeto - Python (Clean Code)

Estas regras guiam o Agente de IA no desenvolvimento deste workspace.

## 1. Padrões de Código
- **Estilo**: Siga rigorosamente a **PEP 8**. Use \`black\`, \`flake8\` ou \`ruff\` para formatação automática.
- **Tipagem**: Utilize hints de tipagem (Type Hints) em todas as definições de funções e classes.
- **Ambiente Virtual**: Sempre verifique se o ambiente virtual (\`.venv\`) está ativo antes de propor execuções de comandos de instalação.

## 2. Estrutura do Projeto
- Use estruturas modulares limpas (ex: \`src/\` contendo a lógica principal).
- Separe configurações de ambiente em arquivos \`.env\` (nunca suba chaves secretas para o repositório)."
else
    RULES_CONTENT="# Regras do Projeto - $PROJECT_NAME

Descreva aqui as restrições globais ou estilo de código para o Agent seguir.

## Diretrizes Padrão
1. Mantenha o código limpo, documentado e siga os princípios SOLID.
2. Toda documentação gerada pelo agente deve usar o formato Markdown (UTF-8).
3. Antes de realizar grandes alterações, proponha um plano detalhado."
fi

create_if_not_exists ".agents/rules/regras_projeto.md" "$RULES_CONTENT"

# Skill básica de Exemplo
SKILL_CONTENT="---
name: core-skill
description: Fornece o contexto e diretrizes principais para o desenvolvimento do projeto $PROJECT_NAME.
---
# Instruções Core - $PROJECT_NAME

Esta skill auxilia o agente a entender a essência do projeto e as ferramentas disponíveis.

## Diretrizes de Resolução de Tarefas
1. Sempre leia o arquivo \`.agents/rules/regras_projeto.md\` antes de propor alterações.
2. Divida tarefas grandes em pequenos passos e marque-as como concluídas no arquivo \`task.md\` se aplicável.
3. Se houver alguma dúvida conceitual, pergunte antes de prosseguir com mudanças de infraestrutura."

create_if_not_exists ".agents/skills/core-skill/SKILL.md" "$SKILL_CONTENT"


# ==========================================
# 3. CONFIGURAÇÕES ESPECÍFICAS DO PLUGIN
# ==========================================
if [ -n "$PLUGIN_NAME" ]; then
    echo -e "\n${BLUE}⚙️ 3. Gerando arquivos do Plugin '$PLUGIN_NAME'...${NC}"
    
    # Manifest do Plugin
    PLUGIN_JSON_CONTENT="{
  \"name\": \"$PLUGIN_NAME\",
  \"description\": \"Plugin personalizado para $PROJECT_NAME\",
  \"version\": \"1.0.0\"
}"
    create_if_not_exists ".agents/plugins/$PLUGIN_NAME/plugin.json" "$PLUGIN_JSON_CONTENT"

    # MCP config do Plugin
    MCP_CONFIG_CONTENT='{
  "mcpServers": {
    "exemplo-mcp": {
      "command": "node",
      "args": ["caminho/para/o/mcp.js"]
    }
  }
}'
    create_if_not_exists ".agents/plugins/$PLUGIN_NAME/mcp_config.json" "$MCP_CONFIG_CONTENT"

    # Hooks do Plugin
    PLUGIN_HOOKS_CONTENT='{
  "PreToolUse": []
}'
    create_if_not_exists ".agents/plugins/$PLUGIN_NAME/hooks.json" "$PLUGIN_HOOKS_CONTENT"

    # Sidecar do Plugin
    SIDECAR_CONTENT='{
  "command": "echo \"Sidecar do plugin '$PLUGIN_NAME' iniciado com sucesso\"",
  "restart_policy": "always",
  "description": "Sidecar de exemplo rodando tarefas em background ou servidores locais"
}'
    create_if_not_exists ".agents/plugins/$PLUGIN_NAME/sidecars/exemplo-sidecar/sidecar.json" "$SIDECAR_CONTENT"
fi

# ==========================================
# CONCLUÍDO
# ==========================================
echo -e "\n${PURPLE}============================================================${NC}"
echo -e "${GREEN}🎉 Estrutura Antigravity configurada com sucesso para seu projeto!${NC}"
echo -e "   Para começar a usar, faça uma pergunta ao Agente no chat."
echo -e "${PURPLE}============================================================${NC}\n"
