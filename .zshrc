export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.config/zsh/custom"
export CFG="$HOME/.config"
export EDITOR="nvim"
export PHYSBOX="$HOME/dev/cpp/physbox/"

ZSH_THEME="gruvbox-dark"

# Plugins
plugins=(
  adb
  ag
  aliases
  alias-finder
  ansible
  archlinux
  asdf
  autojump
  fzf
  git
  ripgrep
  tig
  zsh-autosuggestions
  z
)

# Aliases
alias nv="nvim"
alias phys="cd $PHYSBOX"
alias ela="exa -l -a --icons"
alias tks="tmux kill-server"
alias i3conf="$EDITOR $CFG/i3/config"
alias kittyconf="$EDITOR $CFG/kitty/kitty.conf"
alias nvconf="$EDITOR $CFG/nvim"
alias zshconf="$EDITOR $HOME/.zshrc"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# Prompt
parse_git_branch() {
  inside_git_repo="$(git rev-parse --is-inside-worgit_parse-tree 2>/dev/null)"
  
  if [ "$inside_git_repo" ]; then
    echo "%F{8}[%F{1}$(basename `git rev-parse --show-toplevel`)%F{8}/{4}$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.%\)/\1/')%F{8}]%f "
  fi
}

setopt prompt_subst
autoload -U colors && colors
export PROMP=' %F{8}[%F{4}%n%F{9}@%F{6}%M%F{8}]%f $(parse_git_branch)%F{3}%1~%f $ '

# History
HISTFILE=$HOME/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt INC_APPEND_HISTORY

# Tmux 
tmux 2>/dev/null

source $ZSH/oh-my-zsh.sh

neofetch
