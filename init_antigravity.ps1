# ==============================================================================
# ANTIGRAVITY FACTORY - POWERSHELL INITIALIZER (PURE ASCII FOR COMPATIBILITY)
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
    [switch]$Interactive
)

Write-Host "============================================================" -ForegroundColor Magenta
Write-Host "   [*] Antigravity Structure Factory - Initializer [*]" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Magenta

# Se o usuario escolheu interativo
if ($Interactive) {
    Write-Host "[*] Entrando no modo interativo..." -ForegroundColor Yellow
    $tempName = Read-Host "Digite o nome do projeto [$ProjectName]"
    if ($tempName) { $ProjectName = $tempName }

    $tempPlugin = Read-Host "Deseja inicializar um plugin especifico? (Deixe em branco para nenhum)"
    if ($tempPlugin) { $PluginName = $tempPlugin }

    Write-Host "Selecione uma stack de tecnologia:"
    Write-Host "  1) Nenhuma (Generico)"
    Write-Host "  2) Delphi (Windows-1252, ERP, Firebird)"
    Write-Host "  3) Python (venv, pip/poetry, Clean Code)"
    $optTech = Read-Host "Opcao (1-3)"
    
    if ($optTech -eq "2") {
        $Delphi = $true
        $Python = $false
    } elseif ($optTech -eq "3") {
        $Python = $true
        $Delphi = $false
    }
}

# Definir stack padrao
$techStack = "generic"
if ($Delphi) { $techStack = "delphi" }
if ($Python) { $techStack = "python" }

# Funcao auxiliar para criar arquivos se nao existirem
function Create-If-Not-Exists {
    param (
        [string]$Path,
        [string]$Content
    )
    
    $parentDir = Split-Path -Path $Path -Parent
    if (!(Test-Path -Path $parentDir)) {
        $null = New-Item -ItemType Directory -Path $parentDir -Force
    }

    if (!(Test-Path -Path $Path)) {
        # Gravar em UTF-8 sem BOM para compatibilidade
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($Path, $Content, $utf8NoBom)
        Write-Host "  [+] Criado: $Path" -ForegroundColor Green
    } else {
        Write-Host "  [~] Ja existe (ignorado): $Path" -ForegroundColor Yellow
    }
}

Write-Host "`n[DIR] 1. Criando estrutura de diretorios padrao..." -ForegroundColor Blue
$null = New-Item -ItemType Directory -Path ".agents/skills" -Force
$null = New-Item -ItemType Directory -Path ".agents/rules" -Force

if ($PluginName) {
    Write-Host "  [PLUGIN] Configurando estrutura do plugin '$PluginName'..." -ForegroundColor Cyan
    $null = New-Item -ItemType Directory -Path ".agents/plugins/$PluginName/skills" -Force
    $null = New-Item -ItemType Directory -Path ".agents/plugins/$PluginName/rules" -Force
    $null = New-Item -ItemType Directory -Path ".agents/plugins/$PluginName/sidecars" -Force
}

# ==========================================
# 2. CONFIGURACOES EM NIVEL DE WORKSPACE
# ==========================================
Write-Host "`n[CONFIG] 2. Gerando arquivos de configuracao globais..." -ForegroundColor Blue

$hooksContent = @(
    "{",
    '  "PreToolUse": [],',
    '  "PostToolUse": []',
    "}"
) -join [Environment]::NewLine

Create-If-Not-Exists -Path ".agents/hooks.json" -Content $hooksContent

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

Create-If-Not-Exists -Path ".agents/rules/regras_projeto.md" -Content $rulesContent

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

Create-If-Not-Exists -Path ".agents/skills/core-skill/SKILL.md" -Content $skillContent

# ==========================================
# 3. CONFIGURACOES ESPECIFICAS DO PLUGIN
# ==========================================
if ($PluginName) {
    Write-Host "`n[PLUGIN] 3. Gerando arquivos do Plugin '$PluginName'..." -ForegroundColor Blue

    $pluginJsonContent = @(
        "{",
        "  ""name"": ""$PluginName"",",
        "  ""description"": ""Plugin personalizado para $ProjectName"",",
        "  ""version"": ""1.0.0""",
        "}"
    ) -join [Environment]::NewLine
    Create-If-Not-Exists -Path ".agents/plugins/$PluginName/plugin.json" -Content $pluginJsonContent

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
    Create-If-Not-Exists -Path ".agents/plugins/$PluginName/mcp_config.json" -Content $mcpConfigContent

    $pluginHooksContent = @(
        "{",
        "  ""PreToolUse"": []",
        "}"
    ) -join [Environment]::NewLine
    Create-If-Not-Exists -Path ".agents/plugins/$PluginName/hooks.json" -Content $pluginHooksContent

    $sidecarContent = @(
        "{",
        "  ""command"": ""echo \\""Sidecar do plugin '$PluginName' iniciado com sucesso\\"""",",
        "  ""restart_policy"": ""always"",",
        "  ""description"": ""Sidecar de exemplo rodando tarefas em background ou servidores locais""",
        "}"
    ) -join [Environment]::NewLine
    Create-If-Not-Exists -Path ".agents/plugins/$PluginName/sidecars/exemplo-sidecar/sidecar.json" -Content $sidecarContent
}

# ==========================================
# CONCLUIDO
# ==========================================
Write-Host "`n============================================================" -ForegroundColor Magenta
Write-Host "[SUCCESS] Estrutura Antigravity configurada com sucesso para seu projeto!" -ForegroundColor Green
Write-Host "   Para comecar a usar, faca uma pergunta ao Agente no chat."
Write-Host "============================================================" -ForegroundColor Magenta
