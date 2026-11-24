# Enable Powerlevel10k instant prompt. Must stay at the top.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Zinit ───────────────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[[ ! -d $ZINIT_HOME ]] && mkdir -p "$(dirname $ZINIT_HOME)" && \
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ── Theme ───────────────────────────────────────────────────────
zinit ice depth=1
zinit light romkatv/powerlevel10k

# ── Plugins ─────────────────────────────────────────────────────
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

# OMZ plugin snippets
zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit snippet OMZ::plugins/sublime/sublime.plugin.zsh

# ── Completions ─────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# ── History ─────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# ── Directory navigation ─────────────────────────────────────────
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT

# ── Env ─────────────────────────────────────────────────────────
# Secrets live in ~/.env (chmod 600, not tracked). Example:
#   export OPENAI_API_KEY="sk-..."
[ -f ~/.env ] && source ~/.env
export CLAUDE_CODE_NO_FLICKER=1
export PATH="$HOME/.local/bin:$PATH"

# ── fzf ─────────────────────────────────────────────────────────
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# ── Aliases ──────────────────────────────────────────────────────
alias cat='bat --paging=never'
alias find='fd'
alias grep='rg'

# zoxide (smarter cd)
eval "$(zoxide init zsh)"

# ── yazi ─────────────────────────────────────────────────────────
# `y` launches yazi and cd's to its last directory on quit.
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# ── p10k ─────────────────────────────────────────────────────────
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ── Machine-local overrides ─────────────────────────────────────
# Non-secret, per-machine config. Sourced last so it can override anything above.
[[ ! -f ~/.zshrc.local ]] || source ~/.zshrc.local  # `||` form keeps $? = 0 when absent (no red first prompt)
