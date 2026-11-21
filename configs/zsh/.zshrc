
# ==========================================
# Zsh configuration
# ==========================================

# Completion
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{cyan}-- %d --%f'

# ==========================================
# History
# ==========================================

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS

# ==========================================
# Shell options
# ==========================================

setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt EXTENDED_GLOB
#setopt NO_BEEP

# ==========================================
# Aliases
# ==========================================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Listing
alias ll='ls -lah'
alias la='ls -A'
alias ls='ls --color=auto'

# System
alias update='sudo pacman -Syu'

cleanup() {
    local -a orphans
    orphans=("${(@f)$(pacman -Qtdq)}")

    if (( ${#orphans[@]} )); then
        sudo pacman -Rns -- "${orphans[@]}"
    else
        echo "No orphan packages found."
    fi
}

# Editors
alias vim='vim'
alias v='vim'

# ==========================================
# Prompt
# ==========================================

setopt PROMPT_SUBST
PROMPT='%F{cyan}%n%f@%F{green}%m%f %F{blue}%~%f
%F{cyan}❯%f '

# ==========================================
# Fastfetch
# ==========================================

if [[ -o interactive ]] && command -v fastfetch >/dev/null 2>&1; then
    fastfetch
fi

