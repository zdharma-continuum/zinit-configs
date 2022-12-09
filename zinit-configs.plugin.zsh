#!/usr/bin/env zsh
# -*- mode: sh; sh-indentation: 2; sh-basic-offset: 2; -*-

# Copyright (c) 2020 Sebastian Gniazdowski
# License MIT

# Get $0 according to the Zsh Plugin Standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html#zero-handling
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

CURRENT_DIR=${0:a:h}

zinit-configs-cmd() {
  "${CURRENT_DIR}"/run.sh
}

# The subcommand `scope'.
@zi::register-annex "zinit-configs" \
  subcommand:configs \
  zinit-configs-cmd

# vim:ft=zsh:tw=80:sw=2:sts=2:noet
