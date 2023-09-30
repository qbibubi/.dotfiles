#!/bin/sh

# This script should be run after `archinstall`
# with i3-wm and Arch Linux for the best compatibility.

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' #no color 

packages="git tmux zsh kitty discord firefox-developer-edition ly nvim visual-studio-code-bin ssh-keygen neofetch polybar rofi clight"
git_repo_url="https://github.com/qbibubi/.dotfiles.git"
git_repo_ssh="git@github.com:qbibubi/.dotfiles.git"


# Installs packages listed in $packages
install_packages()
{
  echo -e "Installing ${RED}packages...${NC}"
  sudo pacman -S $packages
  if [ $(sudo pacman -S $packages) ]; then
    echo -e "${GREEN}Packages succesfully installed.${NC}"
  else
    echo -e "${RED}Packages installed unsuccesfully.${NC}"
  fi
}


# Installs yay package manager
install_yay()
{
  echo -e "Installing ${RED}yay${NC}..."
  cd /opt && git clone https://aur.archlinux.org/yay-git.git 
  sudo chown -R qbi:qbi ./yay-git
  cd yay-git && makepkg -si
  echo -e "${GREEN}yay${NC} succesfully installed"
}


create_bare_repository()
{
  echo -e "Creating ${GREEN}.dotfiles${NC} bare repository in ${GREEN}$HOME/.dotfiles${NC}..."
  echo "alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc
  echo ".dotfiles" >> $HOME/.gitignore 
  git clone --bare $git_repo_url $HOME/.dotfiles

  alias config="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
  config checkout

  # if error backup to a folder
  if [ $(config checkout 2>&1 | awk {'print $1'}) -e "error" ]; then
    mkdir -p .config-backup && config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
  fi

}

install_packages
install_yay

# Change shell to zsh
if [ $(command -v zsh) ]; then
  chsh -s /usr/bin/zsh 
  cd $HOME && touch .zhsrc
fi

create_bare_repository
