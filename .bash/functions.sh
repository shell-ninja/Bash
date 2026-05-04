# ~/.bash/functions.sh

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
# copy and paste Function
fn_copy_paste() {
    local destination="${!#}"
    local items=("${@:1:$(($#-1))}")

    mkdir -p "$destination" || {
        printf "!! Failed to create destination: %s\n" "$destination"
        return 1
    }

    for item in "${items[@]}"; do
        item="${item%/}"                 # normalize trailing slash
        local name="${item##*/}"
        local SUDO=""

        # ---- detect sudo need ----
        if [[ ! -r "$item" ]] || [[ ! -w "$destination" || ! -x "$destination" ]]; then
            SUDO="sudo"
        fi

        if [[ -f "$item" ]]; then
            printf "\n:: Copying file %s → %s\n" "$name" "$destination"

            if [[ "$name" == *.iso ]]; then
                # ISO-safe copy
                pv "$item" | $SUDO dd of="$destination/$name" bs=4M status=none
            else
                # Normal file
                if [[ -n "$SUDO" ]]; then
                    pv "$item" | sudo tee "$destination/$name" > /dev/null
                else
                    pv "$item" > "$destination/$name"
                fi
            fi

        elif [[ -d "$item" ]]; then
            printf "\n:: Copying directory %s → %s\n" "$name" "$destination"

            local parent
            parent="$(dirname "$item")"

            if [[ -n "$SUDO" ]]; then
                sudo tar -C "$parent" -cf - "$name" \
                | pv -N "$name" \
                | sudo tar -xf - -C "$destination"
            else
                tar -C "$parent" -cf - "$name" \
                | pv -N "$name" \
                | tar -xf - -C "$destination"
            fi

        else
            printf "!! Skipping unknown type: %s\n" "$item"
        fi
    done
}


# remove files and directories
fn_removal() {
    for item in "$@"; do
        if [[ -f "$item" ]]; then
            printf ":: Removing a file\n"
            rm "$item"
        elif [[ -d "$item" ]]; then
            printf ":: Removing a directory\n"
            rm -rf "$item"
        else
            printf "[ !! ]\n$item does not exist or is neither a regular file nor a directory\n"
        fi
    done
}

# disk spaces
fn_resources(){
    case $1 in
        __disk)
            disk_total=$(df / -h | awk 'NR==2 {print $2}')
            disk_used=$(df / -h | awk 'NR==2 {print $3}')
            disk_free=$(df / -h | awk 'NR==2 {print $4}')
            printf "Total: $disk_total\nUsed: $disk_used\nFree: $disk_free\n"
            ;;
        __memory)
            mem_total=$(free -h | awk 'NR==2 {print $2}')
            mem_used=$(free -h | awk 'NR==2 {print $3}')
            mem_free=$(free -h | awk 'NR==2 {print $7}')
            printf "Total: $mem_total\nUsed: $mem_used\nFree: $mem_free\n"
            ;;
    esac
}

# internal: detect package manager
_detect_pkg_manager() {
    [[ -n "$PKG_MANAGER" ]] && return
    if command -v pacman &>/dev/null; then
        export PKG_MANAGER="pacman"
        export AUR_HELPER=$(command -v yay 2>/dev/null || command -v paru 2>/dev/null || echo "")
    elif command -v dnf &>/dev/null; then
        export PKG_MANAGER="dnf"
    elif command -v zypper &>/dev/null; then
        export PKG_MANAGER="zypper"
    elif command -v apt-get &>/dev/null; then
        export PKG_MANAGER="apt"
    else
        export PKG_MANAGER="unknown"
    fi
}

# check updates
fn_check_updates() {
    _detect_pkg_manager
    if [[ "$PKG_MANAGER" == "pacman" ]]; then
        local aur=0
        if [[ -n "$AUR_HELPER" ]]; then
            aur=$("$AUR_HELPER" -Qua 2>/dev/null | wc -l)
        fi
        local ofc=$(checkupdates 2>/dev/null | wc -l)
        local upd=$(( ofc + aur ))
        printf "[ UPDATES ]\n:: You have \e[1;32m%d\e[0m updates available.\n:: Main: %d\n:: AUR: %d\n" "$upd" "$ofc" "$aur"
    elif [[ "$PKG_MANAGER" == "dnf" ]]; then
        local upd=$(dnf check-update -q 2>/dev/null | grep -v "^$" | wc -l)
        printf "[ UPDATES ]\n:: You have \e[1;32m%d\e[0m updates available\n" "$upd"
    elif [[ "$PKG_MANAGER" == "zypper" ]]; then
        local upd=$(zypper lu --best-effort 2>/dev/null | grep -c 'v  |')
        printf "[ UPDATES ]\n:: You have \e[1;32m%d\e[0m updates available\n" "$upd"
    elif [[ "$PKG_MANAGER" == "apt" ]]; then
        local upd=$(apt list --upgradable 2> /dev/null | grep -c '\[upgradable from')
        printf "[ UPDATES ]\n:: You have \e[1;32m%d\e[0m updates available\n" "$upd"
    else
        printf "\e[1;31m Unsupported package manager for now, please let us know in the github repository...\e[1;0m \n https://github.com/me-js-bro/Bash\n"
        return 1
    fi
}

# package updates
fn_update() {
    _detect_pkg_manager
    if [[ "$PKG_MANAGER" == "pacman" ]]; then
        if [[ -n "$AUR_HELPER" ]]; then
            "$AUR_HELPER" -Syyu --noconfirm
        else
            sudo pacman -Syyu --noconfirm
        fi
    elif [[ "$PKG_MANAGER" == "dnf" ]]; then
        sudo dnf update -y && sudo dnf upgrade -y --refresh
    elif [[ "$PKG_MANAGER" == "zypper" ]]; then
        sudo zypper ref && sudo zypper up -y
    elif [[ "$PKG_MANAGER" == "apt" ]]; then
        sudo apt update -y && sudo apt upgrade -y
    else
        printf "\e[1;31m Unsupported package manager for now, please let us know in the github repository...\e[1;0m \n https://github.com/me-js-bro/Bash\n"
        return 1
    fi
}

# Install software
fn_install() {
    _detect_pkg_manager
    if [[ "$PKG_MANAGER" == "pacman" ]]; then
        if [[ -n "$AUR_HELPER" ]]; then
            "$AUR_HELPER" -S --noconfirm "$@"
        else
            sudo pacman -S --noconfirm "$@"
        fi
    elif [[ "$PKG_MANAGER" == "dnf" ]]; then
        sudo dnf install -y "$@"
    elif [[ "$PKG_MANAGER" == "zypper" ]]; then
        sudo zypper in -y "$@"
    elif [[ "$PKG_MANAGER" == "apt" ]]; then
        sudo apt install -y "$@"
    else
        printf "\e[1;31m Unsupported package manager for now, please let us know in the GitHub repository...\e[1;0m \n https://github.com/me-js-bro/Bash\n"
        return 1
    fi
}

# package install
fn_uninstall() {
    _detect_pkg_manager
    if [[ "$PKG_MANAGER" == "pacman" ]]; then
        if [[ -n "$AUR_HELPER" ]]; then
            "$AUR_HELPER" -Rns "$@"
        else
            sudo pacman -Rns "$@"
        fi
    elif [[ "$PKG_MANAGER" == "dnf" ]]; then
        sudo dnf remove "$@"
    elif [[ "$PKG_MANAGER" == "zypper" ]]; then
        sudo zypper rm "$@"
    elif [[ "$PKG_MANAGER" == "apt" ]]; then
        sudo apt remove "$@"
    else
        printf "\e[1;31m Unsupported package manager for now, please let us know in the github repository...\e[1;0m \n https://github.com/me-js-bro/Bash\n"
        return 1
    fi
}

# compile cpp file with gcc
fn_compile_cpp() {
    filename="$1"
    if [ -n "$(command -v g++)" ]; then
        printf "\e[0;36m[ * ] - Compiling...!\e[0m\n\n"

        if g++ -std=c++20 "${filename}.cpp" -o "$filename"; then
            printf "\e[1;92m[ ✓ ] - Successfully compiled your code...!\e[0m\n"
            if [[ "$2" == "-o" ]]; then
                printf "\e[1;92m        Output: \e[0m\n\n" 
                "./$filename"
            fi
        else
            printf "\n\e[1;91m[  ] - Error: Could not compile your code...!\e[0m\n"
        fi
    fi
}

# git info
git_info() {
    # Check if current directory is a Git repository
    local branch_name
    branch_name=$(git branch --show-current 2>/dev/null) || return 0

    if [[ -n "$branch_name" ]]; then
        local untracked_count=0 unstaged_count=0 staged_count=0

        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            local x="${line:0:1}" y="${line:1:1}"
            if [[ "$x" == "?" && "$y" == "?" ]]; then
                ((untracked_count++))
            else
                [[ "$x" != " " && "$x" != "?" ]] && ((staged_count++))
                [[ "$y" != " " && "$y" != "?" ]] && ((unstaged_count++))
            fi
        done < <(git status --porcelain 2>/dev/null)

        printf "on \e[1;34m\e[1;32m %s\e[1;0m " "$branch_name"

        [[ "$untracked_count" -gt 0 ]] && printf "\e[1;31m?%d \e[3;0m" "$untracked_count"
        [[ "$staged_count" -gt 0 ]] && printf "\e[1;32m%d \e[3;0m" "$staged_count"
        [[ "$unstaged_count" -gt 0 ]] && printf "\e[1;33m!%d \e[3;0m" "$unstaged_count"

        if [[ "$untracked_count" -eq 0 && "$staged_count" -eq 0 && "$unstaged_count" -eq 0 ]]; then
            printf "\e[1;32m✓ \e[3;0m"
        fi
        printf "\n"
    fi
}

# fn to push git commits easily
push() {
    # Check if current directory is a Git repository
    local branch_name
    branch_name=$(git branch --show-current 2>/dev/null) || {
        printf "!! Not inside a Git repository.\n"
        return 1
    }

    local untracked_count=0 unstaged_count=0 staged_count=0
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        local x="${line:0:1}" y="${line:1:1}"
        if [[ "$x" == "?" && "$y" == "?" ]]; then ((untracked_count++))
        else
            [[ "$x" != " " && "$x" != "?" ]] && ((staged_count++))
            [[ "$y" != " " && "$y" != "?" ]] && ((unstaged_count++))
        fi
    done < <(git status --porcelain 2>/dev/null)

    if [[ "$untracked_count" -gt 0 ]]; then printf "=> %s untracked files\n" "$untracked_count"; fi
    if [[ "$unstaged_count" -gt 0 ]]; then printf "=> %s uncommitted changes\n" "$unstaged_count"; fi
    if [[ "$staged_count" -gt 0 ]]; then printf "=> %s staged changes\n" "$staged_count"; fi

    if [[ "$untracked_count" -eq 0 && "$unstaged_count" -eq 0 && "$staged_count" -eq 0 ]]; then
        printf "✓ Nothing to push.\n"
        return 0
    fi

    printf "=> %s branch\n\nWrite the commit message\n" "$branch_name"

    local msg
    if command -v gum &>/dev/null; then
        msg="$(gum input --placeholder "Write your commit message")"
    else
        read -r -p "=> " msg
    fi

    [[ -z "$msg" ]] && { printf "!! Aborting due to empty commit message.\n"; return 1; }

    git add .
    if ! git commit -m "$msg"; then
        printf "!! Commit failed.\n"
        return 1
    fi

    if [[ "$branch_name" == "main" || "$branch_name" == "master" ]]; then
        git push
    else
        git push origin "$branch_name"
    fi

    local status=$?
    if [[ $status -eq 0 ]]; then
        local dir
        dir="$(dirname "${BASH_SOURCE[0]}")"
        [[ -f "$dir/fah.mp3" ]] && paplay "$dir/fah.mp3" &>/dev/null &
        printf ":: Pushed successfully!\n"
    else
        printf "!! Sorry, push failed. Please check for errors.\n"
    fi
}

# fn for yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Function to capture the start time
preexec() {
    echo "$EPOCHSECONDS" > "/dev/shm/cmd_start_$$" 2>/dev/null
}
PS0='$(preexec)'

# Function to capture the end time and calculate elapsed time
precmd() {
    # Check if we are in transient prompt mode
    if [[ $prompt_ps1_transient != "always" ]]; then
        if [[ -f "/dev/shm/cmd_start_$$" ]]; then
            local command_start_time=$(< "/dev/shm/cmd_start_$$")
            rm -f "/dev/shm/cmd_start_$$" 2>/dev/null
            local command_end_time=$EPOCHSECONDS
            local elapsed_time=$((command_end_time - command_start_time))

            # Convert elapsed time to minutes and seconds
            local minutes=$((elapsed_time / 60))
            local seconds=$((elapsed_time % 60))

            # Only display elapsed time if it is greater than zero
            if [[ $elapsed_time -gt 0 ]]; then
                if [[ $minutes -gt 0 ]]; then
                    export elapsed_time_display=$(printf "\e[90m  %dm %ds\e[0m" $minutes $seconds)
                elif [[ $seconds -gt 3 ]]; then
                    export elapsed_time_display=$(printf "\e[90m  %ds\e[0m" $seconds)
                elif [[ $seconds -le 3 ]]; then
                    export elapsed_time_display=$(printf " \n")
                fi
            else
                export elapsed_time_display=""
            fi
        else
            export elapsed_time_display=""
        fi
    else
        # Clear the elapsed time display in transient mode
        export elapsed_time_display=""
    fi

}

# Function to capture the current time
current_time() {
    echo -ne "\e[90m $(date +'%I:%M %p')\e[0m"
}

ffstyle() {
    preferredDir="$HOME/.local/share/fastfetch/presets"

    if [[ ! -d "$preferredDir" ]]; then
        exit 0
    fi

    presets=()

    for preset in "$preferredDir"/*.jsonc; do
        [[ -f "$preset" ]] || continue  # Skip if no matching file
        presets+=("${preset##*/}")  # Extract filename
    done

    # Remove .jsonc extension from all entries
    presets=("${presets[@]%.jsonc}")

    echo "-> Choose Fastfetch style you want"

    local i=1
    for prst in "${presets[@]}"; do
        echo -e "$i. $prst"
        ((i++))
    done

    read -r -p "Select: " stl

    if [[ "$stl" -gt 0 && "$stl" -le "${#presets[@]}" ]]; then
        __selected="${presets[$((stl - 1))]}"
        echo "Setting $__selected as fastfetch style..."
        sed -i "s|ffconfig=.*$|ffconfig=$__selected|g" "$HOME/.bash/.bashrc"
    fi
    
}

ffimg() {
    local preferredDir="$HOME/.local/share/fastfetch/images"

    if [[ ! -d "$preferredDir" ]]; then
        echo "Image directory not found: $preferredDir"
        return 1
    fi

    [[ -n "$ffconfig" ]] || source "$HOME/.bashrc"

    if [[ "$ffconfig" != "minimal" ]]; then
        echo "minimal style is not selected."
        return 0
    fi

    local presets=()
    for preset in "$preferredDir"/*; do
        [[ -f "$preset" ]] || continue
        presets+=("$(basename "$preset")")
    done

    if [[ "${#presets[@]}" -eq 0 ]]; then
        echo "No images found in $preferredDir"
        return 1
    fi

    echo "-> Choose Fastfetch image you want:"
    local i=1
    for prst in "${presets[@]}"; do
        echo "$i. $prst"
        ((i++))
    done

    read -r -p "Select (1-${#presets[@]}): " stl

    if ! [[ "$stl" =~ ^[0-9]+$ ]]; then
        echo "Invalid input. Please enter a number."
        return 1
    fi

    if (( stl >= 1 && stl <= ${#presets[@]} )); then
        local __selected="${presets[$((stl - 1))]}"
        echo "Setting $__selected as fastfetch image..."

        # Escape for sed
        local escaped_path
        escaped_path=$(printf '%s\n' "$__selected" | sed 's/[\/&]/\\&/g')

        # Replace only the filename after fastfetch/images/ and preserve what comes after (like the trailing ",)
        sed -i -E "s|(fastfetch/images/)[^\"/]+|\1$escaped_path|" "$HOME/.local/share/fastfetch/presets/minimal.jsonc"
    else
        echo "Invalid selection."
        return 1
    fi
}

ss() {
    local aur
    aur=$(command -v yay 2>/dev/null || command -v paru 2>/dev/null)
    if [[ -n "$aur" ]]; then 
        "$aur" -Slq | fzf --multi --preview "$aur -Sii {1}" --preview-window=down:75% | xargs -ro "$aur" -S --noconfirm
    else
        local pkg
        pkg=$(command -v apt 2>/dev/null || command -v dnf 2>/dev/null || command -v zypper 2>/dev/null)
        if [[ -z "$1" ]]; then
            printf "Please add your package name.\nUsage: ss <package_name>\n"
            return 1
        fi
        if [[ -n "$pkg" ]]; then
            "$pkg" search "$1"
        else
            printf "!! Unsupported package manager.\n"
            return 1
        fi
    fi
}

play() {
    dir="$(dirname "${BASH_SOURCE[0]}")"
    paplay "$dir/fah.mp3"
}

# create vite app
vite() {

set -e

clear
printf "Project name: \n"
PROJ_NAME=$(gum input --placeholder "my-app")

[[ -z "$PROJ_NAME" ]] && { echo "❌ Missing project name"; exit 1; }

# Detect package manager
for pm in npm pnpm yarn bun; do
    if command -v "$pm" >/dev/null 2>&1; then
        PKG_MANAGER=$pm
        break
    fi
done

[[ -z "$PKG_MANAGER" ]] && { echo "❌ No package manager found"; exit 1; }

echo "🚀 Using $PKG_MANAGER"

# Create project (non-interactive)
case $PKG_MANAGER in
    npm)
        npm create vite@latest "$PROJ_NAME" -y -- --template react --no-interactive
        ;;
    pnpm)
        pnpm create vite "$PROJ_NAME" --template react --no-interactive
        ;;
    yarn)
        yarn create vite "$PROJ_NAME" --template react --no-interactive
        ;;
    bun)
        bun create vite "$PROJ_NAME" --template react --no-interactive
        ;;
esac

cd "$PROJ_NAME"

echo "📦 Installing dependencies..."
$PKG_MANAGER install

# Setup VS Code auto-run task
mkdir -p .vscode

cat > .vscode/tasks.json << 'EOF'
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "dev",
      "type": "shell",
      "command": "npm run dev",
      "isBackground": true,
      "runOptions": {
        "runOn": "folderOpen"
      },
      "problemMatcher": []
    }
  ]
}
EOF

echo "🧠 Opening in VS Code..."
command -v code >/dev/null && code .

echo "🌐 Dev server will auto-start inside VS Code terminal"
echo "✅ Done!" && sleep 1

exit 0

}
