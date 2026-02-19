# personal-dev-setup

This repo captures my Windows + WSL development setup (dotfiles, terminal settings, and scripts) so I can recreate it on a new machine.

## Structure

- `dotfiles/wsl/` – WSL/Ubuntu dotfiles
- `dotfiles/windows/` – Windows-specific configs
- `dotfiles/shared/` – Shared configs used by both sides
- `windows/terminal/` – Windows Terminal settings
- `scripts/` – Setup and bootstrap scripts
- `docs/` – Notes and checklists

WSL dotfiles include `~/.zshrc`, `~/.p10k.zsh`, and `~/.tmux.conf`.

## Quick start (WSL)

1. Clone the repo.
2. Run the WSL installer:

```bash
scripts/wsl/install.sh
```

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

Optional: install individual tools:

```bash
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

Optional: install individual tools:

```powershell
scripts\\windows\\tools.ps1
```

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
