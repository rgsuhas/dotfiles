# dotfiles

My Debian dev environment. Clone and run `bootstrap.sh` to get back up and running.

## What's in here

```
bootstrap.sh          ← run this first on a fresh machine
git/
  .gitconfig          ← git identity + gh credential helper
kitty/
  .config/kitty/      ← terminal config
packages/
  apt-packages.txt    ← system packages
  vscode-extensions.txt ← VS Code extensions
  pip-packages.txt    ← Python packages (reference only)
```

## Fresh machine setup

```bash
git clone https://github.com/rgsuhas/dotfiles ~/dotfiles
cd ~/dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
```

## Stack

- OS: Debian (KDE Plasma)
- Terminal: kitty
- Shell: bash (fish available)
- Editor: VS Code
- Node: pnpm + Node LTS
- Containers: Docker
- Languages: Go, Python 3, Node.js
- Tools: gh CLI, btop, OpenClaw

## After bootstrap

1. `gh auth login` — authenticate GitHub
2. `openclaw setup` — configure AI assistant
3. Restore SSH keys from backup
4. Set up any project-specific `.env` files
