#!/bin/sh

# This script should be run via curl after fresh Arch Linux install for best compatiblity:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/qbibubi/.dotfiles/main/install.sh)"
# Other use cases were not taken into consideration. Use at your own risk.


# Variable values adopted from OhMyZsh install ohmyzsh
readonly FMT_RED=$(printf '\033[31m')
readonly FMT_GREEN=$(printf '\033[32m')
readonly FMT_YELLOW=$(printf '\033[33m')
readonly FMT_BLUE=$(printf '\033[34m')
readonly FMT_BOLD=$(printf '\033[1m')
readonly FMT_RESET=$(printf '\033[0m')



command_exists() {
  command -v "$@" >/dev/null 2>&1
}

user_can_sudo() {
  command_exists sudo || return 1
}

# Formatting functions 
fmt_working() {
  printf '%sWORKING ON: %s%s\n' "${FMT_BOLD}${FMT_YELLOW}" "$*" "${FMT_RESET}"
}

fmt_error() {
  printf '%sERORR: %s%s\n' "${FMT_BOLD}${FMT_RED}" "$*" "${FMT_RESET}" >&2
}

fmt_success() {
  printf '%sSUCCESS: %s%s\n' "${FMT_BOLD}${FMT_GREEN}" "$*" "${FMT_RESET}" >&2
}


# Upgrades pre-existing packages to ensure up to date database and mirrors.
# Install packages from $packages variable without confirmation (this results)
# in choosing of default configurations provided by the pacman package manager
install_packages() {
  local packages="git archlinux-keyring tmux zsh kitty discord ly neofetch polybar rofi i3-wm xorg-xinit xorg exa"

  fmt_working "Upgrading existing packages..."
  sudo pacman -Syu --noconfirm

  if [ $? -ne 0 ]; then
    fmt_error "Unable to upgrade packages"
  else
    fmt_success "Packages upgraded succesfully"
  fi

  fmt_working "Installing packages..."
  sudo pacman -S -q --noconfirm $packages   # double quotes break the script

  if [ $? -ne 0 ]; then
    fmt_error "Packages installed unsuccesfully"
  else
    fmt_success "Packages installed succesfully."
  fi
}


# Manually installs yay package manager from AUR repository. Removes yay-source
# after finished installation.
install_yay() {
  local yay_remote="https://aur.archlinux.org/yay-bin.git"

  fmt_working "Installing yay..."
  cd $HOME && git clone "$yay_remote" 
  cd yay-bin && makepkg --noconfirm -si

  if [ $? -ne 0 ]; then
    fmt_error "yay installed unsuccesfully."
  else
    fmt_success "yay installed succesfully${nc}."
  fi

  rm --recursive --force -- yay-source
}


# setup ly tui manager
setup_ly() {
  fmt_working "Enabling ly..."
  sudo systemctl enable ly.service 

  if [ $? -ne 0 ]; then
    fmt_error "ly enabled unsuccesfully"
  else
    fmt_success "ly enabled succesfully"
  fi

  sudo systemctl start ly.service 
  sudo systemctl restart ly.service
}


# Clones zsh plugin - zsh-autosuggestions into $HOME/.zsh/zsh-autosuggestions/ manually 
# from zsh_autosuggestions_remote and echoes required lines of code into $HOME/.zshrc
install_zsh_autosuggestions() {
  local zsh_autosuggestions_remote="https://github.com/zsh-users/zsh-autosuggestions" 

  fmt_working "Installing zsh-autosuggestions..."
  git clone "$zsh_autosuggestions_remote" "$HOME"/.zsh/zsh-autosuggestions

  if [ $? -ne 0 ]; then
    fmt_error "zsh-autosuggestions installed unsuccesfully"
  else
    echo "# zsh-autosuggestions" >> "$HOME"/.zshrc
    echo "source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$HOME"/.zshrc
    fmt_success "zsh-autosuggestions installed succesfully"
  fi
}


# Changes current shell to zsh. If current shell is zsh then do nothing.
# Export SHELL variable as zsh
setup_shell() {
  local zsh="/usr/bin/zsh"

  fmt_working "Changing shell to zsh..."
  
  # if shell is zsh already do not switch
  if [ "$(basename -- $SHELL)" = "zsh" ]; then
    return
  fi


  if user_can_sudo; then
    sudo -k chsh -s "$zsh" "$USER"
  else
    chsh -s "$zsh" "$USER"
  fi

  if [ $? -ne 0 ]; then 
    fmt_error "chsh command run unsuccesfully. Change your shell manually"
  else
    export SHELL="$zsh"
    fmt_success "Shell changed to zsh succesfully"
  fi
}


# Helper function alias for clone_bare_repository
bare_config() {
  /usr/bin/git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME" $@ 
}

# Clones bare repository from dotfiles_repo_url to $HOME/.dotfiles directory.
# Adds ".dotfiles" to $HOME/.gitignore. Makes a config-backup for pre-existing
# configuration files before checking out. Append bare_config config to not 
# show untracked files
setup_dotfiles() {
  local dotfiles_remote="https://github.com/qbibubi/.dotfiles.git"

  fmt_working "Creating .dotfiles bare repository in $HOME/.dotfiles..."
  git clone --bare $dotfiles_remote "$HOME"/.dotfiles

  # add alias for config to .zshrc
  echo "alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> "$HOME"/.zshrc

  # add .dotfiles to .gitignore to resolve recursive problems
  echo ".dotfiles" >> "$HOME"/.gitignore 

  cd "$HOME" && mkdir -p .config-backup

  bare_config checkout
  if [ $? -ne 0 ]; then
    fmt_working "Backing up pre-existing .dotfiles..."
    bare_config checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
  else
    fmt_success "Checked out config."
  fi;

  bare_config checkout
  bare_config config status.showUntrackedFiles no 
}


main() {
  install_packages
  install_yay
  install_zsh_autosuggestions

  setup_dotfiles
  setup_shell
  setup_ly 
}

main
