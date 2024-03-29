#!/bin/sh

MARK_COMMENT="Ethan Ferguson Custom Scripts"
PWD=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

( [[ ! -f ~/.bash_profile ]] || ( ! grep -qs "# $MARK_COMMENT" ~/.bash_profile ) ) && echo ". $PWD/.bash_profile # $MARK_COMMENT" >> ~/.bash_profile

( [[ ! -f ~/.bashrc ]] || ( ! grep -qs "# $MARK_COMMENT" ~/.bashrc ) ) && echo ". $PWD/.bashrc # $MARK_COMMENT" >> ~/.bashrc

( [[ ! -f ~/.inputrc ]] || ( ! grep -qs "# $MARK_COMMENT" ~/.inputrc ) ) && echo -e "# $MARK_COMMENT\n\$include $PWD/.inputrc" >> ~/.inputrc

if [[ -f ~/.emacs ]]
then
    mkdir -p ~/.emacs.d/
    cat ~/.emacs >> ~/.emacs.d/init.el
    rm -f ~/.emacs
fi

( [[ ! -f ~/.emacs.d/init.el ]] || ( ! grep -qs "; $MARK_COMMENT" ~/.emacs.d/init.el ) ) && echo -e "(load \"$PWD/init.el\") ; $MARK_COMMENT" >> ~/.emacs.d/init.el
