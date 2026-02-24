$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $scriptDir "..\..")

function Ensure-BackupDir {
    $backupDir = Join-Path $env:USERPROFILE (".dotfiles-backup\" + (Get-Date -Format "yyyyMMdd-HHmmss"))
    New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
    return $backupDir
}

$backupDir = Ensure-BackupDir
Write-Host "Backup directory for this run: $backupDir"

function Copy-WithBackup {
    param(
        [Parameter(Mandatory=$true)][string]$Source,
        [Parameter(Mandatory=$true)][string]$Destination,
        [Parameter(Mandatory=$true)][string]$BackupDir
    )

    if (Test-Path $Destination) {
        Copy-Item -Path $Destination -Destination $BackupDir -Force
    }

    Copy-Item -Path $Source -Destination $Destination -Force
}

# Git config template (update placeholders after copy)
$gitConfigDest = Join-Path $env:USERPROFILE ".gitconfig"
if (-not (Test-Path $gitConfigDest)) {
    Copy-WithBackup -Source (Join-Path $repoRoot "dotfiles\windows\gitconfig.windows") -Destination $gitConfigDest -BackupDir $backupDir
    Write-Host "Created $gitConfigDest from template. Remember to update name/email placeholders."
}

# Global gitignore template
$globalGitignoreDest = Join-Path $env:USERPROFILE ".gitignore_global"
if (-not (Test-Path $globalGitignoreDest)) {
    Copy-WithBackup -Source (Join-Path $repoRoot "dotfiles\shared\gitignore_global") -Destination $globalGitignoreDest -BackupDir $backupDir
    Write-Host "Created $globalGitignoreDest from template."
}

# PowerShell profile
$psProfileDir = Join-Path $env:USERPROFILE "Documents\PowerShell"
$psProfileDest = Join-Path $psProfileDir "Microsoft.PowerShell_profile.ps1"
New-Item -ItemType Directory -Force -Path $psProfileDir | Out-Null
Copy-WithBackup -Source (Join-Path $repoRoot "dotfiles\windows\powershell\Microsoft.PowerShell_profile.ps1") -Destination $psProfileDest -BackupDir $backupDir
Write-Host "Updated PowerShell profile at $psProfileDest"

# Windows Terminal settings
$wtSettings = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $wtSettings) {
    Copy-WithBackup -Source (Join-Path $repoRoot "windows\terminal\settings.json") -Destination $wtSettings -BackupDir $backupDir
    Write-Host "Updated Windows Terminal settings.json"
} else {
    Write-Host "Windows Terminal settings.json not found at: $wtSettings"
}
