# ==============================================================================
# ANTIGRAVITY FACTORY - POWERSHELL INITIALIZER (V2.0 - PURE ASCII COMPATIBILITY)
# Repository: gaitolini/antigravity-factory
# ==============================================================================

[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [string]$ProjectName = "Novo Projeto Antigravity",

    [Parameter(Mandatory=$false)]
    [string]$PluginName = "",

    [Parameter(Mandatory=$false)]
    [switch]$Delphi,

    [Parameter(Mandatory=$false)]
    [switch]$Python,

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
Write-Host "   [*] Antigravity Structure Factory v2.0 - Initializer [*]" -ForegroundColor Cyan
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

    # Stack de tecnologia
    Write-Host "`nSelecione uma stack de tecnologia para regras:"
    Write-Host "  1) Nenhuma (Generico)"
    Write-Host "  2) Delphi (Windows-1252, ERP, Firebird)"
    Write-Host "  3) Python (venv, pip/poetry, Clean Code)"
    $optTech = Read-Host "Opcao (1-3) [1]"
    
    if ($optTech -eq "2") {
        $Delphi = $true
        $Python = $false
    } elseif ($optTech -eq "3") {
        $Python = $true
        $Delphi = $false
    }

    # Plugin especifico
    $tempPlugin = Read-Host "`nDeseja inicializar um plugin especifico? (Deixe em branco para nenhum)"
    if ($tempPlugin) { $PluginName = $tempPlugin }
}

# Definir stack de tecnologia
$techStack = "generic"
if ($Delphi) { $techStack = "delphi" }
if ($Python) { $techStack = "python" }

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

if ($techStack -eq "delphi") {
    $rulesContent = @(
        "# Regras do Projeto - Delphi (ANSI Windows-1252)",
        "",
        "Estas regras orientam o Agente de IA no desenvolvimento deste workspace.",
        "",
        "## 1. Padroes de Codificacao e Arquivos",
        "- **Codificacao Obrigatoria**: Todos os arquivos Delphi (\`.pas\`, \`.dfm\`, \`.dpr\`, \`.dproj\`) e scripts SQL devem ser codificados em **Windows-1252 (ANSI)** para compatibilidade com o Delphi 10.3+.",
        "- **Arquivos de IA/Markdown**: Toda a documentacao gerada pela IA (\`.md\`, \`.txt\`) deve ser codificada em **UTF-8**.",
        "- **Nomenclatura**:",
        "  - Units: \`UFrmCliente.pas\` (Views), \`UDMCliente.pas\` (DataModules), \`UControllerCliente.pas\` (Controllers).",
        "  - Componentes: Prefixo minusculo de 3 letras (ex: \`edtNome\`, \`btnSalvar\`, \`qryConsulta\`).",
        "",
        "## 2. Padrao Arquitetural",
        "- Utilize o padrao **MVC (Model-View-Controller)** ou **MVVM**.",
        "- Regras de negocio NUNCA devem estar acopladas diretamente a View (formulario).",
        "- Utilize injecao de dependencias e interfaces para comunicacao desacoplada.",
        "",
        "## 3. Seguranca e Banco de Dados (Firebird 3.0)",
        "- Toda consulta SQL dinamica deve usar **Parametros** (\`Params\`) para evitar SQL Injection.",
        "- Controle rigoroso de escopo de conexoes (abrir transacao o mais tarde possivel, fechar imediatamente apos uso)."
    ) -join [Environment]::NewLine
} elseif ($techStack -eq "python") {
    $rulesContent = @(
        "# Regras do Projeto - Python (Clean Code)",
        "",
        "Estas regras guiam o Agente de IA no desenvolvimento deste workspace.",
        "",
        "## 1. Padroes de Code",
        "- **Estilo**: Siga rigorosamente a **PEP 8**. Use \`black\`, \`flake8\` ou \`ruff\` para formatacao automatica.",
        "- **Tipagem**: Utilize hints de tipagem (Type Hints) em todas as definicoes de funcoes e classes.",
        "- **Ambiente Virtual**: Sempre verifique se o ambiente virtual (\`.venv\`) está ativo antes de propor execucoes de comandos de instalacao.",
        "",
        "## 2. Estrutura do Projeto",
        "- Use estruturas modulares limpas (ex: \`src/\` contendo a logica principal).",
        "- Separe configuracoes de ambiente em arquivos \`.env\` (nunca suba chaves secretas para o repositorio)."
    ) -join [Environment]::NewLine
} else {
    $rulesContent = @(
        "# Regras do Projeto - $ProjectName",
        "",
        "Descreva aqui as restricoes globais ou estilo de codigo para o Agent seguir.",
        "",
        "## Diretrizes Padrao",
        "1. Mantenha o codigo limpo, documentado e siga os principios SOLID.",
        "2. Toda documentacao gerada pelo agente deve usar o formato Markdown (UTF-8).",
        "3. Antes de realizar grandes alteracoes, proponha um plano detalhado."
    ) -join [Environment]::NewLine
}
Create-If-Not-Exists -Path "$agentsDir/rules/regras_projeto.md" -Content $rulesContent

$skillContent = @(
    "---",
    "name: core-skill",
    "description: Fornece o contexto e diretrizes principais para o desenvolvimento do projeto $ProjectName.",
    "---",
    "# Instrucoes Core - $ProjectName",
    "",
    "Esta skill auxilia o agente a entender a essencia do projeto e as ferramentas disponiveis.",
    "",
    "## Diretrizes de Resolucao de Tarefas",
    "1. Sempre leia o arquivo \`.agents/rules/regras_projeto.md\` antes de propor alteracoes.",
    "2. Divida tarefas grandes em pequenos passos e marque-as como concluidas no arquivo \`task.md\` se aplicavel.",
    "3. Se houver alguma duvida conceitual, pergunte antes de prosseguir com mudancas de infraestrutura."
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
if ($Encapsulated) {
    Write-Host "`n[WORKSPACE] 3. Gerando arquivo de Workspace da IDE..." -ForegroundColor Blue
    $cleanFileName = $ProjectName.ToLower().Replace(" ", "_")
    
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
# 5. CONFIGURACAO DE VERSIONAMENTO (GIT)
# ==========================================
if ($GitInit) {
    Write-Host "`n[GIT] 5. Inicializando repositorio Git..." -ForegroundColor Blue
    
    if ($Encapsulated) {
        # Git isolado na pasta .agents
        Write-Host "  Inicializando Git na pasta $agentsDir..." -ForegroundColor Cyan
        & {
            $pwd = Get-Location
            Set-Location "$agentsDir"
            git init
            Create-If-Not-Exists -Path ".gitignore" -Content (@("node_modules/", "*.log", ".DS_Store") -join [Environment]::NewLine)
            Set-Location $pwd
        }
        
        # Git isolado na pasta .projeto
        Write-Host "  Inicializando Git na pasta $projectDir..." -ForegroundColor Cyan
        & {
            $pwd = Get-Location
            Set-Location "$projectDir"
            git init
            
            if ($techStack -eq "delphi") {
                $gitignoreContent = @("__history/", "*.dcu", "*.identcache", "*.local", "*.~*", "*.stat", "Win32/", "Win64/", "Debug/", "Release/") -join [Environment]::NewLine
            } elseif ($techStack -eq "python") {
                $gitignoreContent = @(".venv/", "__pycache__/", "*.pyc", ".pytest_cache/", ".env", "*.log") -join [Environment]::NewLine
            } else {
                $gitignoreContent = @("node_modules/", "*.log", ".env", ".DS_Store") -join [Environment]::NewLine
            }
            Create-If-Not-Exists -Path ".gitignore" -Content $gitignoreContent
            Set-Location $pwd
        }
    } else {
        # Git global na raiz
        git init
        
        if ($techStack -eq "delphi") {
            $gitignoreContent = @(".agents/plugins/*/node_modules/", "__history/", "*.dcu", "*.identcache", "*.local", "*.~*", "*.stat", "Win32/", "Win64/", "Debug/", "Release/") -join [Environment]::NewLine
        } elseif ($techStack -eq "python") {
            $gitignoreContent = @(".agents/plugins/*/node_modules/", ".venv/", "__pycache__/", "*.pyc", ".pytest_cache/", ".env", "*.log") -join [Environment]::NewLine
        } else {
            $gitignoreContent = @(".agents/plugins/*/node_modules/", "node_modules/", "*.log", ".env", ".DS_Store") -join [Environment]::NewLine
        }
        Create-If-Not-Exists -Path ".gitignore" -Content $gitignoreContent
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
