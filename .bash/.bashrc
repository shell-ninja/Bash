#!/usr/bin/env bash
iatest=$(expr index "$-" i)
#==============================================================================

# ███████╗██╗  ██╗███████╗██╗         ███╗   ██╗██╗███╗   ██╗     ██╗ █████╗ 
# ██╔════╝██║  ██║██╔════╝██║         ████╗  ██║██║████╗  ██║     ██║██╔══██╗
# ███████╗███████║█████╗  ██║         ██╔██╗ ██║██║██╔██╗ ██║     ██║███████║
# ╚════██║██╔══██║██╔══╝  ██║         ██║╚██╗██║██║██║╚██╗██║██   ██║██╔══██║
# ███████║██║  ██║███████╗███████╗    ██║ ╚████║██║██║ ╚████║╚█████╔╝██║  ██║
# ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝    ╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚════╝ ╚═╝  ╚═╝
                                                                            
#==============================================================================


# ================================= fastfetch ================================= #
if command -v fastfetch &> /dev/null; then
    if [[ $- == *i* ]]; then
        if [[ -d "$HOME/.local/share/fastfetch" ]]; then
            export ffconfig=minimal
            fastfetch --config "$ffconfig"
            alias fastfetch='clr && fastfetch --config "$ffconfig"'
        else
            fastfetch
        fi
    fi
fi



# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh --attach=none

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Call update_ps1 before each prompt
export PROMPT_COMMAND='precmd; preexec'

# ================================= prompt ================================= #
PS1='$(if [[ "$PWD" = "$HOME" ]]; then echo "\e[1;36m\e[1;0m"; elif [[ "$PWD" = "/" ]]; then echo " \e[1;0m"; elif [[ ! "$PWD" == "$HOME" ]]; then echo "\n\w"; fi)\n\e[1;32m❯\e[1;0m '

# set prompt starship
# export STARSHIP_CONFIG=~/.bash/starship/starship-simple.toml
# eval "$(starship init bash)"



# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head 200; else bat -n --color=always --line-range :1000 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"


# =============== Load .bashrc.d Scripts Efficiently =============== #
if [ -d ~/.bashrc.d ]; then
    find ~/.bashrc.d -type f -name '*.sh' -exec . {} \;
fi


# ================================= fzf ================================= #
if [[ -x "$(command -v fzf)" ]]; then
	export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
	  --info=inline-right \
	  --ansi \
	  --layout=reverse \
	  --border=rounded \
	  --color=border:#27a1b9 \
	  --color=fg:#c0caf5 \
	  --color=gutter:#16161e \
	  --color=header:#ff9e64 \
	  --color=hl+:#2ac3de \
	  --color=hl:#2ac3de \
	  --color=info:#545c7e \
	  --color=marker:#ff007c \
	  --color=pointer:#ff007c \
	  --color=prompt:#2ac3de \
	  --color=query:#c0caf5:regular \
	  --color=scrollbar:#27a1b9 \
	  --color=separator:#ff9e64 \
	  --color=spinner:#ff007c \
	"
fi

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# Configure FZF for directory preview
if command -v fzf &> /dev/null; then
  _fzf_preview() {
    eza --color=always --icons=always "$1"
  }
fi


# ================================= completion and autocd ================================= #
bind "set completion-ignore-case on"
shopt -s autocd
unset rc



# ================================= add functionalities ================================= #
# Only load `thefuck` and `zoxide` when needed
_thefuck_init() { eval "$(thefuck --alias)"; unset -f _thefuck_init; }

alias fuck='_thefuck_init && fuck'
alias hell='_thefuck_init && hell'

# For zoxide integration with FZF (if zoxide is installed)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
    alias zi='zoxide query -i | xargs -r eza --color=always --icons=always'
    _ZO_DOCTOR=0
fi

# ================================= source functions, aliases and blers ================================= #
source ~/.bash/functions.sh
source ~/.bash/alias.sh
source ~/.bash/.blerc



# ================================= Expand the history size ================================= #
export HISTFILESIZE=10000
export HISTSIZE=500
export HISTTIMEFORMAT="%F %T" # add timestamp to history

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
PROMPT_COMMAND='history -a'
alias hist="history | grep"


# ================================= transient prompt and right prompt ================================= #
bleopt prompt_ps1_transient=always
bleopt prompt_ps1_final="❯ "

# bleopt prompt_rps1='\n$(current_time)'
bleopt prompt_rps1='\n$(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo $(git_info) || echo "")${elapsed_time_display}'


# ================================= vi mode ================================= #
if [[ $- == *i* ]]; then
  bind 'set editing-mode vi'
fi
bleopt keymap_vi_mode_show:=
bind "set show-mode-in-prompt on"
bind "set vi-cmd-mode-string "
bind "set vi-ins-mode-string "


# ================================= ble-attach ================================= #
if [[ ${BLE_VERSION-} ]]; then
    ble-attach
else
    (source ~/.local/share/blesh/ble.sh --attach=none &)  # Load in background
fi
