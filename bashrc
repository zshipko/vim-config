alias open="xdg-open"
if [ -e "/usr/share/autojump/autojump.sh" ]; then
  source "/usr/share/autojump/autojump.sh"
fi
alias copy="xclip -i -sel clip"
alias paste="xclip -o -sel clip"

PS1=""
if [[ $SSH_CONNECTION != "" ]]; then
  RCol='\[\e[0m\]'
  Color='\[\e[37;41m\]'
  PS1="${Color}SSH${RCol} "
fi

PS1+='\[\e[0;96m\]\u\[\e[0m\]@\[\e[0;92m\]\H\[\e[0m\]:\[\e[0;93m\]$(git branch 2>/dev/null | grep '"'"'^*'"'"' | colrm 1 2) \[\e[0m\]\w\n\[\e[0m\]\$ \[\e[0m\]'
export PS1
export PATH="$HOME/.cargo/bin:$PATH"

source "$HOME/.cargo/env"

eval "$(fnm env 2> /dev/null)"
