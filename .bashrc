# Ethan Ferguson Custom .bashrc

alias ll='ls -lpvh --color=auto --group-directories-first'
alias l='ll -a'
export GPG_TTY="$( tty )"
alias chibi='chibi-scheme -R -e "(import (scheme base))"'
alias cljs='clj -M -m cljs.main'
alias ec='emacsclient -r -q -n'
alias ecc='emacsclient -c -q -n'
alias ect='emacsclient -t'
HISTCONTROL=ignoreboth:erasedups
gsc(){ git clone git@github.com:$1/$2; } # git SSH clone

if [[ `id -u` = 0 ]]; then
    PS1='\[\e[1;37m\][\[\e[101;97m\]\u\[\e[0;37m\]@\[\e[1;95m\]\h \[\e[1;32m\]\W\[\e[1;37m\]]$\[\e[0m\] '
else
    PS1='\[\e[1;37m\][\u\[\e[0;37m\]@\[\e[1;95m\]\h \[\e[1;32m\]\W\[\e[1;37m\]]$\[\e[0m\] '
fi

