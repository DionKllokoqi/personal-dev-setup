# Tool Install Notes

## WSL scripts

- Some installers require `sudo` and will prompt for your password.
- `scripts/wsl/install.sh` does a best-effort install of Oh My Zsh and `pyenv-virtualenv` if dependencies and network are available.
- After installing Rustup, open a new shell or source `~/.cargo/env`.
- After installing pyenv, ensure the snippet in `.zshrc` is present and open a new shell.

## Windows scripts

- `winget` installs may require elevation depending on package and policy.
- Some packages might not be found by ID on your system; edit `scripts/windows/tools.ps1` if needed.
