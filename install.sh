#!/bin/bash

TEST=0
if [[ $TEST -eq 1 ]]; then
  MKDIR="echo mkdir"
  MV="echo mv"
  LN="echo ln"
else
  MKDIR=mkdir
  MV=mv
  LN=ln
fi

BACKUPDIR=~/.rcm.backup.$$ 

function backup()
{
  ITEM=$1
  if [[ ! -d $BACKUPDIR && $TEST -eq 0 ]]; then
    $MKDIR $BACKUPDIR
  fi
  if [[ -e $ITEM ]]; then
    $MV $ITEM $BACKUPDIR
  fi
}

function setuplp()
{
  SRC=$1
  DST=$2

  backup $DST
  $LN -sf $SRC $DST

}
function setupln()
{
  SRC=$1
  DST=$2

  backup $DST
  $LN -sf $SRC $DST

}

setupcp .rcm/bash/bashrc $HOME/.bashrc
setupcp .rcm/bash/bash_profile $HOME/.bash_profile

setupln .rcm/bash/bash_aliases $HOME/.bash_aliases
setupln .rcm/bash/bash_funcs $HOME/.bash_funcs

setupln .rcm/vim $HOME/.vim
setupcp .rcm/vim/dotvimrc $HOME/.vimrc

setupcp .rcm/emacs/dotemacs $HOME/.emacs
setupln .rcm/emacs/emacs.d $HOME/.emacs.d
