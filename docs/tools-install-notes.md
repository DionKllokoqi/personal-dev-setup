# Tool Install Notes

## WSL scripts

- Some installers require `sudo` and will prompt for your password.
- `scripts/wsl/install.sh` does a best-effort install of Oh My Zsh and `pyenv-virtualenv` if dependencies and network are available.
- `scripts/wsl/bootstrap.sh` installs `xdg-utils` and `wslu` so WSL CLI tools can open browser flows through `xdg-open`/`wslview`.
- `scripts/wsl/install.sh` renders `dotfiles/wsl/.codex/config.toml.tmpl` to `~/.codex/config.toml` using the current `$HOME`.
- `scripts/wsl/tools/install-node-codex.sh` installs nvm, Node.js LTS, and `@openai/codex` natively in WSL.
- `scripts/wsl/tools/install-claude-code.sh` installs Claude Code with Anthropic's native installer (`https://claude.ai/install.sh`).
- If you previously installed Claude Code via npm (`@anthropic-ai/claude-code`), the new scripts keep that as-is but print migration guidance to native installer.
- `scripts/wsl/tools/install-aws-cli.sh` installs AWS CLI v2 from the official AWS zip installer.
- `scripts/wsl/tools/install-dotnet.sh` adds Microsoft's apt feed (if missing) and installs the latest available `dotnet-sdk-*` package.
- After installing Rustup, open a new shell or source `~/.cargo/env`.
- After installing pyenv, ensure the snippet in `.zshrc` is present and open a new shell.
- WSL `.zshrc` removes common Windows Node paths from `PATH` (`/mnt/c/...nodejs`) so native WSL Node/Codex stay first.
- WSL `.zshrc` sets `BROWSER` to `wslview` (fallback `xdg-open`) for deterministic browser launch behavior.
- If Node/npm/Codex are installed, `scripts/wsl/verify.sh` validates they resolve under `~/.nvm`.
- If Claude Code is installed in WSL, `scripts/wsl/verify.sh` checks that `claude` resolves to a native WSL path (not `/mnt/c/...`).

## Windows scripts

- `winget` installs may require elevation depending on package and policy.
- `scripts/windows/tools.ps1` installs nvm-windows and picks the highest available `Microsoft.DotNet.SDK.<major>` package at runtime.
- `scripts/windows/install-node-codex.ps1` installs/uses Node.js LTS with nvm-windows and installs `@openai/codex` with npm.
- `scripts/windows/install-claude-code.ps1` installs Claude Code with Anthropic's native installer (`https://claude.ai/install.ps1`).
- If you previously installed Claude Code via npm (`@anthropic-ai/claude-code`), the new scripts keep that as-is but print migration guidance to native installer.
- Some packages might not be found by ID on your system; edit `scripts/windows/tools.ps1` if needed.
