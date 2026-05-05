#!/bin/bash

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

# Color definitions
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\x1b[38;5;214m"
end="\e[1;0m"

# Message prompt function
msg() {
    local actn=$1
    local msg=$2

    case "$actn" in
        act) echo -e "${green}=>${end} $msg" ;;
        att) echo -e "${yellow}!!${end} $msg" ;;
        ask) echo -e "${orange}??${end} $msg" ;;
        dn)  echo -e "${cyan}::${end} $msg\n" ;;
        skp) echo -e "${magenta}[ SKIP ]${end} $msg" ;;
        err) echo -e "${red}>< Ohh no! an error...${end}\n   $msg\n" ;;
    esac
}

# Log file setup
dir="$(dirname "$(realpath "$0")")"
log="$dir/bash-install-$(date +%I:%M_%p).log"
touch "$log"

# Required packages
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
    pv
)

for_opensuse=(
    python311
    python311-pip
    python311-pipx
)

clear && printf "${green}::${end} Starting the script...\n"
sleep 1
echo

# Package manager detection
PKG_MANAGER=""
if command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
elif command -v zypper &> /dev/null; then
    PKG_MANAGER="zypper"
    common_packages+=("${for_opensuse[@]}")
elif command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
else
    msg err "Unsupported distribution. Could not find pacman, dnf, zypper, or apt."
    exit 1
fi

# Ask questions early
msg ask "Would you like to install a Nerd font? In this case, the ${yellow}JetBrains Mono Nerd Font${end}? It is important. [ y/n ]"
read -r -p "Select: " font
echo

msg ask "Would you like to use ${cyan}starship${end} as the bash prompt? [ y/n ]"
read -r -p "Select: " prmpt
echo

# Helper functions for packages
fn_is_installed() {
    local pkg=$1
    case "$PKG_MANAGER" in
        pacman) pacman -Q "$pkg" &> /dev/null ;;
        dnf) rpm -q "$pkg" &> /dev/null ;;
        zypper) zypper se -i "$pkg" &> /dev/null ;;
        apt) dpkg -l "$pkg" &> /dev/null ;;
    esac
}

fn_install() {
    local pkg=$1

    if fn_is_installed "$pkg"; then
        msg skp "Skipping $pkg, it is already installed..."
        return 0
    fi

    msg act "Installing $pkg..."
    case "$PKG_MANAGER" in
        pacman) sudo pacman -S --noconfirm "$pkg" 2>&1 | tee -a "$log" > /dev/null ;;
        dnf) sudo dnf install -y "$pkg" 2>&1 | tee -a "$log" > /dev/null ;;
        zypper) sudo zypper in -y "$pkg" 2>&1 | tee -a "$log" > /dev/null ;;
        apt) sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$pkg" 2>&1 | tee -a "$log" > /dev/null ;;
    esac

    if fn_is_installed "$pkg"; then
        msg dn "$pkg was installed successfully!"
    else
        msg err "Could not install $pkg"
    fi
}

# Install core packages
for pkg in "${common_packages[@]}"; do
    fn_install "$pkg"
done

# Install thefuck
if [ "$PKG_MANAGER" = "zypper" ]; then
    if command -v pipx &> /dev/null; then
        msg act "Installing thefuck via pipx..."
        pipx runpip thefuck install setuptools &> /dev/null
        sleep 0.5
        pipx install --python python3.11 thefuck 2>&1 | tee -a "$log" > /dev/null || true

        if command -v thefuck &> /dev/null; then
            msg dn "thef*ck was installed successfully!" && sleep 1
        else
            msg err "Could not install thefuck"
        fi
    fi
elif [[ "$PKG_MANAGER" =~ ^(pacman|dnf|apt)$ ]]; then
    fn_install thefuck
fi

# Install starship
if [ "$PKG_MANAGER" = "dnf" ]; then
    msg act "Enabling starship copr repo..."
    sudo dnf copr enable -y atim/starship 2>&1 | tee -a "$log" > /dev/null
fi

if [ "$PKG_MANAGER" != "apt" ]; then
    fn_install starship
else
    if ! command -v starship &> /dev/null; then
        msg act "Installing starship via official installer..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y 2>&1 | tee -a "$log" > /dev/null
        msg dn "starship installed successfully!"
    else
        msg skp "Skipping starship, it is already installed..."
    fi
fi

msg act "Installing bash files..." && sleep 0.5

# Backup existing files
BACKUP_DIR="$HOME/.bash-backup-${USER}"
for item in "$HOME/.bash" "$HOME/.bashrc"; do
    if [[ -d $item ]] || [[ -f $item ]]; then
        mkdir -p "$BACKUP_DIR"
        timestamp=$(date +%I:%M:%S%p)
        if [[ -d $item ]]; then
            msg att "A ${green}.bash${end} directory is available. Backing it up..." 
            mv "$item" "$BACKUP_DIR/.bash-$timestamp" 2>&1 | tee -a "$log"
        elif [[ -f $item ]]; then
            msg att "A ${cyan}.bashrc${end} file is available. Backing it up..." 
            mv "$item" "$BACKUP_DIR/.bashrc-$timestamp" 2>&1 | tee -a "$log"
        fi
    fi
done

# Copy custom .bash directory
if [[ -d "$dir/.bash" ]]; then
    cp -r "$dir/.bash" ~/ 2>&1 | tee -a "$log"
    [[ -f "$HOME/.bash/.bashrc" ]] && ln -sf ~/.bash/.bashrc ~/.bashrc 2>&1 | tee -a "$log"
else
    msg err "Could not find $dir/.bash to copy!"
fi

# Update scripts and install ble.sh
if [ -d ~/.bash ]; then
    msg act "Installing ble.sh (nightly)..." && sleep 1

    TMP_BLE=$(mktemp -d)
    if curl -sL https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz | tar xJf - -C "$TMP_BLE" 2>&1 | tee -a "$log" > /dev/null; then
        bash "$TMP_BLE/ble-nightly/ble.sh" --install ~/.local/share 2>&1 | tee -a "$log" > /dev/null
    else
        msg err "Failed to download or extract ble.sh"
    fi
    rm -rf "$TMP_BLE"

    if [ -f ~/.blerc ]; then
        msg act "Backing up ~/.blerc file..."
        mkdir -p "$BACKUP_DIR"
        mv ~/.blerc "$BACKUP_DIR/.blerc-$(date +%I:%M:%S%p)" 2>&1 | tee -a "$log"
    fi
    # Link the new .blerc if it exists in .bash
    [[ -f ~/.bash/.blerc ]] && ln -sf ~/.bash/.blerc ~/.blerc 2>&1 | tee -a "$log"

    # Configure starship in bashrc
    if [[ "$prmpt" =~ ^[Yy]$ ]]; then
        if [ -f ~/.config/starship.toml ]; then
            msg act "Backing up your old starship.toml..." && sleep 1
            mv ~/.config/starship.toml ~/.config/starship.toml.back
        fi

        if [[ -f ~/.bash/.bashrc ]]; then
            # Comment out standard PS1 and uncomment starship init
            sed -i 's/^PS1=/# PS1=/' ~/.bash/.bashrc
            sed -i 's/^# eval "\(.*starship init bash.*\)"/eval "\1"/' ~/.bash/.bashrc
            msg dn "Updated .bashrc file. Commented out PS1 and enabled Starship prompt."
        fi
    fi
fi

sleep 1
echo

# Font installation
if [[ "$font" =~ ^[Yy]$ ]]; then
    msg act "Installing the ${yellow}JetBrains Mono Nerd Font${end}"

    DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
    TMP_FONT=$(mktemp -d)
    
    # Maximum number of download attempts
    MAX_ATTEMPTS=2
    SUCCESS=false
    for ((ATTEMPT = 1; ATTEMPT <= MAX_ATTEMPTS; ATTEMPT++)); do
        if curl -fLo "$TMP_FONT/JetBrainsMono.tar.xz" "$DOWNLOAD_URL" > /dev/null 2>&1; then
            SUCCESS=true
            break
        fi
        msg att "Download attempt $ATTEMPT failed. Retrying in 2 seconds..."
        sleep 2
    done

    if [ "$SUCCESS" = true ]; then
        FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerd"
        # Cleanup existing font directory
        if [ -d "$FONT_DIR" ]; then
            rm -rf "$FONT_DIR" > /dev/null 2>&1
        fi
        mkdir -p "$FONT_DIR"

        # Extract the new files
        tar -xJkf "$TMP_FONT/JetBrainsMono.tar.xz" -C "$FONT_DIR" > /dev/null 2>&1

        # Update font cache
        msg act "Updating font cache..."
        sudo fc-cache -fv > /dev/null 2>&1
        msg dn "JetBrains Mono Nerd Font installed successfully!"
    else
        msg err "Failed to download JetBrains Mono Nerd Font after $MAX_ATTEMPTS attempts."
    fi

    # Clean up 
    rm -rf "$TMP_FONT"
else
    msg skp "Skipping installing the ${yellow}JetBrains Mono Nerd Font${end}.\n         Please install a nerd font manually and set it to your terminal..."
fi

sleep 1 && clear

# Make scripts executable
if [[ -d "$HOME/.bash" ]]; then
    if chmod +x "$HOME/.bash"/* 2>/dev/null; then
        msg dn "Bash configuration has been completed! Close the terminal and open it again." && sleep 2
        exit 0
    else
        msg err "Could not make all the scripts executable."
        printf " Run: \n \"chmod +x ~/.bash/*\" in your terminal\n"
    fi
fi

#__________ ( code finishes here ) __________#
