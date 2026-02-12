$ErrorActionPreference = "Stop"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget not found. Install App Installer from Microsoft Store."; exit 1
}

# Package IDs are best-effort and may need adjustment on your machine.
$packages = @(
    "Microsoft.PowerShell",
    "JanDeDobbeleer.OhMyPosh",
    "NerdFonts.JetBrainsMono",
    "Microsoft.WSL",
    "Microsoft.AzureCLI",
    "Microsoft.Azd",
    "OpenTofu.OpenTofu",
    "Microsoft.DotNet.SDK.8",
    "Docker.DockerDesktop",
    "Git.Git",
    "GitHub.cli",
    "Amazon.AWSCLI",
    "Kubernetes.kubectl",
    "JGraph.Draw",
    "Microsoft.WindowsTerminal",
    "Microsoft.VisualStudioCode",
    "Microsoft.VisualStudio.Community",
    "JetBrains.Rider",
    "JetBrains.RustRover",
    "JetBrains.PyCharm.Community",
    "JetBrains.WebStorm",
    "Brave.Brave",
    "OneCommander.OneCommander",
    "PDFgear.PDFgear",
    "Notepad++.Notepad++",
    "Perforce.P4Merge"
)

foreach ($pkg in $packages) {
    Write-Host "Installing $pkg"
    winget install --id $pkg -e --accept-source-agreements --accept-package-agreements || Write-Host "Failed: $pkg"
}

Write-Host "Windows bootstrap complete. Review docs/setup-checklist.md for anything not available via winget."
