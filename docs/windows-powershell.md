# PowerShell Profile

The PowerShell profile file is stored at:

- `dotfiles/windows/powershell/Microsoft.PowerShell_profile.ps1`

It:

- Loads Oh My Posh with the `powerlevel10k_modern` theme
- Enables PSReadLine history predictions
- Uses ListView prediction UI
- Removes duplicate history entries
- Disables the bell
- Loads Terminal-Icons (if installed)
- Enables `gh` and `dotnet` completions

If your Oh My Posh themes path differs, update the fallback path in the profile or set `POSH_THEMES_PATH`.
