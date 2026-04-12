$ErrorActionPreference = "Stop"

function Fail {
    param([Parameter(Mandatory=$true)][string]$Message)
    Write-Error "FAIL: $Message"
    exit 1
}

function Assert-Command {
    param([Parameter(Mandatory=$true)][string]$Name)
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        Fail "Missing command: $Name"
    }
}

Write-Host "Verifying Windows profile/settings and tools..."

$psProfilePath = Join-Path $env:USERPROFILE "Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
if (-not (Test-Path $psProfilePath)) {
    Fail "PowerShell profile missing at $psProfilePath"
}

$wtSettings = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (-not (Test-Path $wtSettings)) {
    Fail "Windows Terminal settings missing at $wtSettings"
}

$gitConfig = Join-Path $env:USERPROFILE ".gitconfig"
if (-not (Test-Path $gitConfig)) {
    Fail "Git config missing at $gitConfig"
}

Assert-Command "pwsh"
Assert-Command "git"
Assert-Command "gh"
Assert-Command "dotnet"
Assert-Command "oh-my-posh"

Write-Host "Checking optional tools (informational)..."
$optional = @("az", "azd", "tofu", "kubectl", "aws", "rustup", "nvm", "node", "npm", "codex", "claude", "opencode")
foreach ($tool in $optional) {
    if (Get-Command $tool -ErrorAction SilentlyContinue) {
        Write-Host "OK(optional): $tool"
    } else {
        Write-Host "MISSING(optional): $tool"
    }
}

Write-Host "PASS: Windows verification completed"
