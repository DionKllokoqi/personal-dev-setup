$ErrorActionPreference = "Stop"

function Resolve-OpenCodeCommand {
    $cmd = Get-Command opencode -ErrorAction SilentlyContinue
    if ($cmd) {
        return $cmd.Source
    }

    $candidates = @(
        (Join-Path $env:USERPROFILE ".opencode\bin\opencode.exe"),
        (Join-Path $env:GOPATH "bin\opencode.exe"),
        (Join-Path $env:USERPROFILE "go\bin\opencode.exe")
    )

    foreach ($candidate in $candidates) {
        if (Test-Path $candidate) {
            return $candidate
        }
    }

    return $null
}

$existingOpenCode = Resolve-OpenCodeCommand
if ($existingOpenCode) {
    Write-Host "OpenCode already installed at: $existingOpenCode"
    & $existingOpenCode --version
    exit 0
}

if (-not (Get-Command go -ErrorAction SilentlyContinue)) {
    throw "Go is required to install OpenCode on Windows (no native Windows installer available). Install Go first."
}

Write-Host "Installing OpenCode via go install..."
go install github.com/opencode-ai/opencode@latest

$installedOpenCode = Resolve-OpenCodeCommand
if (-not $installedOpenCode) {
    throw "OpenCode installation finished, but 'opencode' was not found. Ensure GOPATH/bin is in your PATH, then rerun this script."
}

Write-Host "opencode -> $installedOpenCode"
& $installedOpenCode --version

Write-Host "Installed OpenCode for Windows successfully."
