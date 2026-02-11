# Oh My Posh theme (uses default themes location if available)
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    $poshTheme = if ($env:POSH_THEMES_PATH) {
        Join-Path $env:POSH_THEMES_PATH "powerlevel10k_modern.omp.json"
    } else {
        $null
    }

    if ($poshTheme -and (Test-Path $poshTheme)) {
        oh-my-posh init pwsh --config $poshTheme | Invoke-Expression
    } else {
        # Fallback to a user-specific path if POSH_THEMES_PATH is not set
        $fallbackTheme = "C:\\Users\\YOUR_USER\\AppData\\Local\\Programs\\oh-my-posh\\themes\\powerlevel10k_modern.omp.json"
        if (Test-Path $fallbackTheme) {
            oh-my-posh init pwsh --config $fallbackTheme | Invoke-Expression
        }
    }
}

# Modules
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -HistoryNoDuplicates
    Set-PSReadLineOption -BellStyle None
}

if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module -Name Terminal-Icons
}

# GitHub CLI completions
if (Get-Command gh -ErrorAction SilentlyContinue) {
    Invoke-Expression -Command (gh completion -s powershell | Out-String)
}

# dotnet completions
if (Get-Command dotnet -ErrorAction SilentlyContinue) {
    dotnet completions script pwsh | Out-String | Invoke-Expression
}
