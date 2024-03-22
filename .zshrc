### SET XDG USER DIRECTORES ###
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

### EXPORT ###
export TERM="xterm-256color"                                  # For getting proper colors
export WGETRC=$XDG_CONFIG_HOME/wgetrc                         # To set xdg base directory for wget
export LESSHISTFILE=-                                         # Prevent creation of ~/.lesshst file
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"       # Change python history file location

### COLORISE LESS ###
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

### SET ZLE TO EMACS MODE ###
bindkey -e

### HISTORY SETTINGS ###
HISTSIZE=10000
SAVEHIST=10000
alias history='history 1'
HISTFILE=$XDG_DATA_HOME/zsh/zsh_history

# Set colors for ls command
if [ -f "$XDG_CONFIG_HOME/lscolors/lscolors.sh" ]; then
  . $XDG_CONFIG_HOME/lscolors/lscolors.sh
fi

### USE MODERN COMPLETION SYSTEM ###
autoload -Uz compinit
compinit
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'

### CHANGE CURSOR SHAPE BASED ON MODE ###

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

# Use beam shape cursor for each new prompt.
function _fix_cursor {
  echo -ne '\e[5 q'
}
precmd_functions+=(_fix_cursor)

### Use Ctrl+Right/Left to move between words ###
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

### Use Ctrl + Backspace to delete word backwards ###
bindkey "^H" backward-kill-word

### SET MANPAGER
if command -v bat > /dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT='-c'
elif command -v batcat > /dev/null; then
  export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
  export MANROFFOPT='-c'
else
  export MANPAGER='less'
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

### PATH ###
if [ -d "$HOME/.bin" ]; then
  PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/Applications" ]; then
  PATH="$HOME/Applications:$PATH"
fi

if [ -d "/var/lib/flatpak/exports/bin/" ]; then
  PATH="/var/lib/flatpak/exports/bin/:$PATH"
fi

if [ -d "/usr/games/" ]; then
  PATH="/usr/games/:$PATH"
fi

if [ -d "/snap/bin/" ]; then
  PATH="/snap/bin/:$PATH"
fi

if [ -d "/home/linuxbrew/.linuxbrew/sbin" ]; then
  PATH="/home/linuxbrew/.linuxbrew/sbin:$PATH"
fi

if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
  PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi

### SETOPT ###
setopt histsavenodups # do not save duplicated command
setopt histfindnodups # when searching for history entries, do not display duplicates
setopt histignorespace # don't store command lines in history when the first character is a space 
setopt histreduceblanks # remove unnecessary blanks
setopt incappendhistory # append typed commands to histfile immediately
setopt noautoremoveslash # don't remove slash for directories after auto tab completion
setopt globdots # show hidden files in tab completion
unsetopt listtypes # don't show trailing identifying marks for files while listing for completion

### SET EDITOR ###
if command -v nvim > /dev/null; then
  export EDITOR="nvim"
  export VISUAL="nvim"
  export SUDO_EDITOR="nvim"
fi

### ALIASES ###

# To select correct neovim
if command -v nvim > /dev/null; then
  alias vim='nvim'
fi

# To set XDG Base Directory for wget
[ -f $XDG_CONFIG_HOME/wgetrc ] || touch $XDG_CONFIG_HOME/wgetrc && alias wget='wget --hsts-file=$XDG_CACHE_HOME/wget-hsts'

# Tree command - Show all files including hidden ones
alias tree='tree -a'

# Better ls commands
if command -v lsd > /dev/null; then
  alias ls='lsd -A'
  alias ll > /dev/null && unalias ll # Delete alias ll if it exists
  function ll {
    if [ "$1" = "-g" ]; then
      shift
      lsd -Al --blocks permission,user,group,size,date,name --date +%d\ %b\ %H:%M --size short --group-directories-first "$@"
    elif [ "$1" = "-y" ]; then
      shift
      lsd -Al --blocks permission,user,group,size,date,name --date +%d\ %b\ %Y\ %H:%M --size short --group-directories-first "$@"
    else
      lsd -Al --blocks permission,user,size,date,name --date +%d\ %b\ %H:%M --size short --group-directories-first "$@"
    fi
  }
  alias lt='lsd -A --tree --group-directories-first'
else
  alias ls='ls -A --color=auto --group-directories-first'
  alias ll='ls -Alh --color=auto --group-directories-first'
  alias lt='tree --dirsfirst'
fi

# Colorize grep output (good for log files)
alias grep='grep -i --color=auto'
alias egrep='grep -E'
alias fgrep='grep -f'
alias rgrep='grep -r'

# Adding flags
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

# Add verbose output to cp, mv & mkdir
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'

# Enable command-line trash
if command -v trash > /dev/null; then
  alias rm='trash'
fi

# Colorize cat command
if command -v bat > /dev/null; then
  alias cat='bat --style=plain'
elif command -v batcat > /dev/null; then
  alias cat='batcat --style=plain'
fi

# Reason for space at the end: To make aliases work even if preceded by sudo
alias sudo='sudo '

# Change apt command to nala
if command -v nala > /dev/null; then
  alias apt='nala'
fi

# Allows shellcheck to follow any file the script may source
alias shellcheck='shellcheck -x'

# Force start btop even if no UTF-8 locale was detected
alias btop='btop --utf-force'

# Colorise ip command
alias ip='ip -color=auto'

### RANDOM COLOR SCRIPT ###
# Get this script from my Github: github.com/shreyas-a-s/shell-color-scripts
if command -v colorscript > /dev/null; then
  colorscript random
fi

### AUTOJUMP
if [ -f "/usr/share/autojump/autojump.zsh" ]; then
  . /usr/share/autojump/autojump.zsh
elif command -v zoxide > /dev/null; then
  eval "$(zoxide init zsh)"
fi

### FUNCTIONS ###

# Git functions
function gcom {
  git add .
  git commit -m "$@"
}

function lazyg {
  git add .
  git commit -m "$@"
  git push
}

# Create and go to the directory
function mkdircd {
  mkdir -p "$1"
  cd "$1"
}

# My Ping ;)
function ping {
  if [ -z "$1" ]; then
    command ping -c 1 example.org
  else
    command ping -c 1 "$@"
  fi
}

### COMMAND-LINE PASTEBINS ###

# Function to use ix.io
function ix {
  curl -F "f:1=@$1" https://ix.io
  printf "\n"
}

# Function to use paste.rs
function paste {
  curl --data-binary "@$1" https://paste.rs
  printf "\n"
}

# Function to use 0x0.st
function 0x0 {
  curl -F "file=@$1" https://0x0.st
  printf "\n"
}

# Colorise diff
function diff {
  if command -v bat > /dev/null; then
    command diff -r "$@" | bat --style=plain -l diff
  elif command -v batcat > /dev/null; then
    command diff -r "$@" | batcat --style=plain -l diff
  else
    command diff -r --color=auto "$@"
  fi
}

### AUTOSUGGESTIONS ###
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  . /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Fish-like intelligent autosuggestions
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)

### SYNTAX-HIGHLIGHTING ###
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

### COMMAND-NOT-FOUND ###

# zsh command-not-found handler
if [ -f /etc/zsh_command_not_found ]; then
  . /etc/zsh_command_not_found
fi

# pkgfile "command not found" handler for zsh
if [ -f /usr/share/doc/pkgfile/command-not-found.zsh ]; then
  . /usr/share/doc/pkgfile/command-not-found.zsh
fi

### OH MY ZSH PLUGINS

# History search using UP and DOWN
if command -v pacman > /dev/null || command -v dnf > /dev/null; then
  uparrow='^[[A'
  downarrow='^[[B'
else
  uparrow="$terminfo[kcuu1]"
  downarrow="$terminfo[kcud1]"
fi
if [ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
  . /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
  unset HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND
  unset HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND
  HISTORY_SUBSTRING_SEARCH_PREFIXED='true'
  bindkey "$uparrow" history-substring-search-up
  bindkey "$downarrow" history-substring-search-down
elif [ -f $XDG_CONFIG_HOME/zsh/zsh-history-substring-search.zsh ]; then
  . $XDG_CONFIG_HOME/zsh/zsh-history-substring-search.zsh
  bindkey "$uparrow" history-substring-search-up
  bindkey "$downarrow" history-substring-search-down
else
  bindkey "$uparrow" history-beginning-search-backward
  bindkey "$downarrow" history-beginning-search-forward
fi

### SETTING THE STARSHIP PROMPT ###
if command -v starship > /dev/null; then
  eval "$(starship init zsh)"
else
  PS1='%F{yellow}%n%F{green}@%M:%F{blue}%~%f$ '
fi

