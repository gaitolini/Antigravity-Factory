#!/bin/bash

# ==============================================================================
# FÁBRICA ANTIGRAVITY - SCRIPT DE INICIALIZAÇÃO BASH (V2.1)
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
echo -e "${CYAN}   🚀  Fábrica de Estrutura Antigravity v2.1 - Inicializador 🚀   ${NC}"
echo -e "${PURPLE}============================================================${NC}"

# Valores padrão
PROJECT_NAME="Novo Projeto Antigravity"
PLUGIN_NAME=""
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
    echo -e "  -e, --encapsulated     Usa estrutura encapsulada (separada em .agents/ e .projeto/)"
    echo -e "  -g, --git              Inicializa repositórios Git automaticamente"
    echo -e "  -s, --skills <l|g|n>   Pacote de skills: (l)ocal, (g)lobal ou (n)enhum"
    echo -e "  -i, --interactive      Modo interativo perguntando opções"
    echo -e "  -h, --help             Exibe esta mensagem de ajuda"
    echo -e ""
    echo -e "Exemplo rápido:"
    echo -e "  curl -sSL https://raw.githubusercontent.com/gaitolini/antigravity-factory/main/init_antigravity.sh | bash -s -- --encapsulated --git --skills l"
}

# Parse de argumentos
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -n|--name) PROJECT_NAME="$2"; shift ;;
        -pl|--plugin) PLUGIN_NAME="$2"; shift ;;
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

    # 5. Plugin Opcional
    read -p "\nDeseja inicializar um plugin específico? (Deixe em branco para nenhum): " temp_plugin
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

# Regras do Projeto (Genéricas e Limpas)
RULES_CONTENT="# Regras do Projeto - $PROJECT_NAME

Estas regras guiam o Agente de IA no desenvolvimento deste workspace.

## 1. Padrões Gerais de Desenvolvimento
- **Clareza e Simplicidade**: Mantenha o código limpo, documentado e siga os princípios SOLID e DRY.
- **Documentação de Agente**: Toda a documentação gerada pelo agente ou IA (\`.md\`, \`.txt\`) deve ser codificada em **UTF-8 (Sem BOM)**.
- **Organização**: Antes de realizar grandes modificações ou arquiteturas, crie e proponha um plano de implementação.

## 2. Tratamento de Erros e Logs
- Nunca silencie exceções silenciosamente. Implemente tratamento de exceções robusto e registre as falhas usando logs nativos ou adequados."
create_if_not_exists "$AGENTS_DIR/rules/regras_projeto.md" "$RULES_CONTENT"

# Skill básica
SKILL_CONTENT="---
name: core-skill
description: Fornece o contexto e diretrizes principais para o desenvolvimento do projeto $PROJECT_NAME.
---
# Instruções Core - $PROJECT_NAME

Esta skill auxilia o agente a entender a essência do projeto e as ferramentas disponíveis neste workspace.

## Diretrizes de Resolução de Tarefas
1. Sempre leia o arquivo \`.agents/rules/regras_projeto.md\` antes de propor alterações de código.
2. Divida tarefas complexas em passos menores e registre-as no arquivo \`task.md\` se necessário para controle do progresso.
3. Solicite feedbacks ou esclarecimentos conceituais ao usuário antes de alterar estruturas de infraestrutura."
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
CLEAN_FILE_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

if [ "$LAYOUT" = "encapsulated" ]; then
    echo -e "\n${BLUE}⚙️ 3. Gerando arquivo do Workspace da IDE (.code-workspace)...${NC}"
    
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
# 5. CONFIGURAÇÃO DE VERSIONAMENTO (GIT) E READMES
# ==========================================
if [ "$GIT_INIT" = true ]; then
    echo -e "\n${BLUE}🐙 5. Inicializando repositório Git e gerando documentação inicial...${NC}"
    
    if [ "$LAYOUT" = "encapsulated" ]; then
        # 1. README Global na Raiz
        ROOT_README="# Workspace - $PROJECT_NAME

Este workspace está estruturado de forma encapsulada no padrão Google Antigravity.

## Estrutura de Pastas
- \`.agents/\`: Diretrizes, regras, plugins e skills que orientam o Agente de IA.
- \`.projeto/\`: Arquivos de código-fonte reais do projeto.

Para abrir de forma integrada na IDE, clique duas vezes no arquivo **${CLEAN_FILE_NAME}.code-workspace**."
        create_if_not_exists "README.md" "$ROOT_README"

        # 2. Git isolado na pasta .agents
        echo -e "  ${CYAN}Inicializando Git na pasta $AGENTS_DIR...${NC}"
        (
            cd "$AGENTS_DIR" || exit
            git init
            create_if_not_exists ".gitignore" "node_modules/\n*.log\n.DS_Store"
            
            AGENTS_README="# Agents - $PROJECT_NAME

Este diretório contém a inteligência e as regras de desenvolvimento que o seu Agente de IA lê e obedece localmente.

- \`rules/\`: Diretrizes e padrões arquiteturais.
- \`skills/\`: Instruções específicas para resolver tarefas complexas.
- \`hooks.json\`: Validações de ferramentas pré/pós execução."
            create_if_not_exists "README.md" "$AGENTS_README"
        )
        
        # 3. Git isolado na pasta .projeto
        echo -e "  ${CYAN}Inicializando Git na pasta $PROJECT_DIR...${NC}"
        (
            cd "$PROJECT_DIR" || exit
            git init
            create_if_not_exists ".gitignore" "node_modules/\n*.log\n.env\n.DS_Store"
            
            PROJECT_README="# Projeto - $PROJECT_NAME

Este diretório contém os arquivos de código-fonte reais do seu projeto. Insira seus arquivos, estruturas e códigos diretamente aqui."
            create_if_not_exists "README.md" "$PROJECT_README"
        )
    else
        # Git global na raiz
        git init
        create_if_not_exists ".gitignore" ".agents/plugins/*/node_modules/\nnode_modules/\n*.log\n.env\n.DS_Store"
        
        GLOBAL_README="# $PROJECT_NAME

Este projeto utiliza a estrutura padrão Google Antigravity para guiar o desenvolvimento com Inteligência Artificial.

## Estrutura do Workspace
- \`.agents/\`: Contém as regras, hooks e habilidades do Agente de IA.
- O código-fonte e arquivos do projeto residem diretamente na raiz."
        create_if_not_exists "README.md" "$GLOBAL_README"
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
