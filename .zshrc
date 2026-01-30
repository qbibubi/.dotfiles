export EDITOR=nvim
export LANG=en_US.UTF-8

#
# SSH editor
#
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="nvim"
fi

autoload -Uz vcs_info # enable vcs_info
precmd() { vcs_info } 
zstyle ':vcs_info:*' formats ' %s(%F{blue}%b%f)'
setopt PROMPT_SUBST

PROMPT='%n@%m %F{yello}%/%f${vcs_info_msg_0_} $ '


#
# tmux
#
tmux 2>/dev/null

#
# nvm
#
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 

#
# SSH-AGENT
#
unset SSH_AGENT_PID

if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

export GPG_TTY=$(tty)

gpg-connect-agent updatestartuptty /bye >/dev/null

alias lsa="ls -la"
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
