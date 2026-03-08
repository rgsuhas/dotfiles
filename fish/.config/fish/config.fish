# ── Environment ───────────────────────────────────────────────────────────────
set -gx EDITOR zed
set -gx VISUAL zed
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
set -gx GOPATH "$HOME/go"

# ── PATH ──────────────────────────────────────────────────────────────────────
fish_add_path $PNPM_HOME
fish_add_path $GOPATH/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin

# ── Starship prompt ───────────────────────────────────────────────────────────
if command -q starship
    starship init fish | source
end

# ── Aliases ───────────────────────────────────────────────────────────────────
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline --graph --decorate -15"
alias gd="git diff"

alias ..="cd .."
alias ...="cd ../.."

alias ls="ls --color=auto"
alias ll="ls -lah --color=auto"
alias la="ls -A --color=auto"

# Zed
alias z="zed ."

# Docker shortcuts
alias dc="docker compose"
alias dps="docker ps"

# ── Key bindings ──────────────────────────────────────────────────────────────
# ctrl+f accepts autosuggestion word by word
bind \cf forward-word
