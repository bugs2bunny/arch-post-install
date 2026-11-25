
# ==========================================
# Zsh configuration
# ==========================================

# ------------------------------------------
# Completion
# ------------------------------------------

autoload -Uz compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{cyan}-- %d --%f'

# Store completion cache in XDG cache directory
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_CACHE_DIR"

compinit -d "$ZSH_CACHE_DIR/zcompdump"


# ------------------------------------------
# Keybindings
# ------------------------------------------

# Use Emacs-style keybindings
bindkey -e

# Home / End / Delete
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line
bindkey '\e[3~' delete-char


# ------------------------------------------
# History
# ------------------------------------------

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_EXPIRE_DUPS_FIRST


# ------------------------------------------
# Shell options
# ------------------------------------------

setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt EXTENDED_GLOB
setopt NO_BEEP


# ------------------------------------------
# Aliases
# ------------------------------------------

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Listing
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'

# System
alias update='sudo pacman -Syu'

# Editors
alias v='vim'


# ------------------------------------------
# Functions
# ------------------------------------------

# Remove orphan packages
cleanup() {
    local -a orphans

    orphans=("${(@f)$(pacman -Qtdq 2>/dev/null)}")
    orphans=("${orphans[@]:#}")

    if (( ${#orphans[@]} )); then
        echo "Removing orphan packages:"
        printf '  %s\n' "${orphans[@]}"
        sudo pacman -Rns -- "${orphans[@]}"
    else
        echo "No orphan packages found."
    fi
}


# ------------------------------------------
# Prompt
# ------------------------------------------

PROMPT='%F{cyan}%n%f@%F{green}%m%f %F{blue}%~%f
%F{cyan}❯%f '


# ------------------------------------------
# Fastfetch
# ------------------------------------------

if [[ -o interactive ]] && command -v fastfetch >/dev/null 2>&1; then
    fastfetch
fi

# ==========================================
# Plugins
# ==========================================

# Autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Customize suggestion color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# FZF - fuzzy finder
source <(fzf --zsh)

# Syntax highlighting (MUST be loaded last)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

