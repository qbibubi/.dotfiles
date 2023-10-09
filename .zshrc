export PATH=$HOME/.dotnet/tools:$HOME/bin:/usr/local/bin:$PATH
export EDITOR="nvim"
# export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8

# export ARCHFLAGS="-arch x86_64"
alias zshconfig="mate ~/.zshrc"
alias l="ls -lah"
alias nv="nvim"
alias nm="nmcli device wifi connect"
alias nmdc="nmcli con down"

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST

PROMPT='%F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '
DISABLE_AUTO_TITLE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="mm/dd/yyyy"

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
