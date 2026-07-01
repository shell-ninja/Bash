<h1 align='center'>My Personal Bash Customization</h1>

## Short Description

#### Those who don't want to install and configure any other shell like `zsh` or `fish`, want to stay in the default `bash`, and also want to make the experience of bash easier, can simply install this configuration. Just run the `install.sh` script to install necessary packages and this configuration.

<br>

## Here are some screenshots

### Styles

<p> <img align="center" width="99%" src="https://github.com/shell-ninja/Screen-Shots/blob/main/bash/ScreenShots/1.png?raw=true" /> </p>

<p> <img align="center" width="49%" src="https://github.com/shell-ninja/Screen-Shots/blob/main/bash/ScreenShots/2.png?raw=true" /> <img align="center" width="49%" src="https://github.com/shell-ninja/Screen-Shots/blob/main/bash/ScreenShots/3.png?raw=true" /></p>

<br>

### Features

<p>
<img align="center" width="99%" src="https://github.com/shell-ninja/Screen-Shots/blob/main/bash/ScreenShots/find.png?raw=true" />

<img align="center" width="49%" src="https://github.com/shell-ninja/Screen-Shots/blob/main/bash/ScreenShots/cd.png?raw=true" /> <img align="center" width="49%" src="https://github.com/shell-ninja/Screen-Shots/blob/main/bash/ScreenShots/fuck.png?raw=true" />

<img align="center" width="99%" src="https://github.com/shell-ninja/Screen-Shots/blob/main/bash/ScreenShots/syntax-highlighting.png?raw=true" />

</p>

## A short video

https://github.com/user-attachments/assets/319eeb90-b4d5-41a4-ab18-87389f7bbfcf

## Before Installation

Make sure you install any of the Nerd Fonts and set that font in your terminal so that the prompt looks nice. I suggest using the `JetBrains Mono Nerd Font`. Just visit [Here](https://nerdfonts.com) and download the font and install it using your Font Manager. Then set the font in your Terminal.

<br>

## Features

1. Shortcuts
2. Some functions for install, uninstall, check updates, update packages, and so on
3. Syntax Highlighting
4. Auto Suggestions
5. Fuzzy finder
6. Supports transient prompt like `zsh`
7. Tree view of directories, files, and subdirectories
8. Memorizing the directories
9. Command spell correction
10. Git branch name and left commits
11. Some cool looking themes
12. 8 selectable native `PS1` prompt layouts, plus Starship theme switching
13. Background command timing (auto-shows duration for long-running commands)

Why don't you give it a try?

<br>

## Installation

### Direct Installation

You can directly run the command below, and it will automatically clone the repository and install the config. Before that, make sure you have `curl` installed in your system. If not, simply install it using `pacman`, `dnf`, `zypper` or `apt`.

- Run this command in your terminal:

```bash
bash <(curl https://raw.githubusercontent.com/shell-ninja/Bash/main/direct_install.sh)
```

### Manual Installation

- Open terminal and run these commands.

```bash
git clone --depth=1 https://github.com/shell-ninja/Bash.git
cd Bash
chmod +x install.sh
./install.sh
```

## Edit alias & functions

Simply go to the `~/.bash` directory. Inside it, you will find `.bashrc`, `alias.sh`, and `functions.sh` files. Just edit these files, and you are good to go. Also, if you want to add your custom bash prompt, just go to `~/.bash/change_prompt.sh` file and add your prompt.

<br>

## Comprehensive Command Shortcuts & Functions

### 1) Directory Navigation and File Operations

| Command / Alias  | Target Command / Function   | Description                                                                                                                                                                                                         |
| :--------------- | :-------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `ls`             | `eza -T --level=1 ...`      | Lists files with `eza` at a tree depth of 1, with icons and color.                                                                                                                                                  |
| `la`             | `eza -a ...`                | Lists all files, including hidden files, using `eza`.                                                                                                                                                               |
| `ll`             | `eza -l -a ...`             | Detailed list view of all files, excluding timestamps.                                                                                                                                                              |
| `lst`            | `eza -T --level=2 ...`      | Tree view of directories with a depth of 2.                                                                                                                                                                         |
| `lsf`            | `eza -f -a ...`             | Fast list display of all files using `eza`.                                                                                                                                                                         |
| `lstd`           | `eza -D -T --level=2 ...`   | Tree view displaying directories only, up to a depth of 2.                                                                                                                                                          |
| `tree`           | `eza -T --level=3 ...`      | Comprehensive tree view of directories up to a depth of 3.                                                                                                                                                          |
| `cat`            | `bat --style header ...`    | Uses `bat` for `cat`, with styling and syntax highlighting.                                                                                                                                                         |
| `..`, `...`, `.` | `cd ..`, `cd ../..`, `cd /` | Quick shortcuts to move up directories or jump directly to root.                                                                                                                                                    |
| `rm` / `rmv`     | `fn_removal`                | Safely removes files and directories. Automatically detects whether the parent directory is writable and escalates to `sudo` only when needed; prints a warning if a target doesn't exist.                          |
| `cp` / `cpp`     | `fn_copy_paste`             | Smart copy function. Auto-detects when `sudo` is required, shows a live progress bar via `pv`, copies directories with `tar`, and safely flashes `.iso` files to disk using `dd` with a sync spinner on completion. |
| `find`           | `fzf` → `nvim`              | Interactively searches files via `fzf` with `bat` previews, then opens the selection directly in `nvim`.                                                                                                            |
| `y`              | `yazi` (function)           | Wrapper around the `yazi` file manager that automatically `cd`s your shell into the last directory you were viewing when you exit.                                                                                  |
| `exe`            | `chmod +x`                  | Makes a file executable.                                                                                                                                                                                            |

### 2) System Info & Terminal Management

| Command / Alias           | Target Command / Function                              | Description                                                                |
| :------------------------ | :----------------------------------------------------- | :------------------------------------------------------------------------- |
| `src`                     | `source ~/.bash/.bashrc`                               | Reloads the bash configuration.                                            |
| `clr`, `cls`, `clar`, `c` | `clear`                                                | Clears the terminal screen.                                                |
| `q`                       | `exit`                                                 | Exits the current terminal session.                                        |
| `du`                      | `du -sh`                                               | Shows total disk usage for directories.                                    |
| `mem`                     | `fn_resources __memory`                                | Parses `free -h` and cleanly prints Total, Used, and Free system RAM.      |
| `disk`                    | `fn_resources __disk`                                  | Parses `df -h /` and cleanly prints Total, Used, and Free root disk space. |
| `nc`, `neofetch`          | `clr && neofetch`                                      | Clears the terminal and runs `neofetch`.                                   |
| `ff`                      | `clr && fastfetch`                                     | Clears the terminal and runs `fastfetch`.                                  |
| `sys`                     | `btop`                                                 | Opens the `btop` system monitor.                                           |
| `clock`                   | `tty-clock -c -t -D -s`                                | Opens a terminal-based digital clock.                                      |
| `mat`                     | `cmatrix`                                              | Opens a matrix terminal animation.                                         |
| `grubup`                  | `sudo update-grub`                                     | Updates GRUB on Arch and Ubuntu systems.                                   |
| `susegrub`                | `sudo grub2-mkconfig -o /boot/grub2/grub.cfg`          | Updates GRUB on openSUSE systems.                                          |
| `fedbup`                  | `sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg` | Updates GRUB on Fedora systems.                                            |
| `sddt`                    | `sddm-greeter-qt6 --test-mode --theme`                 | Tests the current SDDM greeter theme.                                      |

### 3) Agnostic Package Management

_These commands intelligently detect your active package manager (`pacman`/`yay`/`paru`, `dnf`, `zypper`, or `apt`) via `_detect_pkg_manager` and execute the correct system command automatically._

| Command / Alias | Target Command / Function | Description                                                                                                                                                                                                               |
| :-------------- | :------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `cu`            | `fn_check_updates`        | Checks for available software updates. On Arch it counts both official repo updates (via `checkupdates` or `pacman -Qu`) and AUR updates (via `yay`/`paru`) separately.                                                   |
| `update`        | `fn_update`               | Fully updates all system packages using the detected package manager (`-Syyu`, `dnf upgrade`, `zypper up`, or `apt upgrade`).                                                                                             |
| `install [pkg]` | `fn_install`              | Installs the specified packages without user interaction.                                                                                                                                                                 |
| `remove [pkg]`  | `fn_uninstall`            | Uninstalls the specified packages and their dependencies.                                                                                                                                                                 |
| `dup`           | `sudo zypper dup -y`      | Specific command for openSUSE distribution upgrades.                                                                                                                                                                      |
| `ss [pkg]`      | `ss` (function)           | Interactive package search. On Arch, lists all AUR-helper packages through `fzf` with a live `-Sii` info preview for multi-select install. On other distros, performs a plain `search` with the detected package manager. |

### 4) Git Integrations

| Command / Alias | Target Command / Function | Description                                                                                                                                                                                                                                                           |
| :-------------- | :------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `add`           | `git add .`               | Stages all current changes.                                                                                                                                                                                                                                           |
| `clone`         | `git clone`               | Clones a repository.                                                                                                                                                                                                                                                  |
| `cloned`        | `git clone --depth=1`     | Clones a repository with a shallow depth of 1 to save space.                                                                                                                                                                                                          |
| `branch`        | `git branch -M main`      | Renames the current branch to `main`.                                                                                                                                                                                                                                 |
| `commit`        | `git commit -m`           | Commits changes with a specified inline message.                                                                                                                                                                                                                      |
| `pushm`         | `git push -u origin main` | Pushes changes and sets the upstream to `origin main`.                                                                                                                                                                                                                |
| `pusho`         | `git push origin`         | Pushes to the configured origin.                                                                                                                                                                                                                                      |
| `pull`          | `git pull`                | Pulls the latest changes from the remote tracking branch.                                                                                                                                                                                                             |
| `info`          | `git_info`                | Prints the current branch name plus color-coded counts of untracked (`?`), staged, and unstaged files — shown as a green checkmark when the tree is clean.                                                                                                            |
| `push`          | `push` (function)         | Full git workflow tool: reports untracked/unstaged/staged file counts, prompts for a commit message interactively (using `gum` if available, otherwise a plain `read`), then runs `add` → `commit` → `push origin <branch>`, and plays a success sound on completion. |

### 5) Development & Theming

| Command / Alias  | Target Command / Function    | Description                                                                                                                                                                                                                                                                                                                   |
| :--------------- | :--------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `nvm`, `open`    | `nvim .`                     | Opens NeoVim in the current directory.                                                                                                                                                                                                                                                                                        |
| `snv`            | `sudo -E nvim -d`            | Opens NeoVim in diff mode while preserving your user environment variables under `sudo`.                                                                                                                                                                                                                                      |
| `ag`             | `antigravity .`              | Opens Antigravity in the current directory.                                                                                                                                                                                                                                                                                   |
| `nrd`            | `npm run dev`                | Instantly spins up your local Node dev environment.                                                                                                                                                                                                                                                                           |
| `vite`           | `vite` (function)            | Interactive React + Vite project generator. Prompts for a project name (via `gum` or `read`), auto-detects your package manager (`npm`/`pnpm`/`yarn`/`bun`), scaffolds the project, installs dependencies, writes a `.vscode/tasks.json` that auto-runs `npm run dev` in the background on folder open, and launches VS Code. |
| `fn_compile_cpp` | `fn_compile_cpp <file> [-o]` | Safely compiles `<file>.cpp` with the C++20 standard after checking that `g++` is installed and the source file exists. Pass `-o` as a second argument to run the compiled binary immediately after a successful build.                                                                                                       |
| `prompt`         | `change_prompt.sh`           | Opens an interactive menu to switch between 8 custom native `PS1` bash prompt layouts (Classic Minimal, Inline Path, Classic 2-Line, Detailed 2-Line, Bracket Layout, Flow, Aesthetic Neon, Crystal Block). Applying a style disables Starship and reloads the shell instantly.                                               |
| `style`          | `change_style.sh`            | Opens an interactive menu listing every `.toml` profile found in `~/.bash/starship`, then dynamically sets `STARSHIP_CONFIG` to the chosen theme, re-enables Starship if it was disabled, and reloads the shell.                                                                                                              |
| `ffstyle`        | `ffstyle` (function)         | Interactively lists all `fastfetch` `.jsonc` presets from `~/.local/share/fastfetch/presets`, and writes the chosen preset name into the `ffconfig` variable in `.bashrc`.                                                                                                                                                    |
| `ffimg`          | `ffimg` (function)           | Interactively lists images from `~/.local/share/fastfetch/images` and swaps the display image referenced inside the `minimal.jsonc` fastfetch preset (only active when the `minimal` fastfetch style is selected).                                                                                                            |

_Additional Engine Features: Your configuration inherently includes background command timing, calculated via a `DEBUG` trap (`_command_start_time`) and the `_precmd` `PROMPT_COMMAND` hook, which automatically displays the elapsed time (in seconds or minutes) for any command that runs longer than 3 seconds. A `current_time` helper is also available for embedding the current time inside a custom prompt, and a standalone `play` function plays a configured success sound (`fah.mp3`) using whichever of `pw-play`, `paplay`, `aplay`, or `ffplay` is available._
