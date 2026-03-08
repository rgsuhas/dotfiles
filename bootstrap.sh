#!/usr/bin/env bash
# bootstrap.sh — Recreate rgsuhas dev environment on Debian
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Starting bootstrap..."

# ── 1. System packages ─────────────────────────────────────────────────────
echo "📦 Installing apt packages..."

# Docker repo
if ! command -v docker &>/dev/null; then
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list
fi

# GitHub CLI repo
if ! command -v gh &>/dev/null; then
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list
fi

sudo apt update
sudo apt install -y $(cat "$DOTFILES_DIR/packages/apt-packages.txt" | grep -v "^#\|^$")

# ── 2. VS Code ──────────────────────────────────────────────────────────────
if ! command -v code &>/dev/null; then
  echo "💻 Installing VS Code..."
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/microsoft.gpg
  sudo install -D -o root -g root -m 644 /tmp/microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main" \
    | sudo tee /etc/apt/sources.list.d/vscode.list
  sudo apt update && sudo apt install -y code
fi

echo "🔌 Installing VS Code extensions..."
while IFS= read -r ext; do
  [[ -z "$ext" || "$ext" == \#* ]] && continue
  code --install-extension "$ext" --force
done < "$DOTFILES_DIR/packages/vscode-extensions.txt"

# ── 3. Node via pnpm ───────────────────────────────────────────────────────
if ! command -v pnpm &>/dev/null; then
  echo "📦 Installing pnpm..."
  curl -fsSL https://get.pnpm.io/install.sh | sh -
  source ~/.bashrc
fi

if ! command -v node &>/dev/null; then
  echo "📦 Installing Node.js LTS via pnpm..."
  pnpm env use --global lts
fi

# ── 4. OpenClaw ────────────────────────────────────────────────────────────
if ! command -v openclaw &>/dev/null; then
  echo "🦞 Installing OpenClaw..."
  npm install -g openclaw
fi

# ── 5. Symlink dotfiles with stow ─────────────────────────────────────────
if ! command -v stow &>/dev/null; then
  sudo apt install -y stow
fi

echo "🔗 Symlinking dotfiles..."
cd "$DOTFILES_DIR"
for dir in git kitty; do
  [ -d "$dir" ] && stow -v --target="$HOME" "$dir"
done

# ── 6. gh auth ─────────────────────────────────────────────────────────────
if ! gh auth status &>/dev/null; then
  echo "🔑 GitHub auth needed — run: gh auth login"
fi

echo ""
echo "✅ Bootstrap complete!"
echo "   Remaining manual steps:"
echo "   - gh auth login"
echo "   - openclaw setup"
echo "   - Set up SSH keys if needed"
