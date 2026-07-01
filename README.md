<h1 align='center'>My Personal Bash Customization</h1>

## Short Description

#### Those who don't want to install and configure any other shell like `zsh` or `fish`, want to stay in the default `bash`, and also want to make the experience of bash easier, can simply install this configuration. Just run the `install.sh` script to install necessary packages and this configuration.[cite: 6]

<br>

## Here are some screenshots

### Styles

<p> <img align="center" width="99%" src="https://github.com/shell-ninja/Screen-Shots/blob/main/bash/ScreenShots/1.png?raw=true" /> </p>[cite: 6]

<p> <img align="center" width="49%" src="https://github.com/shell-ninja/Screen-Shots/blob/main/bash/ScreenShots/2.png?raw=true" /> <img align="center" width="49%" src="https://github.com/shell-ninja/Screen-Shots/blob/main/bash/ScreenShots/3.png?raw=true" /></p>[cite: 6]

<br>

### Features

<p>
<img align="center" width="99%" src="https://github.com/shell-ninja/Screen-Shots/blob/main/bash/ScreenShots/find.png?raw=true" />[cite: 6]

<img align="center" width="49%" src="https://github.com/shell-ninja/Screen-Shots/blob/main/bash/ScreenShots/cd.png?raw=true" /> <img align="center" width="49%" src="https://github.com/shell-ninja/Screen-Shots/blob/main/bash/ScreenShots/fuck.png?raw=true" />[cite: 6]

<img align="center" width="99%" src="https://github.com/shell-ninja/Screen-Shots/blob/main/bash/ScreenShots/syntax-highlighting.png?raw=true" />[cite: 6]

</p>

## A short video

https://github.com/user-attachments/assets/319eeb90-b4d5-41a4-ab18-87389f7bbfcf[cite: 6]

## Before Installation

Make sure you install any of the Nerd Fonts and set that font in your terminal so that the prompt looks nice. I suggest using the `JetBrains Mono Nerd Font`. Just visit [Here](https://nerdfonts.com) and download the font and install it using your Font Manager. Then set the font in your Terminal.[cite: 6]

<br>

## Features

1. Shortcuts[cite: 6]
2. Some functions for install, uninstall, check updates, update packages, and so on[cite: 6]
3. Syntax Highlighting[cite: 6]
4. Auto Suggestions[cite: 6]
5. Fuzzy finder[cite: 6]
6. Supports transient prompt like `zsh`[cite: 6]
7. Tree view of directories, files, and subdirectories[cite: 6]
8. Memorizing the directories[cite: 6]
9. Command spell correction[cite: 6]
10. Git branch name and left commits[cite: 6]
11. Some cool looking themes[cite: 6]

Why don't you give it a try?[cite: 6]

<br>

## Installation

### Direct Installation

You can directly run the command below, and it will automatically clone the repository and install the config. Before that, make sure you have `curl` installed in your system. If not, simply install it using `pacman`, `dnf`, `zypper` or `apt`.[cite: 6]

- Run this command in your terminal:

````bash
bash <(curl [https://raw.githubusercontent.com/shell-ninja/Bash/main/direct_install.sh](https://raw.githubusercontent.com/shell-ninja/Bash/main/direct_install.sh))
```[cite: 6]

### Manual Installation

- Open terminal and run these commands.[cite: 6]

```bash
git clone --depth=1 [https://github.com/shell-ninja/Bash.git](https://github.com/shell-ninja/Bash.git)
cd Bash
chmod +x install.sh
./install.sh
```[cite: 6]

## Edit alias & functions

Simply go to the `~/.bash` directory. Inside it, you will find `.bashrc`, `alias.sh`, and `functions.sh` files. Just edit these files, and you are good to go. Also, if you want to add your custom bash prompt, just go to `~/.bash/change_prompt.sh` file and add your prompt.[cite: 6]

<br>

## Comprehensive Command Shortcuts & Functions

### 1) Directory Navigation and File Operations

| Command / Alias | Target Command / Function | Description |
| :--- | :--- | :--- |
| `ls` | `eza -T --level=1 ...` | Uses `eza` to list files with a depth of 1, showing icons and coloring.[cite: 1] |
| `la` | `eza -a ...` | Lists all files including hidden files using `eza`.[cite: 1] |
| `ll` | `eza -l -a ...` | Detailed list view of all files excluding timestamps.[cite: 1] |
| `lst` | `eza -T --level=2 ...` | Tree view of directories with a depth of 2.[cite: 1] |
| `lsf` | `eza -f -a ...` | Fast list display of all files using `eza`.[cite: 1] |
| `lstd` | `eza -D -T --level=2 ...` | Tree view displaying directories only up to a depth of 2.[cite: 1] |
| `tree` | `eza -T --level=3 ...` | Comprehensive tree view of directories up to a depth of 3.[cite: 1] |
| `cat` | `bat --style header ...` | Uses `bat` for `cat` with styling and syntax highlighting.[cite: 1] |
| `..`, `...`, `.` | `cd ..`, `cd ../..`, `cd /` | Quick shortcuts to move up directories or directly to root.[cite: 1] |
| `rm`, `rmv` | `fn_removal` | Safely removes files and directories, automatically escalating to `sudo` if the directory is not writable.[cite: 1, 2, 5] |
| `srm` | `sudo rm -rf` | Forcefully removes files using `sudo`.[cite: 2] |
| `cp`, `cpp` | `fn_copy_paste` | Smart copy function that natively detects `sudo` needs, displays progress using `pv`, and safely flashes `.iso` files to disk using `dd`.[cite: 1, 2, 5] |
| `find` | `fzf` -> `nvim` | Interactively searches files via `fzf` with `bat` previews, opening the selection in `nvim`.[cite: 1] |
| `y` | `yazi` (function) | Wrapper for `yazi` file manager that automatically `cd`s into your last viewed directory when you exit.[cite: 5] |
| `exe` | `chmod +x` | Makes a file executable.[cite: 1] |

### 2) System Info & Terminal Management

| Command / Alias | Target Command / Function | Description |
| :--- | :--- | :--- |
| `src` | `source ~/.bash/.bashrc` | Reloads the bash configuration.[cite: 1] |
| `clr`, `cls`, `clar`, `c` | `clear` | Clears the terminal screen.[cite: 1] |
| `q` | `exit` | Exits the current terminal session.[cite: 1] |
| `du` | `du -sh` | Shows total disk usage for directories.[cite: 1] |
| `mem` | `fn_resources __memory` | Parses and cleanly prints Total, Used, and Free system RAM.[cite: 1, 5] |
| `disk` | `fn_resources __disk` | Parses and cleanly prints Total, Used, and Free Root disk space.[cite: 1, 5] |
| `nc`, `neofetch` | `clr && neofetch` | Clears the terminal and runs `neofetch`.[cite: 1] |
| `ff` | `clr && fastfetch` | Clears the terminal and runs `fastfetch`.[cite: 1] |
| `sys` | `btop` | Opens the `btop` system monitor.[cite: 1] |
| `clock` | `tty-clock -c -t -D -s` | Opens a terminal-based digital clock.[cite: 1] |
| `mat` | `cmatrix` | Opens a matrix terminal animation.[cite: 1] |
| `grubup` | `sudo update-grub` | Updates GRUB on Arch and Ubuntu systems.[cite: 1] |
| `susegrub` | `sudo grub2-mkconfig ...` | Updates GRUB on openSUSE systems.[cite: 1] |
| `fedbup` | `sudo grub2-mkconfig ...` | Updates GRUB on Fedora systems.[cite: 1] |
| `sddt` | `sddm-greeter-qt6 ...` | Tests the current SDDM greeter theme.[cite: 1] |

### 3) Agnostic Package Management

*These commands intelligently detect your active package manager (`pacman`/`yay`/`paru`, `dnf`, `zypper`, or `apt`) and execute the correct system command automatically.*[cite: 5]

| Command / Alias | Target Command / Function | Description |
| :--- | :--- | :--- |
| `cu` | `fn_check_updates` | Checks for available software updates (including the AUR on Arch Linux).[cite: 1, 5] |
| `update` | `fn_update` | Fully updates all system packages using the detected package manager.[cite: 1, 5] |
| `install [pkg]` | `fn_install` | Installs specified packages without user interaction.[cite: 1, 5] |
| `remove [pkg]` | `fn_uninstall` | Uninstalls specified packages and their dependencies.[cite: 1, 5] |
| `dup` | `sudo zypper dup -y` | Specific command for openSUSE system distribution upgrades.[cite: 1] |
| `ss [pkg]` | `ss` (function) | Interactive package search and installer. Utilizes `fzf` for Arch users.[cite: 5] |

### 4) Git Integrations

| Command / Alias | Target Command / Function | Description |
| :--- | :--- | :--- |
| `add` | `git add .` | Stages all current changes.[cite: 1] |
| `clone` | `git clone` | Clones a repository.[cite: 1] |
| `cloned` | `git clone --depth=1` | Clones a repository with a shallow depth of 1 to save space.[cite: 1] |
| `branch` | `git branch -M main` | Renames the current branch to `main`.[cite: 1] |
| `commit` | `git commit -m` | Commits changes with a specified inline message.[cite: 1] |
| `pushm` | `git push -u origin main` | Pushes changes and sets the upstream to origin main.[cite: 1] |
| `pusho` | `git push origin` | Pushes to the configured origin.[cite: 1] |
| `pull` | `git pull` | Pulls the latest changes from the remote tracking branch.[cite: 1] |
| `info` | `git_info` | Retrieves and formats current branch name and calculates exact staged, unstaged, and untracked file counts.[cite: 1, 5] |
| `push` | `push` (function) | Comprehensive git tool: detects file statuses, prompts for a commit message interactively (using `gum` if available), adds, commits, pushes, and plays a success sound file automatically.[cite: 5] |

### 5) Development & Theming

| Command / Alias | Target Command / Function | Description |
| :--- | :--- | :--- |
| `nvm`, `open` | `nvim .` | Opens NeoVim in the current directory.[cite: 1] |
| `snv` | `sudo -E nvim -d` | Opens NeoVim preserving user environment variables while elevating to `sudo`.[cite: 1] |
| `ag` | `antigravity .` | Opens antigravity in the current directory.[cite: 2] |
| `nrd` | `npm run dev` | Instantly spins up your local Node dev environment.[cite: 1] |
| `vite` | `vite` (function) | Interactive React Vite project generator. Auto-detects package managers (`npm`/`yarn`/`pnpm`/`bun`), sets up `.vscode/tasks.json` for background server execution, and launches VS Code.[cite: 5] |
| `fn_compile_cpp`| `fn_compile_cpp [file]` | Safely compiles `.cpp` scripts using C++20 standard, checking for `g++` installations, and executing upon successful compilation.[cite: 5] |
| `prompt` | `change_prompt.sh` | Opens an interactive menu to switch between 8 custom native PS1 bash prompt layouts.[cite: 1, 3] |
| `style` | `change_style.sh` | Opens an interactive menu to select and apply available Starship `.toml` profiles dynamically.[cite: 1, 4] |
| `ffstyle` | `ffstyle` (function) | Interactively parses and applies a `fastfetch` jsonc config preset directly into `.bashrc`.[cite: 5] |
| `ffimg` | `ffimg` (function) | Interactively swaps the display image inside your configured fastfetch preset.[cite: 5] |

*Additional Engine Features: Your configuration inherently includes background command timing calculation mapped to the `_precmd` bash prompt hook which automatically tracks the duration of long-running operations!*[cite: 5]
````
