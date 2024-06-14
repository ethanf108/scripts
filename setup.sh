#!/bin/bash

MARK_COMMENT="Ethan Ferguson Custom Scripts"
PWD=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

( [[ ! -f ~/.bash_profile ]] || ( ! grep -qs "# $MARK_COMMENT" ~/.bash_profile ) ) && echo ". $PWD/.bash_profile # $MARK_COMMENT" >> ~/.bash_profile

( [[ ! -f ~/.bashrc ]] || ( ! grep -qs "# $MARK_COMMENT" ~/.bashrc ) ) && echo ". $PWD/.bashrc # $MARK_COMMENT" >> ~/.bashrc

( [[ ! -f ~/.inputrc ]] || ( ! grep -qs "# $MARK_COMMENT" ~/.inputrc ) ) && echo -e "# $MARK_COMMENT\n\$include $PWD/.inputrc" >> ~/.inputrc

( [[ ! -f ~/.tmux.conf ]] || ( ! grep -qs "# $MARK_COMMENT" ~/.tmux.conf ) ) && echo -e "source $PWD/.tmux.conf # $MARK_COMMENT" >> ~/.tmux.conf

if [[ ! -d ~/.emacs.d/ ]]
then
    mkdir -p ~/.emacs.d/
    if [[ -f ~/.emacs ]]
    then
	cat ~/.emacs >> ~/.emacs.d/init.el
	rm -f ~/.emacs
    fi
fi

( [[ ! -f ~/.emacs.d/init.el ]] || ( ! grep -qs "; $MARK_COMMENT" ~/.emacs.d/init.el ) ) && echo -e "(load \"$PWD/init.el\") ; $MARK_COMMENT" >> ~/.emacs.d/init.el
