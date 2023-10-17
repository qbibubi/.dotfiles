#!/bin/sh

# This script should be run via curl after fresh Arch Linux install 
# for the best compatibility. Other use cases were not taken into 
# consideration. Use at your own risk.


# Variable values adopted from OhMyZsh install ohmyzsh
readonly FMT_RED=$(printf '\033[31m')
readonly FMT_GREEN=$(printf '\033[32m')
readonly FMT_YELLOW=$(printf '\033[33m')
readonly FMT_BLUE=$(printf '\033[34m')
readonly FMT_BOLD=$(printf '\033[1m')
readonly FMT_RESET=$(printf '\033[0m')

# Options
OHMYZSH=${OHMYZSH:-no}
LY=${LY:-no}


command_exists() {
  command -v "$@" >/dev/null 2>&1
}

user_can_sudo() {
  command_exists sudo || return 1
}

fmt_working() {
  printf '%sWORKING ON: %s%s\n' "${FMT_BOLD}${FMT_YELLOW}" "$*" "${FMT_RESET}"
}

fmt_error() {
  printf '%sERORR: %s%s\n' "${FMT_BOLD}${FMT_RED}" "$*" "${FMT_RESET}" >&2
}

fmt_success() {
  printf '%sSUCCESS: %s%s\n' "${FMT_BOLD}${FMT_GREEN}" "$*" "${FMT_RESET}" >&2
}

# Installs packages listed in $packages
install_packages() {
  local packages="git archlinux-keyring tmux zsh kitty discord ly neofetch polybar rofi i3-wm xorg-xinit xorg"

  fmt_working "Installing packages..."
  sudo pacman -Syu --noconfirm
  sudo pacman -S -q --noconfirm $packages   # double quotes break the script

  if [ $? -ne 0 ]; then
    fmt_error "Packages installed unsuccesfully"
  else
    fmt_success "Packages installed succesfully."
  fi
}


# Installs yay package manager
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


# Installs nerd fonts chosen by user from nerd-fonts git repository
install_fonts() {
  local nerd_fonts_remote="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh"
  local nerd_fonts_user="Caskaydia Nerd Font Mono"

  fmt_working "Installing fonts..."
  curl -s "$nerd_fonts_remote" "$nerd_fonts_user"

  if [ $? -ne 0 ]; then
    fmt_error "Fonts installed unsuccesfully."
  else
    fmt_success "Fonts installed succesfully"
  fi
}


# setup ly tui manager
setup_ly() {
  fmt_working "Enabling ly..."
  sudo systemctl enable ly.service 

  if [ $? -ne 0 ]; then
    fmt_error "ly enabled unsuccesfully"
  else
    fmt_success "ly enabled succesfully"
    sudo systemctl start ly.service 
    sudo systemctl restart ly.service
  fi
}


# Install zsh zsh-autosuggestions plugin into $HOME/.zsh/zsh-autosuggestions/
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


setup_ohmyzsh() {
  local ohmyzsh_script="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

  fmt_working "Installing OhMyZsh..."
  sh -c "$(curl -fsSL "$ohmyzsh_script")" "" --keep-zshrc --skip-chsh

  if [ $? -ne 0 ]; then
    fmt_error "OhMyZsh installed unsuccesfully"
  else
    fmt_success "OhMyZsh installed succesfully"
  fi
}


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


# Helper function as alias for clone_bare_repository
bare_config() {
  /usr/bin/git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME" $@ 
}

# Clones a bare repository from dotfiles_repo_url to $HOME/.dotfiles directory.
# Adds ".dotfiles" to $HOME/.gitignore. Makes a config-backup for pre-existing
# configuration files
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
  while [ $# -gt 0 ]; do
    case $1 in
      --ohmyzsh) OHMYZSH=yes ;; 
      --ly) LY=yes ;;
    esac
    shift
  done

  install_packages
  install_yay
  #install_fonts

  setup_dotfiles

  if [ OHMYZSH=yes ]; then
    setup_ohmyzsh 
  else
    install_zsh_autosuggestions
  fi
  
  setup_shell

  if [ LY=yes ]; then
    setup_ly 
  fi
}

main "$@"
