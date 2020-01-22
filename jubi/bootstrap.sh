#!/usr/bin/env zsh

case `uname` in
  Darwin)
    brew install fzf
  ;;
  Linux)
    # No such package
    # sudo apt install fzf
    :
  ;;
esac
