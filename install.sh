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
  local packages="git archlinux-keyring tmux zsh kitty discord ly neofetch polybar rofi i3-wm xorg-xinit xorg dotnet-runtime dotnet-sdk postman"

  echo -e "Installing ${orange}packages${nc}..."
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

  echo -e "Installing ${orange}yay${nc}..."
  cd $HOME && git clone "$yay_remote" 
  cd yay-bin && makepkg --noconfirm -si

  if [ $? -ne 0 ]; then
    fmt_error "yay installed unsuccesfully."
  else
    fmt_success "yay installed succesfully${nc}."
  fi

  rm --recursive --force -- yay-source
}


install_fonts() {
  local nerd_fonts_remote="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh"
  local nerd_fonts_user="Caskaydia Nerd Font Mono"

  curl -s $nerd_fonts_remote $nerd_fonts_user

  if [ $? -ne 0]; then
    fmt_error "Fonts installed unsuccesfully."
  else
    fmt_success "Fonts installed succesfully"
  fi
}


# setup ly tui manager
setup_ly() {
  echo -e "Enabling ${orange}ly${nc}..."
  sudo systemctl enable ly.service 

  if [ $? -ne 0 ]; then
    echo -e "ly enabled ${red}unsuccesfully${nc}"
  else
    echo -e "ly enabled ${green}succesfully${nc}"
  fi

  sudo systemctl start ly.service 
  sudo systemctl restart ly.service
}


install_zsh_autosuggestions() {
  local zsh_autosuggestions_remote="https://github.com/zsh-users/zsh-autosuggestions" 
  git clone "$zsh_autosuggestions_remote" "$HOME"/.zsh/zsh-autosuggestions

  if [ $? -ne 0 ]; then
    echo -e "zsh-autosuggestions installed ${red}unsuccesfully${nc}"
  else
    echo "# zsh-autosuggestions" >> "$HOME"/.zshrc
    echo "source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$HOME"/.zshrc
    echo -e "zsh-autosuggestions installed ${green}succesfully${nc}"
  fi
}

install_ohmyzsh() {
  local ohmyzsh_script="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
  sh -c "$(curl -fsSL "$ohmyzsh_script")" "" --keep-zshrc

  if [ $? -ne 0 ]; then
    echo -e "OhMyZsh installed ${red}unsuccesfully${nc}"
  else
    echo -e "OhMyZsh installed ${green}succesfully${nc}"
  fi
}


setup_shell() {
  local zsh="/usr/bin/zsh"

  echo -e "Changing shell to ${orange}zsh${nc}..."
  
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
    echo -e "chsh command run ${red}unsuccesfully${nc}. Change your shell manually"
  else
    export SHELL="$zsh"
    echo -e "Shell changed to zsh ${green}succesfully${nc}"
  fi
}


# Helper function as alias for clone_bare_repository
bare_config() {
  /usr/bin/git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME" $@ 
}

# Clones a bare repository from dotfiles_repo_url to $HOME/.dotfiles directory.
# Adds ".dotfiles" to $HOME/.gitignore. Makes a config-backup for pre-existing
# configuration files
clone_bare_repository() {
  local dotfiles_remote="https://github.com/qbibubi/.dotfiles.git"

  echo -e "Creating ${orange}.dotfiles${nc} bare repository in ${ORANGE}$HOME/.dotfiles${NC}..."
  git clone --bare $dotfiles_remote "$HOME"/.dotfiles

  # add alias for config to .zshrc
  echo "alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> "$HOME"/.zshrc

  # add .dotfiles to .gitignore to resolve recursive problems
  echo ".dotfiles" >> "$HOME"/.gitignore 
  cd "$HOME" && mkdir -p .config-backup

  bare_config checkout
  if [ $? -ne 0 ]; then
    echo -e "Backing up pre-existing .dotfiles..."
    bare_config checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
  else
    echo -e "Checked out config."
  fi;

  bare_config checkout
  bare_config config status.showUntrackedFiles no 
}


main() {
  while [ $# -gt 0 ]; do
    case $1 in
      --ohmyzsh) OHMYZSH=yes ;; 
    esac
    shift
  done

  install_packages
  install_yay
  install_fonts
  install_zsh_autosuggestions
  clone_bare_repository

  if [ OHMYZSH=yes ]; then
    install_ohmyzsh
  else
    setup_shell
  fi

  setup_ly 
}

main $@
