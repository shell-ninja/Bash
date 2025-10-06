#!/bin/bash

#==============================================================================

# ███████╗██╗  ██╗███████╗██╗         ███╗   ██╗██╗███╗   ██╗     ██╗ █████╗ 
# ██╔════╝██║  ██║██╔════╝██║         ████╗  ██║██║████╗  ██║     ██║██╔══██╗
# ███████╗███████║█████╗  ██║         ██╔██╗ ██║██║██╔██╗ ██║     ██║███████║
# ╚════██║██╔══██║██╔══╝  ██║         ██║╚██╗██║██║██║╚██╗██║██   ██║██╔══██║
# ███████║██║  ██║███████╗███████╗    ██║ ╚████║██║██║ ╚████║╚█████╔╝██║  ██║
# ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝    ╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚════╝ ╚═╝  ╚═╝
                                                                            
#==============================================================================

# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\x1b[38;5;214m"
end="\e[1;0m"

# prompt function
msg() {
    local actn=$1
    local msg=$2

    case "$actn" in
        act)
            echo -e "${green}=>${end} $msg"
            ;;
        att)
            echo -e "${yellow}!!${end} $msg"
            ;;
        ask)
            echo -e "${orange}??${end} $msg"
            ;;
        dn)
            echo -e "${cyan}::${end} $msg\n"
            ;;
        skp)
            echo -e "${magenta}[ SKIP ]${end} $msg"
            ;;
        err)
            echo -e "${red}>< Ohh no! an error...${end}\n   $msg\n"
            ;;
    esac
}

# log file
dir="$(dirname "$(realpath "$0")")"
log="$dir/bash-install-$(date +%I:%M_%p).log"
touch "$log"

# required packages
common_packages=(
    bash-completion
    bat
    curl
    eza
    fastfetch
    figlet
    fzf
    git
    less
    zoxide
)

for_opensuse=(
    python311
    python311-pip
    python311-pipx
)

clear && printf "${green}::${end} Starting the script...\n"
sleep 1
echo

# asking some questions
msg ask "Would you like to install a Nerd font? In this case, the ${yellow}JetBrains Mono Nerd Font${end}? It is important. [ y/n ]"
read -p "Select: " font

echo

msg ask "Would you like to use ${cyan}starship${end} as the bash prompt? [ y/n ]"
read -p "Select: " prmpt


# package installation function
fn_install() {
    local pkg=$1

    if [ -n "$(command -v pacman)" ]; then  # Arch Linux
        if sudo pacman -Q "$pkg" &> /dev/null; then
            msg skp "Skipping $pkg, it was already installed..."
        else
            msg act "Installing $pkg..."
            sudo pacman -S --noconfirm "$pkg" 2>&1 | tee -a "$log" &> /dev/null
            if sudo pacman -Q "$pkg" &> /dev/null; then
                msg dn "$pkg was installed successfully!"
            else
                msg err "Could not install $pkg"
            fi
        fi
    elif [ -n "$(command -v dnf)" ]; then  # Fedora
        if rpm -q "$pkg" &> /dev/null; then
            msg skp "Skipping $pkg, it was already installed..."
        else
            msg act "Installing $pkg..."
            sudo dnf install -y "$pkg" 2>&1 | tee -a "$log"
            if rpm -q "$pkg" &> /dev/null; then
                msg dn "$pkg was installed successfully!"
            else
                msg err "Could not install $pkg"
            fi
        fi
    elif [ -n "$(command -v zypper)" ]; then # opensuse
        if sudo zypper se -i "$pkg" &> /dev/null; then
            msg skp "Skipping $pkg, it was already installed..."
        else
            msg act "Installing $pkg..."
            sudo zypper in -y "$pkg" 2>&1 | tee -a "$log"
            if sudo zypper se -i "$pkg" &> /dev/null; then
                msg dn "$pkg was installed successfully!"
            else
                msg err "Could not install $pkg"
            fi
        fi
    elif [ -n "$(command -v apt)" ]; then	# debian
        sudo apt install -y "$pkg" 2>&1 | tee -a "$log"
    else
        echo "Unsupported distribution."
        return 1
    fi
}

# install the packages
for pkgs in "${common_packages[@]}"; do
   fn_install "$pkgs" 2>&1 | tee -a "$log"
done

if command -v zypper &> /dev/null; then
    for pkgs in "${for_opensuse[@]}"; do
        fn_install "$pkgs" 2>&1 | tee -a "$log"
    done

    # installing thefu*k
    if command -v pipx &> /dev/null; then
        pipx runpip thefuck install setuptools &> /dev/null
        sleep 0.5
        pipx install --python python3.11 thefuck &> /dev/null 2>&1 | tee -a "$log"

        if command -v thefuck &> /dev/null; then
            msg dn "thef*ck was installed successfully!" && sleep 1
        fi
    fi

elif command -v pacman &> /dev/null; then  # Arch Linux
    fn_install thefuck 2>&1 | tee -a "$log"
elif command -v dnf &> /dev/null; then  # Fedora
    fn_install thefuck 2>&1 | tee -a "$log"
fi

# installing starship
if command -v pacman &> /dev/null; then
    fn_install starship
elif command -v zypper &> /dev/null; then
    fn_install starship
elif command -v dnf &> /dev/null; then
    sudo dnf copr enable -y atim/starship
    fn_install starship
fi

msg act "Installing bash files..." && sleep 0.5

# Check and backup the directories and file
for item in "$HOME/.bash" "$HOME/.bashrc"; do
    mkdir -p ~/.bash-backup-${USER}
    if [[ -d $item ]]; then
        case $item in
            $HOME/.bash)
                msg att "A ${green}.bash${end} directory is available. backing it up.." 
                mv "$item" "$HOME/.bash-backup-${USER}/.bash"-$(date +%I:%M:%S%p) 2>&1 | tee -a "$log"
                ;;
        esac
    elif [[ -f $item ]]; then
        case $item in
            $HOME/.bashrc)
                msg att "A ${cyan}.bashrc${end} file is available, backing it up.." 
                mv "$item" "$HOME/.bash-backup-${USER}/.bashrc"-$(date +%I:%M:%S%p) 2>&1 | tee -a "$log"
                ;;
        esac
    fi
done

# now copy the .bash directory into the "$HOME" directory.
cp -r "$dir/.bash" ~/ 2>&1 | tee -a "$log"

[[ -f "$HOME/.bash/.bashrc" ]] && ln -sf ~/.bash/.bashrc ~/.bashrc 2>&1 | tee -a "$log"

# installing bash autosuggestions and syntal highlighting.
if [ -d ~/.bash ]; then
    msg act "Updating some scripts..." && sleep 1

    curl -L https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz | tar xJf - 2>&1 | tee -a "$log" &> /dev/null
    bash ble-nightly/ble.sh --install ~/.local/share 2>&1 | tee -a "$log" &> /dev/null

    if [ -f ~/.blerc ]; then
        msg act "Backing up ~/.blerc file"
        mv ~/.blerc "$HOME/bash-backup-${USER}/"
        ln -sf ~/.bash/.blerc ~/.blerc 2>&1 | tee -a "$log"
    fi

    if [[ "$prmpt" =~ ^[Y|y]$ ]]; then
        if [ -f ~/.config/starship.toml ]; then
            msg act "Backing up your old starship.toml..." && sleep 1
            mv ~/.config/starship.toml ~/.config/starship.toml.back
        fi

        # Comment out the PS1 line
        sed -i 's/^PS1=/# PS1=/' ~/.bash/.bashrc

        # Uncomment the starship init bash line
        sed -i 's/^# eval "\(.*starship init bash.*\)"/eval "\1"/' ~/.bash/.bashrc

        msg dn "Updated .bashrc file. Commented out PS1 and enabled Starship prompt."
    fi
fi

sleep 1
echo


if [[ "$font" =~ ^[Yy]$ ]]; then
    msg act "Installing the ${yello}JetBrains Mono Nerd Font${end}"

    DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
    # Maximum number of download attempts
    MAX_ATTEMPTS=2
    for ((ATTEMPT = 1; ATTEMPT <= MAX_ATTEMPTS; ATTEMPT++)); do
        curl -OL "$DOWNLOAD_URL" && break
        msg att "Download attempt $ATTEMPT failed. Retrying in 2 seconds..."
        sleep 2
    done

    # Check if the JetBrainsMono folder exists and delete it if it does
    if [ -d ~/.local/share/fonts/JetBrainsMonoNerd ]; then
        rm -rf ~/.local/share/fonts/JetBrainsMonoNerd &> /dev/null
    fi

    # Extract the new files into the JetBrainsMono folder and log the output
    tar -xJkf JetBrainsMono.tar.xz -C ~/.local/share/fonts/JetBrainsMonoNerd

    # Update font cache and log the output
    sudo fc-cache -fv &> /dev/null

    # clean up 
    if [ -d "JetBrainsMono.tar.xz" ]; then
        rm -r JetBrainsMono.tar.xz &> /dev/null
    fi
else
    msg skp "Skipping installing the ${yellow}JetBrainsMono Nerd Font${end}.\n         Please install a nerd font manually and set it to your terminal..."
fi

sleep 1 && clear

# making scripts executable
if [[ -f "$HOME/.bash/alias.sh" ]]; then
    if chmod +x "$HOME/.bash"/*; then
        msg dn "Bash configuration has been completed! Close the tarminal and open it again." && sleep 2
        exit 0
    else
        msg err "Could not make all the scripts executable."
        printf " Run: \n \"chmod +x ~/.bash/*\" in your terminal"
    fi
fi

#__________ ( code finishes here ) __________#
