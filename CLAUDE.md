# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A personal Windows + WSL2 development environment setup: dotfiles, terminal settings, and installation scripts for recreating the full dev toolchain on a new machine.

## Running the Scripts

### WSL
```bash
# Install dotfiles (links .zshrc, .p10k.zsh, .tmux.conf; renders Codex config template)
bash scripts/wsl/install.sh

# Install core Ubuntu packages (git, zsh, tmux, htop, fzf, eza, etc.)
bash scripts/wsl/bootstrap.sh

# Verify the setup
bash scripts/wsl/verify.sh

# Optional tool installers (each is standalone)
bash scripts/wsl/tools/install-node-codex.sh
bash scripts/wsl/tools/install-claude-code.sh
bash scripts/wsl/tools/install-pyenv.sh
bash scripts/wsl/tools/install-rustup.sh
bash scripts/wsl/tools/install-dotnet.sh
bash scripts/wsl/tools/install-aws-cli.sh
bash scripts/wsl/tools/install-azure-cli.sh
bash scripts/wsl/tools/install-azd.sh
bash scripts/wsl/tools/install-opentofu.sh
```

### Windows (PowerShell, run as Admin)
```powershell
# Install dotfiles (PowerShell profile, gitconfig, Windows Terminal settings)
.\scripts\windows\install.ps1

# Install all packages via winget (IDEs, CLIs, utilities)
.\scripts\windows\bootstrap.ps1

# Install optional dev tools (nvm-windows, Rust, .NET, etc.)
.\scripts\windows\tools.ps1

# Verify the setup
.\scripts\windows\verify.ps1

# Separate installers for AI tools
.\scripts\windows\install-node-codex.ps1
.\scripts\windows\install-claude-code.ps1
```

## Architecture

### Key Structural Decisions

**WSL vs Windows tool separation**: Node.js/Codex and Claude Code must be installed per-OS using the OS-native installers — never cross-mounted from `/mnt/c`. The `.zshrc` actively filters Windows Node paths from `$PATH`.

**Template rendering**: `dotfiles/wsl/.codex/config.toml.tmpl` is a template rendered during `install.sh` with `$HOME` substituted into the output at `~/.codex/config.toml`. Do not edit the rendered file directly.

**Symlinks vs copies**: WSL `install.sh` creates symlinks for `.zshrc`, `.p10k.zsh`, `.tmux.conf`; it copies (not links) gitconfig files. Windows `install.ps1` copies all files.

**Backup before overwrite**: Both install scripts create a timestamped backup at `~/.dotfiles-backup/<timestamp>/` (WSL) or `%USERPROFILE%\.dotfiles-backup\<timestamp>\` (Windows) before touching existing files.

**Graceful failures**: bootstrap scripts use best-effort installs — a missing package does not abort the run.

### Dotfiles Location

| File | Source | Destination |
|------|--------|-------------|
| `.zshrc` | `dotfiles/wsl/.zshrc` | `~/.zshrc` (symlink) |
| `.p10k.zsh` | `dotfiles/wsl/.p10k.zsh` | `~/.p10k.zsh` (symlink) |
| `.tmux.conf` | `dotfiles/wsl/.tmux.conf` | `~/.tmux.conf` (symlink) |
| `gitconfig.wsl` | `dotfiles/wsl/gitconfig.wsl` | `~/.gitconfig` (copy) |
| `gitconfig.windows` | `dotfiles/windows/gitconfig.windows` | `%USERPROFILE%\.gitconfig` (copy) |
| PowerShell profile | `dotfiles/windows/powershell/Microsoft.PowerShell_profile.ps1` | `~/Documents/PowerShell/` (copy) |
| Windows Terminal | `windows/terminal/settings.json` | `%LOCALAPPDATA%\Packages\...\settings.json` (copy) |

### Personal Placeholders

`gitconfig.wsl` and `gitconfig.windows` contain `YOUR_NAME` and `you@example.com` — these must be updated manually after first copy. The install scripts warn but do not block on this.

## Tool Inventory

See `docs/setup-checklist.md` for the full authoritative list. See `docs/tools-install-notes.md` for how specific installers work (especially `.NET` version selection logic and Claude Code migration from npm to native).

## Safe Testing

Use a disposable WSL distro or Windows Sandbox VM (never test against your live environment). Run `install.sh` → `verify.sh` in sequence. See `docs/safe-testing.md` for the full process.
