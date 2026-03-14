$ErrorActionPreference = "Stop"

function Resolve-ClaudeCommand {
    $claudeCmd = Get-Command claude -ErrorAction SilentlyContinue
    if ($claudeCmd) {
        return $claudeCmd.Source
    }

    $candidates = @(
        (Join-Path $env:USERPROFILE ".local\bin\claude.exe"),
        (Join-Path $env:USERPROFILE ".claude\local\claude.exe"),
        (Join-Path $env:USERPROFILE ".claude\bin\claude.exe")
    )

    foreach ($candidate in $candidates) {
        if (Test-Path $candidate) {
            return $candidate
        }
    }

    return $null
}

function Show-LegacyNpmNotice {
    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
        return
    }

    & npm list -g --depth=0 @anthropic-ai/claude-code *> $null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Note: Found npm-installed @anthropic-ai/claude-code."
        Write-Host "Native install is now preferred; consider removing the npm package later:"
        Write-Host "  npm uninstall -g @anthropic-ai/claude-code"
    }
}

$existingClaude = Resolve-ClaudeCommand
if ($existingClaude) {
    Write-Host "Claude Code already installed at: $existingClaude"
    & $existingClaude --version
    Show-LegacyNpmNotice
    exit 0
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is required for Claude Code installation. Install Git for Windows first."
}

Write-Host "Installing Claude Code via native installer..."
Invoke-Expression (Invoke-RestMethod https://claude.ai/install.ps1)

$installedClaude = Resolve-ClaudeCommand
if (-not $installedClaude) {
    throw "Claude Code installation finished, but 'claude' was not found. Open a new PowerShell session and rerun this script."
}

Write-Host "claude -> $installedClaude"
& $installedClaude --version

Show-LegacyNpmNotice

Write-Host "Installed Claude Code for Windows successfully."
