#!/usr/bin/env zsh
#
# Author: Vladislav D.
# GitHub: vladdoster
#   Repo: https://dotfiles.vdoster.com
#
# Open an issue in https://github.com/vladdoster/dotfiles if
# you find a bug, have a feature request, or a question.
#
# sources various parts of zsh configuration
#
#=== HISTORY =============================================
#!/usr/bin/env zsh
#
# Author: Vladislav D.
# GitHub: vladdoster
#   Repo: https://dotfiles.vdoster.com
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
    && command git clone --depth 1 --branch main https://github.com/${ZINIT_REPO:-vladdoster}/zinit-1 "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}" \
  && info 'installed zinit' \
  || error 'git not found' >&2
fi
autoload -U +X bashcompinit && bashcompinit
source "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}/zinit.zsh" \
  && autoload -Uz _zinit \
  && (( ${+_comps} )) \
  && _comps[zinit]=_zinit
zturbo(){ zinit depth'1' lucid ${1/#[0-9][a-d]/wait"${1}"} "${@:2}"; }
ZINIT_REPO="zdharma-continuum"
#=== PROMPT & THEME ====================================
zi light-mode for \
  compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh' atload"
      PURE_GIT_UP_ARROW='↑'; PURE_GIT_DOWN_ARROW='↓'; PURE_PROMPT_SYMBOL='ᐳ'; PURE_PROMPT_VICMD_SYMBOL='ᐸ';
      zstyle ':prompt:pure:git:action' color 'yellow'; zstyle ':prompt:pure:git:branch' color 'blue'; zstyle ':prompt:pure:git:dirty' color 'red'
      zstyle ':prompt:pure:path' color 'cyan'; zstyle ':prompt:pure:prompt:success' color 'green'" \
    sindresorhus/pure \
    ${ZINIT_REPO}/zinit-annex-submods \
    ${ZINIT_REPO}/zinit-annex-patch-dl \
    ${ZINIT_REPO}/zinit-annex-bin-gem-node
#=== GIT ===============================================
zi ice svn; zi snippet OMZ::plugins/git
zi snippet OMZ::plugins/git/git.plugin.zsh
#=== OSX ===============================================
zi ice if'[[ $OSTYPE = darwin* ]]' svn; zi snippet PZTM::gnu-utility
#=== PIP ===============================================
zi snippet OMZP::pip
zi ice as'completion'; zi snippet OMZP::pip/_pip
#=== MISC. =============================================
zturbo 0a light-mode for \
  atload'
      bindkey "^[[A" history-substring-search-up
      bindkey "^[[B" history-substring-search-down' \
    zsh-users/zsh-history-substring-search \
  ver'develop' atinit'ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20' atload'_zsh_autosuggest_start' \
    zsh-users/zsh-autosuggestions \
  is-snippet atload'zstyle ":completion:*" special-dirs false' \
    PZTM::completion \
  atload"zicompinit; zicdreplay" blockf \
    zsh-users/zsh-completions \
  blockf atpull'zinit creinstall -q .' \
    zdharma-continuum/fast-syntax-highlighting
#=== FZF ==============================================
zi wait'0b' lucid from"gh-r" as"program" for \
    @junegunn/fzf
zi ice wait'0a' lucid; zi snippet https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
zi ice wait'1a' lucid; zi snippet https://github.com/junegunn/fzf/blob/master/shell/completion.zsh
zi wait'1a' lucid pick"fzf-extras.zsh"        light-mode for \
    @atweiden/fzf-extras
zi wait'0c' lucid pick"fzf-finder.plugin.zsh" light-mode for \
    @leophys/zsh-plugin-fzf-finder
#=== BINARIES ==========================================
zturbo 1a from"gh-r" as'program' for \
  pick"delta*/delta"             dandavison/delta        \
  pick'git-sizer'                @github/git-sizer       \
  pick'grex'                     pemistahl/grex          \
  pick'shfmt'  bpick"${bpick}"   @mvdan/sh               \
  pick"tree-sitter*/tree-sitter" tree-sitter/tree-sitter

zturbo 1b from'gh-r' as"command" for \
  mv'bat* bat'             sbin'**/bat -> bat'             @sharkdp/bat       \
  mv'fd* fd'               sbin'**/fd -> fd'               @sharkdp/fd        \
  mv'hyperfine* hyperfine' sbin'**/hyperfine -> hyperfine' @sharkdp/hyperfine \
  mv'rip* ripgrep'         sbin'**/rg -> rg'               BurntSushi/ripgrep \
  mv'nvim* nvim'           sbin"**/bin/nvim -> nvim"       bpick"${bpick}"    \
  atload'export EDITOR="nvim"
         alias v="${EDITOR}"' \
    neovim/neovim \
  sbin'**/exa -> exa'      atclone'cp -vf completions/exa.zsh _exa' \
  atload"alias ls='exa --git --group-directories-first'
         alias l='ls -blF'
         alias la='ls -abghilmu'
         alias ll='ls -al'
         alias tree='exa --tree'" \
    ogham/exa
