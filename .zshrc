export PATH=$HOME/.dotnet/tools:$HOME/bin:/usr/local/bin:$PATH
export EDITOR="nvim"
export LANG=en_US.UTF-8
# export MANPATH="/usr/local/man:$MANPATH"
# export ARCHFLAGS="-arch x86_64"
export CXX_DEVELOP="-Wall -Wextra -Wfloat-equal -Wstrict-prototypes -Wmissing-prototypes -Wpointer-arith -Wcast-qual"
export CXX_RELEASE="-pedantic"


# Prompt
autoload -Uz vcs_info # enable vcs_info
precmd() { vcs_info } 
zstyle ':vcs_info:*' formats ' %s(%F{blue}%b%f)'
setopt PROMPT_SUBST

PROMPT='%n@%m %F{red}%/%f${vcs_info_msg_0_} $ '


alias zshconfig="mate ~/.zshrc"
alias l="exa --icons -la"
alias nv="nvim"
alias nm="nmcli device wifi connect"
alias nmdc="nmcli con down"

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

