export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.config/zsh/custom"
export EDITOR="nvim"

ZSH_THEME="awesomepanda"

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

alias nv="nvim"
alias ela="exa -l -a --icons"
alias tks="tmux kill-server"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# History
HISTFILE=$HOME/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt INC_APPEND_HISTORY

# Tmux 
tmux 2>/dev/null

# ssh shenanigans
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

source $ZSH/oh-my-zsh.sh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
