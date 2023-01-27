#!/bin/sh

MARK_COMMENT="# Ethan Ferguson Custom Scripts"
PWD=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

( [[ ! -f ~/.bash_profile ]] || ( ! grep -qs "$MARK_COMMENT" ~/.bash_profile ) ) && echo ". $PWD/.bash_profile $MARK_COMMENT" >> ~/.bash_profile

( [[ ! -f ~/.bashrc ]] || ( ! grep -qs "$MARK_COMMENT" ~/.bashrc ) ) && echo ". $PWD/.bashrc $MARK_COMMENT" >> ~/.bashrc

( [[ ! -f ~/.inputrc ]] || ( ! grep -qs "$MARK_COMMENT" ~/.inputrc ) ) && echo -e "$MARK_COMMENT\n\$include $PWD/.inputrc" >> ~/.inputrc
