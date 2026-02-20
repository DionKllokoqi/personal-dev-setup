# Tool Install Notes

## WSL scripts

- Some installers require `sudo` and will prompt for your password.
- `scripts/wsl/install.sh` does a best-effort install of Oh My Zsh and `pyenv-virtualenv` if dependencies and network are available.
- `scripts/wsl/tools/install-node-codex.sh` installs nvm, Node.js LTS, and `@openai/codex` natively in WSL.
- `scripts/wsl/tools/install-aws-cli.sh` installs AWS CLI v2 from the official AWS zip installer.
- `scripts/wsl/tools/install-dotnet.sh` adds Microsoft's apt feed (if missing) and installs the latest available `dotnet-sdk-*` package.
- After installing Rustup, open a new shell or source `~/.cargo/env`.
- After installing pyenv, ensure the snippet in `.zshrc` is present and open a new shell.
- WSL `.zshrc` removes common Windows Node paths from `PATH` (`/mnt/c/...nodejs`) so native WSL Node/Codex stay first.
- If Node/npm/Codex are installed, `scripts/wsl/verify.sh` validates they resolve under `~/.nvm`.

## Windows scripts

- `winget` installs may require elevation depending on package and policy.
- `scripts/windows/tools.ps1` installs nvm-windows and picks the highest available `Microsoft.DotNet.SDK.<major>` package at runtime.
- `scripts/windows/install-node-codex.ps1` installs/uses Node.js LTS with nvm-windows and installs `@openai/codex` with npm.
- Some packages might not be found by ID on your system; edit `scripts/windows/tools.ps1` if needed.
