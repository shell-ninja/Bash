# ~/.bash/alias.sh
source ~/.bash/functions.sh

#==============================================================================
# ███████╗██╗  ██╗███████╗██╗     ██╗     
# ██╔════╝██║  ██║██╔════╝██║     ██║     
# ███████╗███████║█████╗  ██║     ██║     
# ╚════██║██╔══██║██╔══╝  ██║     ██║     
# ███████║██║  ██║███████╗███████╗███████╗
# ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
#                                         
# ███╗   ██╗██╗███╗   ██╗     ██╗ █████╗  
# ████╗  ██║██║████╗  ██║     ██║██╔══██╗ 
# ██╔██╗ ██║██║██╔██╗ ██║     ██║███████║ 
# ██║╚██╗██║██║██║╚██╗██║██   ██║██╔══██║ 
# ██║ ╚████║██║██║ ╚████║╚█████╔╝██║  ██║ 
# ╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚════╝ ╚═╝  ╚═╝ 
                                                                            
#==============================================================================

## list ##
alias ls='eza -T --level=1 --color=always --icons=always'
alias la='eza -a --icons=always'
alias ll='eza -l -a --icons=always --no-time'
alias lst='eza -T --level=2 --color=always --icons=always'
alias lsf='eza -f -a --color=always --icons=always'
alias lstd='eza -D -T --level=2 --color=always --icons=always'
alias tree='eza -T --level=3 --color=always --icons=always'

alias cat='bat --style header --style snip --style changes --style header'  # cat

alias grubup="sudo update-grub" # most other distros like Arch, Ubuntu
alias susegrub="sudo grub2-mkconfig -o /boot/grub2/grub.cfg"    # opensuse
alias fedbup="sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg" # fedora
alias ..='cd ..'    # go back
alias ...='cd ../..'    # go back 2 steps
alias .='cd /'  # go to root dir
alias cd='z'

# other
alias src='source ~/.bash/.bashrc' #source .bashrc
alias clr='clear'   #clear
alias cls='clear'
alias clar='clear'
alias c='clear'
alias q='exit'

alias rmv='fn_removal' #remove both file & direvtory ( one file / directory at a time )
alias srm='sudo rm -rf' # remove in a sude command
alias cp='fn_copy_paste'

# disk spaces and RAM usage
alias du='du -sh'
alias mem='fn_resources __memory'
alias disk='fn_resources __disk'

#fzf
alias find='nvim $(fzf --preview="bat --color=always {}")'

#nvim
alias nvm='nvim .'
alias open='nvim .'
alias snv='sudo -E nvim -d'

# check updates
alias cu='fn_check_updates'

# updates
alias dup='sudo zypper dup -y' # distro update for opensuse
alias update='fn_update'

# install and remove package
alias install='fn_install'
alias remove='fn_uninstall'

# compiling c++ file using gcc
alias cpp='fn_compile_cpp'

# git alias
alias add='git add .'
alias clone='git clone'
alias cloned='git clone --depth=1'
alias branch='git branch -M main'
alias commit='git commit -m'
# alias push='git push'
alias pushm='git push -u origin main'
alias pusho='git push origin' # and add your branch name 
alias pull='git pull'
alias info='git_info'

# others
alias nc='clr && neofetch'
alias neofetch='clr && neofetch'
alias ff='clr && fastfetch'
alias sys='btop'
alias clock='tty-clock -c -t -D -s'
alias mat='cmatrix'

alias sddt='sddm-greeter-qt6 --test-mode --theme'

alias style="~/.bash/change_prompt.sh"

# make executable script
alias exe='chmod +x'
