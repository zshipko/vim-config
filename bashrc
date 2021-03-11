alias open="xdg-open"
if [ -e "/usr/share/autojump/autojump.sh" ]; then
  source "/usr/share/autojump/autojump.sh"
fi
alias j="autojump"
alias copy="xclip -i -sel clip"
alias paste="xclip -i -sel clip"
source "$HOME/.cargo/env"
export PS1='\[\e[0;96m\]\u\[\e[0m\]@\[\e[0;92m\]\H\[\e[0m\]:\[\e[0;93m\]$(git branch 2>/dev/null | grep '"'"'^*'"'"' | colrm 1 2) \[\e[0m\]\w\n\[\e[0m\]\$ \[\e[0m\]'
export DENO_INSTALL="/home/zach/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

