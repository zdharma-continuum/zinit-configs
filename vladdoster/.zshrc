#!/usr/bin/env zsh
#
# Author: Vladislav D.
# GitHub username: vladdoster
# Github repository: https://github.com/vladdoster/dotfiles
#
# Open an issue in https://github.com/vladdoster/dotfiles if
# you find a bug, have a feature request, or a question.
#
# A zinit-continuum configuration for macOS and Linux.
#
function info() { echo '[INFO] '; }
function error() { echo '[ERROR] '; }
case "$OSTYPE" in
  linux-gnu) bpick='*((#s)|/)*(linux|musl)*((#e)|/)*' ;;
    darwin*) bpick='*(macos|darwin)*' ;;
    *) error 'unsupported system -- some cli programs might not work' ;;
esac
#=== ZINIT =============================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME:-~/.local/share}}/zinit"
ZINIT_BIN_DIR_NAME="${ZINIT_BIN_DIR_NAME:-bin}"
if [[ ! -f "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}/zinit.zsh" ]]; then
  info 'installing zinit' \
    && command mkdir -p "${ZINIT_HOME}" \
    && command chmod g-rwX "${ZINIT_HOME}" \
    && command git clone --depth 1 https://github.com/zdharma-continuum/zinit "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}" \
  && info 'installed zinit' \
  || error 'git not found' >&2
fi
source "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}/zinit.zsh" \
  && autoload -Uz _zinit \
  && (( ${+_comps} )) \
  && _comps[zinit]=_zinit
zturbo(){ zinit depth'1' lucid ${1/#[0-9][a-d]/wait"${1}"} "${@:2}"; }
#=== PROMPT & THEME ====================================
zi light-mode for \
  compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh' atload"
      PURE_GIT_UP_ARROW='↑'; PURE_GIT_DOWN_ARROW='↓'; PURE_PROMPT_SYMBOL='ᐳ'; PURE_PROMPT_VICMD_SYMBOL='ᐸ';
      zstyle ':prompt:pure:git:action' color 'yellow'; zstyle ':prompt:pure:git:branch' color 'blue'; zstyle ':prompt:pure:git:dirty' color 'red'
      zstyle ':prompt:pure:path' color 'cyan'; zstyle ':prompt:pure:prompt:success' color 'green'" \
    sindresorhus/pure \
    zdharma-continuum/zinit-annex-submods \
    zdharma-continuum/zinit-annex-patch-dl
#=== GIT ===============================================
zi ice svn; zi snippet OMZ::plugins/git
zi snippet OMZ::plugins/git/git.plugin.zsh
#=== PIP ===============================================
zi snippet OMZP::pip
zi ice as'completion'; zi snippet OMZP::pip/_pip
#=== MISC. =============================================
zturbo light-mode for \
  ver'develop' atload'_zsh_autosuggest_start' \
    zsh-users/zsh-autosuggestions \
  atload'zstyle ":completion:*" special-dirs false' \
    PZTM::completion \
  as'completion' atpull'zinit cclear' blockf \
    zsh-users/zsh-completions \
  blockf atinit'ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay' \
    zdharma-continuum/fast-syntax-highlighting \
  atload'
      bindkey "^[[A" history-substring-search-up
      bindkey "^[[B" history-substring-search-down' \
    zsh-users/zsh-history-substring-search
#=== FZF ==============================================
  #  pack'default'      ls_colors           \
zturbo 0a light-mode for \
  pack dircolors-material  \
  pack'binary+keys'  fzf
#=== BINARIES ==========================================
zturbo 0b as"program" from"gh-r" for \
  bpick"${bpick}" pick'shfmt' @mvdan/sh \
  pick'git-sizer'    @github/git-sizer   \
  pick'grex'         pemistahl/grex      \
  pick'd*/delta'     dandavison/delta    \
  pick'f*/fd'        @sharkdp/fd         \
  pick'grex'         pemistahl/grex      \
  pick'h*/hyperfine' @sharkdp/hyperfine  \
  pick'ripgrep*/rg*' @BurntSushi/ripgrep \
  atload"
      alias ls='exa --git --group-directories-first'
      alias l='ls -blF'
      alias la='ls -abghilmu'
      alias ll='ls -al'
      alias tree='exa --tree'" \
  pick'bin/exa' \
    ogham/exa \
  atload"
      alias v='nvim'
      export EDITOR='nvim'" \
  bpick"${bpick}" pick'nvim/bin/nvim' ver'nightly' \
    neovim/neovim
