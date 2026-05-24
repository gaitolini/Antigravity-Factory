# ==============================================================================
# ANTIGRAVITY FACTORY - POWERSHELL INITIALIZER (V2.1 - PURE ASCII COMPATIBILITY)
# Repository: gaitolini/antigravity-factory
# ==============================================================================

[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [string]$ProjectName = "Novo Projeto Antigravity",

    [Parameter(Mandatory=$false)]
    [string]$PluginName = "",

    [Parameter(Mandatory=$false)]
    [switch]$Encapsulated,

    [Parameter(Mandatory=$false)]
    [switch]$GitInit,

    [Parameter(Mandatory=$false)]
    [string]$SkillsPack = "none", # local, global, none

    [Parameter(Mandatory=$false)]
    [switch]$Interactive
)

Write-Host "============================================================" -ForegroundColor Magenta
Write-Host "   [*] Antigravity Structure Factory v2.1 - Initializer [*]" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Magenta

# Se o usuario escolheu interativo
if ($Interactive) {
    Write-Host "[*] Entrando no modo interativo..." -ForegroundColor Yellow
    $tempName = Read-Host "Digite o nome do projeto [$ProjectName]"
    if ($tempName) { $ProjectName = $tempName }

    # Escolha de layout
    Write-Host "`nSelecione a estrutura de pastas do projeto:"
    Write-Host "  1) Global (Plano, tudo no mesmo diretorio)"
    Write-Host "  2) Encapsulado (Separado: pasta .agents/ e pasta .projeto/ na raiz)"
    $optLayout = Read-Host "Opcao (1-2) [1]"
    if ($optLayout -eq "2") {
        $Encapsulated = $true
    } else {
        $Encapsulated = $false
    }

    # Versionamento Git
    Write-Host "`nDeseja inicializar o repositorio Git?"
    Write-Host "  1) Sim (Se encapsulado, cria repositorios separados)"
    Write-Host "  2) Nao"
    $optGit = Read-Host "Opcao (1-2) [1]"
    if ($optGit -eq "2") {
        $GitInit = $false
    } else {
        $GitInit = $true
    }

    # Pacote de Skills
    Write-Host "`nDeseja instalar o pacote de skills 'antigravity-awesome-skills'?"
    Write-Host "  1) Local (Instala em .agents/skills)"
    Write-Host "  2) Global"
    Write-Host "  3) Nao instalar"
    $optSkills = Read-Host "Opcao (1-3) [1]"
    if ($optSkills -eq "2") {
        $SkillsPack = "global"
    } elseif ($optSkills -eq "3") {
        $SkillsPack = "none"
    } else {
        $SkillsPack = "local"
    }

    # Plugin especifico
    $tempPlugin = Read-Host "`nDeseja inicializar um plugin especifico? (Deixe em branco para nenhum)"
    if ($tempPlugin) { $PluginName = $tempPlugin }
}

# Definir pastas base de acordo com layout
if ($Encapsulated) {
    $agentsDir = ".agents"
    $projectDir = ".projeto"
    Write-Host "`n[DIR] 1. Configurando estrutura Encapsulada..." -ForegroundColor Blue
    $null = New-Item -ItemType Directory -Path "$agentsDir/skills" -Force
    $null = New-Item -ItemType Directory -Path "$agentsDir/rules" -Force
    $null = New-Item -ItemType Directory -Path "$projectDir" -Force
} else {
    $agentsDir = ".agents"
    $projectDir = "."
    Write-Host "`n[DIR] 1. Configurando estrutura Global..." -ForegroundColor Blue
    $null = New-Item -ItemType Directory -Path "$agentsDir/skills" -Force
    $null = New-Item -ItemType Directory -Path "$agentsDir/rules" -Force
}

if ($PluginName) {
    Write-Host "  [PLUGIN] Configurando estrutura do plugin '$PluginName'..." -ForegroundColor Cyan
    $null = New-Item -ItemType Directory -Path "$agentsDir/plugins/$PluginName/skills" -Force
    $null = New-Item -ItemType Directory -Path "$agentsDir/plugins/$PluginName/rules" -Force
    $null = New-Item -ItemType Directory -Path "$agentsDir/plugins/$PluginName/sidecars" -Force
}

# Funcao auxiliar para criar arquivos se nao existirem
function Create-If-Not-Exists {
    param (
        [string]$Path,
        [string]$Content
    )
    
    $parentDir = Split-Path -Path $Path -Parent
    if ($parentDir -and !(Test-Path -Path $parentDir)) {
        $null = New-Item -ItemType Directory -Path $parentDir -Force
    }

    if (!(Test-Path -Path $Path)) {
        # Gravar em UTF-8 sem BOM
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($Path, $Content, $utf8NoBom)
        Write-Host "  [+] Criado: $Path" -ForegroundColor Green
    } else {
        Write-Host "  [~] Ja existe (ignorado): $Path" -ForegroundColor Yellow
    }
}

# ==========================================
# 2. CONFIGURACOES EM NIVEL DE WORKSPACE
# ==========================================
Write-Host "`n[CONFIG] 2. Gerando arquivos de configuracao do Agente..." -ForegroundColor Blue

$hooksContent = @(
    "{",
    '  "PreToolUse": [],',
    '  "PostToolUse": []',
    "}"
) -join [Environment]::NewLine
Create-If-Not-Exists -Path "$agentsDir/hooks.json" -Content $hooksContent

$rulesContent = @(
    "# Regras do Projeto - $ProjectName",
    "",
    "Estas regras orientam o Agente de IA no desenvolvimento deste workspace.",
    "",
    "## 1. Padroes Gerais de Desenvolvimento",
    "- **Clareza e Simplicidade**: Mantenha o codigo limpo, documentado e siga os principios SOLID e DRY.",
    "- **Documentacao de Agente**: Toda a documentacao gerada pelo agente ou IA (\`.md\`, \`.txt\`) deve ser codificada em **UTF-8 (Sem BOM)**.",
    "- **Organizacao**: Antes de realizar grandes modificacoes ou arquiteturas, crie e proponha um plano de implementacao.",
    "",
    "## 2. Tratamento de Erros e Logs",
    "- Nunca silencie excecoes silenciosamente. Implemente tratamento de excecoes robusto e registre as falhas usando logs nativos ou adequados."
) -join [Environment]::NewLine
Create-If-Not-Exists -Path "$agentsDir/rules/regras_projeto.md" -Content $rulesContent

$skillContent = @(
    "---",
    "name: core-skill",
    "description: Fornece o contexto e diretrizes principais para o desenvolvimento do projeto $ProjectName.",
    "---",
    "# Instrucoes Core - $ProjectName",
    "",
    "Esta skill auxilia o agente a entender a essencia do projeto e as ferramentas disponiveis neste workspace.",
    "",
    "## Diretrizes de Resolucao de Tarefas",
    "1. Sempre leia o arquivo \`.agents/rules/regras_projeto.md\` antes de propor alteracoes de codigo.",
    "2. Divida tarefas complexas em passos menores e registre-as no arquivo \`task.md\` se necessario para controle do progresso.",
    "3. Solicite feedbacks ou esclarecimentos conceituais ao usuario antes de alterar estruturas de infraestrutura."
) -join [Environment]::NewLine
Create-If-Not-Exists -Path "$agentsDir/skills/core-skill/SKILL.md" -Content $skillContent

# Se houver plugin
if ($PluginName) {
    $pluginJsonContent = @(
        "{",
        "  ""name"": ""$PluginName"",",
        "  ""description"": ""Plugin personalizado para $ProjectName"",",
        "  ""version"": ""1.0.0""",
        "}"
    ) -join [Environment]::NewLine
    Create-If-Not-Exists -Path "$agentsDir/plugins/$PluginName/plugin.json" -Content $pluginJsonContent

    $mcpConfigContent = @(
        "{",
        "  ""mcpServers"": {",
        "    ""exemplo-mcp"": {",
        "      ""command"": ""node"",",
        "      ""args"": [""caminho/para/o/mcp.js""]",
        "    }",
        "  }",
        "}"
    ) -join [Environment]::NewLine
    Create-If-Not-Exists -Path "$agentsDir/plugins/$PluginName/mcp_config.json" -Content $mcpConfigContent

    $pluginHooksContent = @(
        "{",
        "  ""PreToolUse"": []",
        "}"
    ) -join [Environment]::NewLine
    Create-If-Not-Exists -Path "$agentsDir/plugins/$PluginName/hooks.json" -Content $pluginHooksContent

    $sidecarContent = @(
        "{",
        "  ""command"": ""echo \\""Sidecar do plugin '$PluginName' iniciado com sucesso\\"""",",
        "  ""restart_policy"": ""always"",",
        "  ""description"": ""Sidecar de exemplo rodando tarefas em background ou servidores locais""",
        "}"
    ) -join [Environment]::NewLine
    Create-If-Not-Exists -Path "$agentsDir/plugins/$PluginName/sidecars/exemplo-sidecar/sidecar.json" -Content $sidecarContent
}

# ==========================================
# 3. CRIACAO DOS ARQUIVOS DO WORKSPACE (.CODE-WORKSPACE)
# ==========================================
$cleanFileName = $ProjectName.ToLower().Replace(" ", "_")

if ($Encapsulated) {
    Write-Host "`n[WORKSPACE] 3. Gerando arquivo de Workspace da IDE..." -ForegroundColor Blue
    
    $workspaceContent = @(
        "{",
        "  ""folders"": [",
        "    {",
        "      ""name"": ""IA Agents (.agents)"",",
        "      ""path"": "".agents""",
        "    },",
        "    {",
        "      ""name"": ""Arquivos do Projeto (.projeto)"",",
        "      ""path"": "".projeto""",
        "    }",
        "  ],",
        "  ""settings"": {}",
        "}"
    ) -join [Environment]::NewLine
    Create-If-Not-Exists -Path "${cleanFileName}.code-workspace" -Content $workspaceContent
}

# ==========================================
# 4. INSTALACAO DO PACK DE SKILLS
# ==========================================
if ($SkillsPack -ne "none") {
    Write-Host "`n[PACK] 4. Instalando pacote de skills 'antigravity-awesome-skills'..." -ForegroundColor Blue
    
    $npxCheck = Get-Command npx -ErrorAction SilentlyContinue
    if ($npxCheck) {
        if ($SkillsPack -eq "local") {
            Write-Host "  Executando: npx antigravity-awesome-skills --path `"$agentsDir/skills`"" -ForegroundColor Yellow
            npx antigravity-awesome-skills --path "$agentsDir/skills"
        } else {
            Write-Host "  Executando: npx antigravity-awesome-skills" -ForegroundColor Yellow
            npx antigravity-awesome-skills
        }
        Write-Host "  [+] Pacote de skills instalado!" -ForegroundColor Green
    } else {
        Write-Host "  [!] npx/Node.js nao disponivel localmente. Pulando instalacao automatica." -ForegroundColor Red
        Write-Host "  Comando recomendado para executar manualmente depois:" -ForegroundColor Yellow
        if ($SkillsPack -eq "local") {
            Write-Host "    npx antigravity-awesome-skills --path `"$agentsDir/skills`"" -ForegroundColor Cyan
        } else {
            Write-Host "    npx antigravity-awesome-skills" -ForegroundColor Cyan
        }
    }
}

# ==========================================
# 5. CONFIGURACAO DE VERSIONAMENTO (GIT) E READMES
# ==========================================
if ($GitInit) {
    Write-Host "`n[GIT] 5. Inicializando repositorio Git e gerando documentacao inicial..." -ForegroundColor Blue
    
    if ($Encapsulated) {
        # 1. README Global na Raiz
        $rootReadme = @(
            "# Workspace - $ProjectName",
            "",
            "Este workspace esta estruturado de forma encapsulada no padrao Google Antigravity.",
            "",
            "## Estrutura de Pastas",
            "- \`.agents/\`: Diretrizes, regras, plugins e skills que orientam o Agente de IA.",
            "- \`.projeto/\`: Arquivos de codigo-fonte reais do projeto.",
            "",
            "Para abrir de forma integrada na IDE, clique duas vezes no arquivo **${cleanFileName}.code-workspace**."
        ) -join [Environment]::NewLine
        Create-If-Not-Exists -Path "README.md" -Content $rootReadme

        # 2. Git isolado na pasta .agents
        Write-Host "  Inicializando Git na pasta $agentsDir..." -ForegroundColor Cyan
        & {
            $pwd = Get-Location
            Set-Location "$agentsDir"
            git init
            Create-If-Not-Exists -Path ".gitignore" -Content (@("node_modules/", "*.log", ".DS_Store") -join [Environment]::NewLine)
            
            $agentsReadme = @(
                "# Agents - $ProjectName",
                "",
                "Este diretorio contem a inteligencia e as regras de desenvolvimento que o seu Agente de IA le e obedece localmente.",
                "",
                "- \`rules/\`: Diretrizes e padroes arquiteturais.",
                "- \`skills/\`: Instrucoes especificas para resolver tarefas complexas.",
                "- \`hooks.json\`: Validacoes de ferramentas pre/pos execucao."
            ) -join [Environment]::NewLine
            Create-If-Not-Exists -Path "README.md" -Content $agentsReadme
            
            Set-Location $pwd
        }
        
        # 3. Git isolado na pasta .projeto
        Write-Host "  Inicializando Git na pasta $projectDir..." -ForegroundColor Cyan
        & {
            $pwd = Get-Location
            Set-Location "$projectDir"
            git init
            Create-If-Not-Exists -Path ".gitignore" -Content (@("node_modules/", "*.log", ".env", ".DS_Store") -join [Environment]::NewLine)
            
            $projectReadme = @(
                "# Projeto - $ProjectName",
                "",
                "Este diretorio contem os arquivos de codigo-fonte reais do seu projeto. Insira seus arquivos, estruturas e codigos diretamente aqui."
            ) -join [Environment]::NewLine
            Create-If-Not-Exists -Path "README.md" -Content $projectReadme
            
            Set-Location $pwd
        }
    } else {
        # Git global na raiz
        git init
        Create-If-Not-Exists -Path ".gitignore" -Content (@(".agents/plugins/*/node_modules/", "node_modules/", "*.log", ".env", ".DS_Store") -join [Environment]::NewLine)
        
        $globalReadme = @(
            "# $ProjectName",
            "",
            "Este projeto utiliza a estrutura padrao Google Antigravity para guiar o desenvolvimento com Inteligencia Artificial.",
            "",
            "## Estrutura do Workspace",
            "- \`.agents/\`: Contem as regras, hooks e habilidades do Agente de IA.",
            "- O codigo-fonte e arquivos do projeto residem diretamente na raiz."
        ) -join [Environment]::NewLine
        Create-If-Not-Exists -Path "README.md" -Content $globalReadme
    }
}

# ==========================================
# CONCLUIDO
# ==========================================
Write-Host "`n============================================================" -ForegroundColor Magenta
Write-Host "[SUCCESS] Estrutura Antigravity configurada com sucesso para seu projeto!" -ForegroundColor Green
if ($Encapsulated) {
    Write-Host "   Abra o arquivo $cleanFileName.code-workspace na sua IDE." -ForegroundColor Yellow
} else {
    Write-Host "   Para comecar a usar, faca uma pergunta ao Agente no chat."
}
Write-Host "============================================================" -ForegroundColor Magenta
