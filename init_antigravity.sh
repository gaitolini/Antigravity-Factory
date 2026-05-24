#!/bin/bash

# ==============================================================================
# FÁBRICA ANTIGRAVITY - SCRIPT DE INICIALIZAÇÃO BASH (V2.0)
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
echo -e "${CYAN}   🚀  Fábrica de Estrutura Antigravity v2.0 - Inicializador 🚀   ${NC}"
echo -e "${PURPLE}============================================================${NC}"

# Valores padrão
PROJECT_NAME="Novo Projeto Antigravity"
PLUGIN_NAME=""
TECH_STACK=""
INTERACTIVE=false
LAYOUT="global"      # global ou encapsulated
GIT_INIT=false
SKILLS_PACK="none"  # local, global, none

# Ajuda
show_help() {
    echo -e "Uso: $0 [opções]"
    echo -e ""
    echo -e "Opções:"
    echo -e "  -n, --name <nome>      Nome do projeto (Padrão: '$PROJECT_NAME')"
    echo -e "  -pl, --plugin <nome>   Nome do plugin a ser criado (opcional)"
    echo -e "  -d, --delphi           Configura templates específicos para Delphi"
    echo -e "  -p, --python           Configura templates específicos para Python"
    echo -e "  -e, --encapsulated     Usa estrutura encapsulada (separada em .agents/ e .projeto/)"
    echo -e "  -g, --git              Inicializa repositórios Git automaticamente"
    echo -e "  -s, --skills <l|g|n>   Pacote de skills: (l)ocal, (g)lobal ou (n)enhum"
    echo -e "  -i, --interactive      Modo interativo perguntando opções"
    echo -e "  -h, --help             Exibe esta mensagem de ajuda"
    echo -e ""
    echo -e "Exemplo rápido:"
    echo -e "  curl -sSL https://raw.githubusercontent.com/gaitolini/antigravity-factory/main/init_antigravity.sh | bash -s -- --delphi --encapsulated --git --skills l"
}

# Parse de argumentos
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -n|--name) PROJECT_NAME="$2"; shift ;;
        -pl|--plugin) PLUGIN_NAME="$2"; shift ;;
        -d|--delphi) TECH_STACK="delphi" ;;
        -p|--python) TECH_STACK="python" ;;
        -e|--encapsulated) LAYOUT="encapsulated" ;;
        -g|--git) GIT_INIT=true ;;
        -s|--skills) 
            case $2 in
                l|local) SKILLS_PACK="local" ;;
                g|global) SKILLS_PACK="global" ;;
                *) SKILLS_PACK="none" ;;
            esac
            shift
            ;;
        -i|--interactive) INTERACTIVE=true ;;
        -h|--help) show_help; exit 0 ;;
        *) echo -e "${RED}❌ Opção desconhecida: $1${NC}"; show_help; exit 1 ;;
    esac
    shift
done

# Modo interativo
if [ "$INTERACTIVE" = true ]; then
    echo -e "${YELLOW}📝 Entrando no modo interativo...${NC}"
    
    # 1. Nome do Projeto
    read -p "Digite o nome do projeto [$PROJECT_NAME]: " temp_name
    [ -n "$temp_name" ] && PROJECT_NAME="$temp_name"

    # 2. Estrutura do Layout
    echo -e "\nSelecione a estrutura de pastas do projeto:"
    echo -e "  1) Global (Plano, tudo no mesmo diretório)"
    echo -e "  2) Encapsulado (Separado: pasta .agents/ e pasta .projeto/ na raiz)"
    read -p "Opção (1-2) [1]: " opt_layout
    if [ "$opt_layout" = "2" ]; then
        LAYOUT="encapsulated"
    else
        LAYOUT="global"
    fi

    # 3. Versionamento Git
    echo -e "\nDeseja inicializar o repositório Git?"
    echo -e "  1) Sim (Se encapsulado, cria repositórios separados)"
    echo -e "  2) Não"
    read -p "Opção (1-2) [1]: " opt_git
    if [ "$opt_git" = "2" ]; then
        GIT_INIT=false
    else
        GIT_INIT=true
    fi

    # 4. Pacote de Skills
    echo -e "\nDeseja instalar o pacote de skills 'antigravity-awesome-skills'?"
    echo -e "  1) Local (Instala em .agents/skills)"
    echo -e "  2) Global"
    echo -e "  3) Não instalar"
    read -p "Opção (1-3) [1]: " opt_skills
    if [ "$opt_skills" = "2" ]; then
        SKILLS_PACK="global"
    elif [ "$opt_skills" = "3" ]; then
        SKILLS_PACK="none"
    else
        SKILLS_PACK="local"
    fi

    # 5. Stack de Tecnologia
    echo -e "\nSelecione uma stack de tecnologia para regras:"
    echo -e "  1) Nenhuma (Genérico)"
    echo -e "  2) Delphi (Windows-1252, ERP, Firebird)"
    echo -e "  3) Python (venv, pip/poetry, Clean Code)"
    read -p "Opção (1-3) [1]: " opt_tech
    case $opt_tech in
        2) TECH_STACK="delphi" ;;
        3) TECH_STACK="python" ;;
        *) TECH_STACK="" ;;
    esac

    # 6. Plugin Opcional
    read -p "Deseja inicializar um plugin específico? (Deixe em branco para nenhum): " temp_plugin
    [ -n "$temp_plugin" ] && PLUGIN_NAME="$temp_plugin"
fi

# Definir os caminhos de pastas com base no layout
if [ "$LAYOUT" = "encapsulated" ]; then
    AGENTS_DIR=".agents"
    PROJECT_DIR=".projeto"
    echo -e "\n${BLUE}📁 1. Configurando estrutura Encapsulada...${NC}"
    mkdir -p "$AGENTS_DIR/skills"
    mkdir -p "$AGENTS_DIR/rules"
    mkdir -p "$PROJECT_DIR"
else
    AGENTS_DIR=".agents"
    PROJECT_DIR="."
    echo -e "\n${BLUE}📁 1. Configurando estrutura Global...${NC}"
    mkdir -p "$AGENTS_DIR/skills"
    mkdir -p "$AGENTS_DIR/rules"
fi

if [ -n "$PLUGIN_NAME" ]; then
    echo -e "  ${CYAN}📦 Configurando estrutura do plugin '$PLUGIN_NAME'...${NC}"
    mkdir -p "$AGENTS_DIR/plugins/$PLUGIN_NAME/skills"
    mkdir -p "$AGENTS_DIR/plugins/$PLUGIN_NAME/rules"
    mkdir -p "$AGENTS_DIR/plugins/$PLUGIN_NAME/sidecars"
fi

# Função auxiliar para criar arquivos se eles não existirem
create_if_not_exists() {
    local filepath="$1"
    local content="$2"
    mkdir -p "$(dirname "$filepath")"
    if [ ! -f "$filepath" ]; then
        echo -e "$content" > "$filepath"
        echo -e "  ${GREEN}✅ Criado:${NC} $filepath"
    else
        echo -e "  ${YELLOW}⚡ Já existe (ignorado):${NC} $filepath"
    fi
}

# ==========================================
# 2. GERAR CONFIGURAÇÕES DO AGENTE (.AGENTS)
# ==========================================
echo -e "\n${BLUE}⚙️ 2. Gerando arquivos de configuração do Agente...${NC}"

# Hooks padrão
HOOKS_CONTENT='{
  "PreToolUse": [],
  "PostToolUse": []
}'
create_if_not_exists "$AGENTS_DIR/hooks.json" "$HOOKS_CONTENT"

# Regras do Projeto
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
create_if_not_exists "$AGENTS_DIR/rules/regras_projeto.md" "$RULES_CONTENT"

# Skill básica
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
create_if_not_exists "$AGENTS_DIR/skills/core-skill/SKILL.md" "$SKILL_CONTENT"

# Se houver plugin
if [ -n "$PLUGIN_NAME" ]; then
    PLUGIN_JSON_CONTENT="{
  \"name\": \"$PLUGIN_NAME\",
  \"description\": \"Plugin personalizado para $PROJECT_NAME\",
  \"version\": \"1.0.0\"
}"
    create_if_not_exists "$AGENTS_DIR/plugins/$PLUGIN_NAME/plugin.json" "$PLUGIN_JSON_CONTENT"

    MCP_CONFIG_CONTENT='{
  "mcpServers": {
    "exemplo-mcp": {
      "command": "node",
      "args": ["caminho/para/o/mcp.js"]
    }
  }
}'
    create_if_not_exists "$AGENTS_DIR/plugins/$PLUGIN_NAME/mcp_config.json" "$MCP_CONFIG_CONTENT"

    PLUGIN_HOOKS_CONTENT='{
  "PreToolUse": []
}'
    create_if_not_exists "$AGENTS_DIR/plugins/$PLUGIN_NAME/hooks.json" "$PLUGIN_HOOKS_CONTENT"

    SIDECAR_CONTENT='{
  "command": "echo \"Sidecar do plugin '$PLUGIN_NAME' iniciado com sucesso\"",
  "restart_policy": "always",
  "description": "Sidecar de exemplo rodando tarefas em background ou servidores locais"
}'
    create_if_not_exists "$AGENTS_DIR/plugins/$PLUGIN_NAME/sidecars/exemplo-sidecar/sidecar.json" "$SIDECAR_CONTENT"
fi

# ==========================================
# 3. CRIAÇÃO DOS ARQUIVOS DO WORKSPACE
# ==========================================
if [ "$LAYOUT" = "encapsulated" ]; then
    echo -e "\n${BLUE}⚙️ 3. Gerando arquivo do Workspace da IDE (.code-workspace)...${NC}"
    
    # Criar o nome do arquivo limpo (snake_case)
    CLEAN_FILE_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
    
    WORKSPACE_CONTENT="{
  \"folders\": [
    {
      \"name\": \"IA Agents (.agents)\",
      \"path\": \".agents\"
    },
    {
      \"name\": \"Arquivos do Projeto (.projeto)\",
      \"path\": \".projeto\"
    }
  ],
  \"settings\": {}
}"
    create_if_not_exists "${CLEAN_FILE_NAME}.code-workspace" "$WORKSPACE_CONTENT"
fi

# ==========================================
# 4. INSTALAÇÃO DO PACK DE SKILLS
# ==========================================
if [ "$SKILLS_PACK" != "none" ]; then
    echo -e "\n${BLUE}📦 4. Instalando pacote de skills 'antigravity-awesome-skills'...${NC}"
    
    # Verificar se npm/npx existe
    if command -v npx &> /dev/null; then
        if [ "$SKILLS_PACK" = "local" ]; then
            echo -e "  Executing: ${YELLOW}npx antigravity-awesome-skills --path \"$AGENTS_DIR/skills\"${NC}"
            npx antigravity-awesome-skills --path "$AGENTS_DIR/skills"
        else
            echo -e "  Executing: ${YELLOW}npx antigravity-awesome-skills${NC}"
            npx antigravity-awesome-skills
        fi
        echo -e "  ${GREEN}✅ Pacote de skills instalado!${NC}"
    else
        echo -e "  ${RED}⚠️ npx/Node.js não instalado localmente. Pulando execução direta.${NC}"
        echo -e "  Para instalar futuramente:"
        if [ "$SKILLS_PACK" = "local" ]; then
            echo -e "    ${CYAN}npx antigravity-awesome-skills --path \"$AGENTS_DIR/skills\"${NC}"
        else
            echo -e "    ${CYAN}npx antigravity-awesome-skills${NC}"
        fi
    fi
fi

# ==========================================
# 5. CONFIGURAÇÃO DE VERSIONAMENTO (GIT)
# ==========================================
if [ "$GIT_INIT" = true ]; then
    echo -e "\n${BLUE}🐙 5. Inicializando repositório Git...${NC}"
    
    if [ "$LAYOUT" = "encapsulated" ]; then
        # Git isolado na pasta .agents
        echo -e "  ${CYAN}Inicializando Git na pasta $AGENTS_DIR...${NC}"
        (
            cd "$AGENTS_DIR" || exit
            git init
            create_if_not_exists ".gitignore" "node_modules/\n*.log\n.DS_Store"
        )
        
        # Git isolado na pasta .projeto
        echo -e "  ${CYAN}Inicializando Git na pasta $PROJECT_DIR...${NC}"
        (
            cd "$PROJECT_DIR" || exit
            git init
            
            # Gitignore customizado por stack
            if [ "$TECH_STACK" = "delphi" ]; then
                GITIGNORE_CONTENT="__history/\n*.dcu\n*.identcache\n*.local\n*.~*\n*.stat\nWin32/\nWin64/\nDebug/\nRelease/"
            elif [ "$TECH_STACK" = "python" ]; then
                GITIGNORE_CONTENT=".venv/\n__pycache__/\n*.pyc\n.pytest_cache/\n.env\n*.log"
            else
                GITIGNORE_CONTENT="node_modules/\n*.log\n.env\n.DS_Store"
            fi
            create_if_not_exists ".gitignore" "$GITIGNORE_CONTENT"
        )
    else
        # Git global na raiz
        git init
        
        # Gitignore customizado por stack
        if [ "$TECH_STACK" = "delphi" ]; then
            GITIGNORE_CONTENT=".agents/plugins/*/node_modules/\n__history/\n*.dcu\n*.identcache\n*.local\n*.~*\n*.stat\nWin32/\nWin64/\nDebug/\nRelease/"
        elif [ "$TECH_STACK" = "python" ]; then
            GITIGNORE_CONTENT=".agents/plugins/*/node_modules/\n.venv/\n__pycache__/\n*.pyc\n.pytest_cache/\n.env\n*.log"
        else
            GITIGNORE_CONTENT=".agents/plugins/*/node_modules/\nnode_modules/\n*.log\n.env\n.DS_Store"
        fi
        create_if_not_exists ".gitignore" "$GITIGNORE_CONTENT"
    fi
fi

# ==========================================
# CONCLUÍDO
# ==========================================
echo -e "\n${PURPLE}============================================================${NC}"
echo -e "${GREEN}🎉 Estrutura Antigravity configurada com sucesso para seu projeto!${NC}"
if [ "$LAYOUT" = "encapsulated" ]; then
    echo -e "   Abra o arquivo ${YELLOW}${CLEAN_FILE_NAME}.code-workspace${NC} na sua IDE."
else
    echo -e "   Para começar a usar, faça uma pergunta ao Agente no chat."
fi
echo -e "${PURPLE}============================================================${NC}\n"
