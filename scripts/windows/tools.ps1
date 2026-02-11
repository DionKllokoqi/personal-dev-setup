$ErrorActionPreference = "Stop"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget not found. Install App Installer from Microsoft Store."; exit 1
}

$packages = @(
    "Rustlang.Rustup",
    "Microsoft.AzureCLI",
    "Microsoft.Azd",
    "OpenTofu.OpenTofu",
    "Kubernetes.kubectl"
)

foreach ($pkg in $packages) {
    Write-Host "Installing $pkg"
    winget install --id $pkg -e --accept-source-agreements --accept-package-agreements || Write-Host "Failed: $pkg"
}
