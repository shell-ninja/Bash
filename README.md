<h1 align='center'>My personl Bash Customization</h1>

## Short Description

#### Those who don't want to install and configure any other shell like the `zsh` or the `fish` shell, want to stay in the default `bash`, also want to make the experience of the bash more easy, can easily install this configuration. Just simply run the `install.sh` script. It will install some necessary packages and a github repo. And then you can enjoy the configuration.

<br>

## Here are some screenshos

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

Make sure you install any of the nerd font's and set that font in your terminal, so that the prompt look nice. I suggest to use the `JetBrains Mono Nerd Font`. Just visit [Here](https://nerdfonts.com) and download the font and install it using your Font Manager. Then set the font in your Terminal.
<br>

## Features

1. Shortcuts <br>
2. Some functions for install, uninstall, check updates, update packages and so on <br>
3. Syntax Highlighting <br>
4. Auto Suggestions <br>
5. Fuzzy finder <br>
6. Supports transient prompt like 'zsh'
7. Tree view of directories, files and sub directories <br>
8. Memorizing the directories <br>
9. Command spell correction <br>
10. Git branch name and left commits <br>
11. Some cool looking themes <br>

Why don't you give it a try?

<br>

## Installation

### Direct Installation

You can directly run the command bellow and it will automaticly clone the repository and install the config. Before that make sure you have `curl` installed in your system. If not, simply install it using `pacman`, `dnf`, `zypper` or `apt`.

- Run this command in your terminal:

```
bash <(curl https://raw.githubusercontent.com/shell-ninja/Bash/main/direct_install.sh)
```

### Manual Installation

- Open terminal and run these commands.

```
git clone --depth=1 https://github.com/shell-ninja/Bash.git

cd Bash
chmod +x install.sh
./install.sh
```

## Edit alias & functions

Simply go to `~/.bash` directory. Inside it, you will find `.bashrc`, `alias` and `function` file. Just edit these files and you are good to go. Also if you want to add your custom bash prompt, just go to `~/.bash/change_prompt.sh` file and add your prompt.

<br>

## Command Shortcuts

### 1) Directory Navigation and File Management

| Shortcut | Command         | Description                                                                  |
| -------- | --------------- | ---------------------------------------------------------------------------- |
| `cd`     | `cd`            | Change directory. If the directory does not exist, it will ask to create it. |
| `file`   | `touch`         | Create a file.                                                               |
| `rm`     | `rm -rf`        | Remove both files and directories.                                           |
| `cp`     | `cp` or `cp -r` | Remove both files and directories.                                           |
| `srm`    | `sudo rm -rf`   | Remove both files and directories with the sudo command                      |

### 2) Updated, Install & Uninstall Related

| Shortcut  | Command                                                                               | Description                                                                                              |
| --------- | ------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| `cu`      | `paru/yay -Qua / checkupdates`, `sudo dnf check-update` or `sudo zypper list-updates` | Checks system updates (Arch, Fedora, OpenSuse. Also prints both Official and Aur updates in Arch Linux). |
| `update`  | `paru/yay -Syyu`, `sudo dnf upgrade`, `sudo zypper update`, or `sudo apt-get update`  | Updates the system packages (Arch, Fedora, OpenSuse, Debian/Ubuntu).                                     |
| `install` | `paru/yay -S`, `sudo dnf install`, `zypper install`, or `apt-get install`             | Install package (Arch, Fedora, OpenSuse, Debian/Ubuntu).                                                 |
| `remove`  | `paru/yay -Rns`, `sduo dnf remove`, `sudo zypper remove`, or `sudo apt-get remove`    | Uninstall package (Arch, Fedora, OpenSuse, Debian/Ubuntu).                                               |

### 3) Git Related

| Shortcut | Command                    | Description                            |
| -------- | -------------------------- | -------------------------------------- |
| `add`    | `git add .`                | Add.                                   |
| `clone`  | `git clone`                | Clone a repository.                    |
| `cloned` | `git clone --depth=1`      | Clone a repository with depth 1.       |
| `commit` | `git commit -m`            | Commit with a message.                 |
| `push`   | `git push`                 | Push changes to the remote repository. |
| `pushm`  | `git push -u origin main`  | Push changes and set upstream to main. |
| `pusho`  | `git push origin [branch]` | Push to a specified branch.            |
| `pull`   | `git pull origin [branch]` | Pull from a specified branch.          |
| `info`   | `git info`                 | Git Information.                       |

### 4) Changing Style

| Shortcut | Command                         | Description                                         |
| -------- | ------------------------------- | --------------------------------------------------- |
| `style`  | `bash ~/.bash/change_prompt.sh` | Execute a script that changes the style of the bash |

this is for a testing tutorial.
