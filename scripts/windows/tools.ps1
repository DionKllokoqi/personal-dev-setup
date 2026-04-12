$ErrorActionPreference = "Stop"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget not found. Install App Installer from Microsoft Store."; exit 1
}

$packages = @(
    "CoreyButler.NVMforWindows",
    "Rustlang.Rustup",
    "Microsoft.AzureCLI",
    "Microsoft.Azd",
    "OpenTofu.OpenTofu",
    "Kubernetes.kubectl"
)

function Get-LatestDotnetSdkPackageId {
    for ($major = 20; $major -ge 6; $major--) {
        $id = "Microsoft.DotNet.SDK.$major"
        winget show --id $id -e --accept-source-agreements *> $null
        if ($LASTEXITCODE -eq 0) {
            return $id
        }
    }
    return $null
}

$dotnetSdkPackage = Get-LatestDotnetSdkPackageId
if ($dotnetSdkPackage) {
    Write-Host "Selected latest .NET SDK package: $dotnetSdkPackage"
    $packages += $dotnetSdkPackage
} else {
    Write-Host "Failed to find a Microsoft.DotNet.SDK.<major> package in winget."
}

foreach ($pkg in $packages) {
    Write-Host "Installing $pkg"
    winget install --id $pkg -e --accept-source-agreements --accept-package-agreements || Write-Host "Failed: $pkg"
}

Write-Host "To install Node LTS + codex via nvm-windows, run: scripts\\windows\\install-node-codex.ps1"
Write-Host "To install Claude Code natively, run: scripts\\windows\\install-claude-code.ps1"
Write-Host "To install OpenCode (requires Go), run: scripts\\windows\\install-opencode.ps1"
