$ErrorActionPreference = "Stop"

function Get-NvmExePath {
    $nvmCmd = Get-Command nvm -ErrorAction SilentlyContinue
    if ($nvmCmd) {
        return $nvmCmd.Source
    }

    $candidateHomes = @()
    if ($env:NVM_HOME) {
        $candidateHomes += $env:NVM_HOME
    }
    if ($env:ProgramFiles) {
        $candidateHomes += (Join-Path $env:ProgramFiles "nvm")
    }
    if (${env:ProgramFiles(x86)}) {
        $candidateHomes += (Join-Path ${env:ProgramFiles(x86)} "nvm")
    }

    foreach ($home in $candidateHomes) {
        $candidate = Join-Path $home "nvm.exe"
        if (Test-Path $candidate) {
            return $candidate
        }
    }

    return $null
}

function Ensure-NvmWindows {
    $nvmExe = Get-NvmExePath
    if ($nvmExe) {
        Write-Host "nvm-windows already available at: $nvmExe"
        return $nvmExe
    }

    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw "winget not found. Install App Installer from Microsoft Store."
    }

    $packageId = "CoreyButler.NVMforWindows"
    Write-Host "Installing $packageId via winget..."
    winget install --id $packageId -e --accept-source-agreements --accept-package-agreements

    $nvmExe = Get-NvmExePath
    if (-not $nvmExe) {
        throw "nvm installed but not visible in this shell. Open a new PowerShell session and rerun this script."
    }

    return $nvmExe
}

function Invoke-Nvm {
    param(
        [Parameter(Mandatory=$true)][string]$NvmExe,
        [Parameter(Mandatory=$true)][string[]]$Arguments,
        [switch]$AllowFailure
    )

    & $NvmExe @Arguments
    if (-not $AllowFailure -and $LASTEXITCODE -ne 0) {
        throw "nvm command failed: $NvmExe $($Arguments -join ' ')"
    }
}

function Get-NodeSymlinkDir {
    if ($env:NVM_SYMLINK) {
        return $env:NVM_SYMLINK
    }

    $settingsCandidates = @()
    if ($env:NVM_HOME) {
        $settingsCandidates += (Join-Path $env:NVM_HOME "settings.txt")
    }
    if ($env:ProgramFiles) {
        $settingsCandidates += (Join-Path $env:ProgramFiles "nvm\settings.txt")
    }
    if (${env:ProgramFiles(x86)}) {
        $settingsCandidates += (Join-Path ${env:ProgramFiles(x86)} "nvm\settings.txt")
    }

    foreach ($settingsPath in $settingsCandidates) {
        if (-not (Test-Path $settingsPath)) {
            continue
        }
        $pathLine = Get-Content $settingsPath | Where-Object { $_ -like "path:*" } | Select-Object -First 1
        if ($pathLine) {
            return ($pathLine -replace "^path:\s*", "").Trim()
        }
    }

    return "C:\Program Files\nodejs"
}

function Resolve-NpmCommand {
    $npmCmd = Get-Command npm -ErrorAction SilentlyContinue
    if ($npmCmd) {
        return $npmCmd.Source
    }

    $nodeSymlinkDir = Get-NodeSymlinkDir
    $npmPath = Join-Path $nodeSymlinkDir "npm.cmd"
    if (Test-Path $npmPath) {
        return $npmPath
    }

    throw "npm command not found after nvm setup. Open a new PowerShell session and rerun."
}

$nvmExe = Ensure-NvmWindows

Write-Host "Installing/activating Node.js LTS via nvm-windows..."
Invoke-Nvm -NvmExe $nvmExe -Arguments @("install", "lts") -AllowFailure
if ($LASTEXITCODE -ne 0) {
    Write-Host "nvm install lts failed, falling back to latest."
    Invoke-Nvm -NvmExe $nvmExe -Arguments @("install", "latest")
    Invoke-Nvm -NvmExe $nvmExe -Arguments @("use", "latest")
} else {
    Invoke-Nvm -NvmExe $nvmExe -Arguments @("use", "lts")
}

$npmCommand = Resolve-NpmCommand
Write-Host "Installing @openai/codex globally..."
& $npmCommand install -g @openai/codex
if ($LASTEXITCODE -ne 0) {
    throw "Failed to install @openai/codex globally."
}

Write-Host "Node and codex installation completed for Windows."
