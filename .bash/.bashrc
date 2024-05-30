# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# source all the alias and functions
source ~/.bash/functions
source ~/.bash/alias

PS1='$(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && echo $(git_info) || echo "") \n $(if [[ "$PWD" = "$HOME" ]]; then echo "\e[1;36m󰜥\e[1;0m"; elif [[ "$PWD" = "/" ]]; then echo "\e[1;36m\e[1;0m"; else echo "\W"; fi) \e[1;32m\e[1;0m '

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

#ignore upper and lowercase when TAB completion
# bind "set completion-ignore-case on"

unset rc
# neofetch
source ~/.local/share/blesh/ble.sh

