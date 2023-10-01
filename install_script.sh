#! /usr/bin/sh

# This script should be run after finishing Arch Linux installation for the best compatibility.
# Other use cases were not taken into consideration. Use at your own risk.
#
# Script is not fully working/finished as of now

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' #no color 

packages="git tmux zsh kitty discord firefox-developer-edition i3-wm ly neofetch polybar rofi"
git_repo_url="https://github.com/qbibubi/.dotfiles.git"
git_repo_ssh="git@github.com:q bibubi/.dotfiles.git"
yay_repo_url="https://aur.archlinux.org/yay-git.git"
hostname="qbi"
user="qbi"


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
  cd /opt && git clone $yay_repo_url ./yay-git 
  sudo chown -R $hostname:$user ./yay-git
  cd yay-git && makepkg -si
  echo -e "${GREEN}yay${NC} succesfully installed"
}


# Changes shell to zsh
change_shell()
{
  echo -e "Changing shell to ${RED}zsh${NC}"
  if [ $(command -v zsh) ]; then
    chsh -s /usr/bin/zsh
    echo -e "Shell ${GREEN}succesfully${NC} changed."
  fi
}


# Clones a bare repository from $git_repo_url to $HOME directory.
# Adds ".dotfiles" to $HOME/.gitignore
clone_bare_repository()
{
  echo -e "Creating ${RED}.dotfiles${NC} bare repository in ${RED}$HOME/.dotfiles${NC}..."
  echo "alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc
  echo ".dotfiles" >> $HOME/.gitignore 
  git clone --bare $git_repo_url $HOME/.dotfiles

  alias config="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

  if [ $(config checkout 2>&1 | awk {'print $1'}) = "error" ]; then
    mkdir -p .config-backup && config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
  fi

}

install_packages 2 y
install_yay 
change_shell 
clone_bare_repository
