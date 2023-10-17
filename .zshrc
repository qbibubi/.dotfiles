export PATH=$HOME/.dotnet/tools:$HOME/bin:/usr/local/bin:$PATH
export EDITOR="nvim"
export LANG=en_US.UTF-8
# export MANPATH="/usr/local/man:$MANPATH"
# export ARCHFLAGS="-arch x86_64"

alias zshconfig="mate ~/.zshrc"
alias l="ls -lah"
alias nv="nvim"
alias nm="nmcli device wifi connect"
alias nmdc="nmcli con down"

DISABLE_AUTO_TITLE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="mm/dd/yyyy"

if [ command -v "oh-my-zsh" >/dev/null 2>&1 ]; then
  export ZSH="$HOME/.oh-my-zsh"
fi


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# TMUX
tmux 2>/dev/null

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# SSH-AGENT
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

# dotfiles setup
alias config='/usr/bin/git --git-dir=/home/qbi/.dotfiles/ --work-tree=/home/qbi'


# zsh-autosuggestions
source "$HOME"/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh


# oh-my-zsh
ZSH_THEME="edvardm"
source $ZSH/oh-my-zsh.sh
