# Ethan Ferguson Custom .bashrc

alias ll='ls -lpv --color=auto --group-directories-first --block-size=h'
alias l='ll -a'
export GPG_TTY="$( tty )"
alias chibi='chibi-scheme -R -e "(import (scheme base))"'
alias cljs='clj -M -m cljs.main'
alias ec='emacsclient -cq'
export HISTCONTROL=ignoreboth:erasedups
