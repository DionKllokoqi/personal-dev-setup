# Safe Testing Guide

## Problem statement

Validate this setup repository end-to-end without risking your main Windows/WSL environment.

## Core approach

- Use disposable environments first.
- Run install scripts.
- Run verification scripts.
- Promote to your main machine only after verification passes.

## WSL safe test

1. Create a throwaway distro.
2. Clone this repository in that distro.
3. Run setup:

```bash
scripts/wsl/bootstrap.sh
scripts/wsl/install.sh
scripts/wsl/verify.sh
```

4. Optional manual spot checks:

```bash
zsh --version
git --version
tmux -V
az version
azd version
tofu version
rustc --version
pyenv --version
```

## Windows safe test

1. Use Windows Sandbox, Hyper-V VM, or a clean secondary Windows user profile.
2. Clone this repository.
3. Run setup:

```powershell
scripts\windows\bootstrap.ps1
scripts\windows\install.ps1
scripts\windows\tools.ps1
scripts\windows\verify.ps1
```

4. Optional manual spot checks:

```powershell
pwsh -v
oh-my-posh version
gh --version
dotnet --info
kubectl version --client
```

## Safety gates before production use

- Compare expected file changes before and after with Git or file diff.
- Confirm backup directory creation:
  - WSL: `~/.dotfiles-backup/`
  - Windows: `%USERPROFILE%\.dotfiles-backup\`
- Run scripts one-by-one on first pass, not all at once.
