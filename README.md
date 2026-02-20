# personal-dev-setup

This repo captures my Windows + WSL development setup (dotfiles, terminal settings, and scripts) so I can recreate it on a new machine.

## Structure

- `dotfiles/wsl/` – WSL/Ubuntu dotfiles
- `dotfiles/windows/` – Windows-specific configs
- `dotfiles/shared/` – Shared configs used by both sides
- `windows/terminal/` – Windows Terminal settings
- `scripts/` – Setup and bootstrap scripts
- `docs/` – Notes and checklists

WSL dotfiles include `~/.zshrc`, `~/.p10k.zsh`, and `~/.tmux.conf`. Codex config is generated from `dotfiles/wsl/.codex/config.toml.tmpl` to `~/.codex/config.toml`.

## Quick start (WSL)

1. Clone the repo.
2. Run the WSL installer:

```bash
scripts/wsl/install.sh
```

This links dotfiles and does a best-effort install of Oh My Zsh, Powerlevel10k, and required Zsh plugins.

3. Set `zsh` as your default login shell:

```bash
chsh -s "$(which zsh)"
```

Close and reopen your WSL session, then verify:

```bash
echo "$SHELL"
```

Optional: install baseline packages:

```bash
scripts/wsl/bootstrap.sh
```

This installs core shell/tools.

Optional: install individual tools:

```bash
scripts/wsl/tools/install-node-codex.sh
scripts/wsl/tools/install-aws-cli.sh
scripts/wsl/tools/install-dotnet.sh
scripts/wsl/tools/install-rustup.sh
scripts/wsl/tools/install-pyenv.sh
scripts/wsl/tools/install-azure-cli.sh
scripts/wsl/tools/install-azd.sh
scripts/wsl/tools/install-opentofu.sh
```

Verify setup:

```bash
scripts/wsl/verify.sh
```

## Quick start (Windows)

1. Clone the repo.
2. Run the PowerShell installer:

```powershell
scripts\\windows\\install.ps1
```

Optional: install baseline packages:

```powershell
scripts\\windows\\bootstrap.ps1
```

This installs core tools.

Optional: install individual tools:

```powershell
scripts\\windows\\tools.ps1
scripts\\windows\\install-node-codex.ps1
```

This includes optional tools such as nvm-windows, Rustup, and the highest available `Microsoft.DotNet.SDK.<major>` package from winget. `install-node-codex.ps1` installs Node.js (LTS) via nvm-windows and then installs Codex via npm.

Verify setup:

```powershell
scripts\\windows\\verify.ps1
```

## Personal placeholders

This repo uses placeholders for personal data (name, email, etc). Update these after cloning:

- `dotfiles/wsl/gitconfig.wsl`
- `dotfiles/windows/gitconfig.windows`
- `dotfiles/windows/powershell/Microsoft.PowerShell_profile.ps1`

## Notes

- Windows Terminal settings are in `windows/terminal/settings.json`.
- PowerShell profile notes: `docs/windows-powershell.md`.
- Editor settings sync: `docs/editor-sync.md`.
- Tool install notes: `docs/tools-install-notes.md`.
- Safe testing guide: `docs/safe-testing.md`.
- If any tool is missing, check `docs/` for the setup checklist.
- Keep Node/Codex installs separate by OS: run Node/Codex installers inside each environment (PowerShell for Windows, WSL shell for Ubuntu).
