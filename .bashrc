# Ethan Ferguson Custom .bashrc

# Bash variables
HISTCONTROL=ignoreboth:erasedups

# Default exports
export GPG_TTY="$( tty )"

# Aliases
alias ll='ls -lpvh --color=auto --group-directories-first'
alias l='ll -a'
alias chibi='chibi-scheme -R -e "(import (scheme base))"'
alias cljs='clj -M -m cljs.main'
alias ec='emacsclient -r -q -n'
alias ecc='emacsclient -c -q -n'
alias ect='emacsclient -t'
alias winreboot='systemctl reboot --boot-loader-entry auto-windows'
alias c='echo --color=always' # For quickly adding color to command, just ad `c`
alias .brc='. ~/.bashrc'
alias pss='ps aux | grep -i'
alias cdgr='cd `git rev-parse --show-toplevel`'
alias bell='echo -e "\a"'
alias j='echo -j`nproc`'

# Functions
gsc(){ git clone git@github.com:$1/$2; } # [G]it [S]SH [C]lone
sk() { kubectl get $1 | tail -n +2 | grep $2 | cut -d ' ' -f 1 | tr '\n' ' '; }; # [S]elect [K]ubernetes object (e.g. `sk pods mongo`)

# Set bash prompt (different if root)
if [[ `id -u` = 0 ]]; then
    PS1='\[\e[1;37m\][\[\e[101;97m\]\u\[\e[0;37m\]@\[\e[1;95m\]\h \[\e[1;32m\]\W\[\e[1;37m\]]#\[\e[0m\] '
else
    PS1='\[\e[1;37m\][\u\[\e[0;37m\]@\[\e[1;95m\]\h \[\e[1;32m\]\W\[\e[1;37m\]]$\[\e[0m\] '
fi

# For emacs tramp
case "$TERM" in
    "dumb")
	PS1="[\u@\h \W]$ "
	;;
esac
