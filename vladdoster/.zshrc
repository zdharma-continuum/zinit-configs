#!/usr/bin/env zsh
#
# Open an issue in https://github.com/vladdoster/dotfiles if you find a bug,
# have a feature request, or a question. A zinit-continuum configuration for
# macOS and Linux.
#
#=== HELPER METHODS ===================================
function error() { print -P "%F{red}[ERROR]%f: %F{yellow}$1%f" && return 1 }
function info() { print -P "%F{blue}[INFO]%f: %F{cyan}$1%f"; }
#=== ZINIT ============================================
typeset -gAH ZINIT;
ZINIT[HOME_DIR]=$XDG_DATA_HOME/zsh/zinit  ZPFX=$ZINIT[HOME_DIR]/polaris
ZINIT[BIN_DIR]=$ZINIT[HOME_DIR]/zinit.git ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=1
ZINIT[COMPLETIONS_DIR]=$ZINIT[HOME_DIR]/completions ZINIT[SNIPPETS_DIR]=$ZINIT[HOME_DIR]/snippets
ZINIT[ZCOMPDUMP_PATH]=$ZINIT[HOME_DIR]/zcompdump    ZINIT[PLUGINS_DIR]=$ZINIT[HOME_DIR]/plugins
ZI_FORK='vladdoster'; ZI_REPO='zdharma-continuum'; GH_RAW_URL='https://raw.githubusercontent.com'
if [[ ! -e $ZINIT[BIN_DIR] ]]; then
  info 'downloading zinit' \
  && command git clone \
    https://github.com/$ZI_REPO/zinit.git \
    $ZINIT[BIN_DIR] \
  || error 'failed to clone zinit repository' \
  && info 'setting up zinit' \
  && command chmod g-rwX $ZINIT[HOME_DIR] \
  && zcompile $ZINIT[BIN_DIR]/zinit.zsh \
  && info 'sucessfully installed zinit'
fi
if [[ -e $ZINIT[BIN_DIR]/zinit.zsh ]]; then
  source $ZINIT[BIN_DIR]/zinit.zsh \
    && autoload -Uz _zinit \
    && (( ${+_comps} )) \
    && _comps[zinit]=_zinit
else error "unable to find 'zinit.zsh'" && return 1
fi
#=== STATIC ZSH BINARY =======================================
zi for atpull"%atclone" depth"1" lucid nocompile nocompletions as"null" \
    atclone"./install -e no -d ~/.local" atinit"export PATH=$HOME/.local/bin:$PATH" \
  @romkatv/zsh-bin
#=== COMPILE ZSH SOURCE =======================================
# zi for atpull'%atclone' nocompile as'null' atclone'
#     { print -P "%F{blue}[INFO]%f:%F{cyan}Building Zsh %f" \
#       && autoreconf --force --install --make || ./Util/preconfig \
#       && CFLAGS="-g -O3" ./configure --prefix=/usr/local >/dev/null \
#       && print -P "%F{blue}[INFO]%f:%F{cyan} Configured Zsh %f" \
#       && make -j8 PREFIX=/usr/local >/dev/null || make \
#       && print -P "%F{blue}[INFO]%f:%F{green} Compiled Zsh %f" \
#       && sudo make -j8 install >/dev/null || make \
#       && print -P "%F{blue}[INFO]%f:%F{green} Installed $(/usr/local/bin/zsh --version) @ /usr/local/bin/zsh %f" \
#       && print -P "%F{blue}[INFO]%f:%F{green} Adding /usr/local/bin/zsh to /etc/shells %f" \
#       sudo sh -c "echo /usr/bin/local/zsh >> /etc/shells" \
#       && print -P "%F{blue}[INFO]%f: To update your shell, run: %F{cyan} chsh --shell /usr/local/bin/zsh $USER %f"
#     } || { print -P "%F{red}[ERROR]%f:%F{yellow} Failed to install Zsh %f" }' \
#   zsh-users/zsh
# #=== OH-MY-ZSH & PREZTO PLUGINS =======================
zi for is-snippet \
  OMZL::{'clipboard','compfix','completion','git','grep','key-bindings'}.zsh \
  OMZP::brew \
  PZT::modules/{'history','rsync'}
zi as'completion' for OMZP::{'golang/_golang','pip/_pip','terraform/_terraform'}
#=== COMPLETIONS ======================================
local GH_RAW_URL='https://raw.githubusercontent.com'
install_completion(){ zinit for as'completion' nocompile id-as"$1" is-snippet "$GH_RAW_URL/$2"; }
install_completion 'brew-completion/_brew'     'Homebrew/brew/master/completions/zsh/_brew'
install_completion 'docker-completion/_docker' 'docker/cli/master/contrib/completion/zsh/_docker'
install_completion 'exa-completion/_exa'       'ogham/exa/master/completions/zsh/_exa'
install_completion 'fd-completion/_fd'         'sharkdp/fd/master/contrib/completion/_fd'
#=== PROMPT ===========================================
zi light-mode for \
  compile'(pure|async).zsh' multisrc'(pure|async).zsh' atinit"
    PURE_GIT_DOWN_ARROW='↓'; PURE_GIT_UP_ARROW='↑'
    PURE_PROMPT_SYMBOL='ᐳ'; PURE_PROMPT_VICMD_SYMBOL='ᐸ'
    zstyle ':prompt:pure:git:action' color 'yellow'
    zstyle ':prompt:pure:git:branch' color 'blue'
    zstyle ':prompt:pure:git:dirty' color 'red'
    zstyle ':prompt:pure:path' color 'cyan'
    zstyle ':prompt:pure:prompt:success' color 'green'" \
  sindresorhus/pure
#=== zsh-vim-mode cursor configuration [[[
MODE_CURSOR_VICMD="green block";              MODE_CURSOR_VIINS="#20d08a blinking bar"
MODE_INDICATOR_REPLACE='%F{9}%F{1}REPLACE%f'; MODE_INDICATOR_VISUAL='%F{12}%F{4}VISUAL%f'
MODE_INDICATOR_VIINS='%F{15}%F{8}INSERT%f';   MODE_INDICATOR_VICMD='%F{10}%F{2}NORMAL%f'
MODE_INDICATOR_VLINE='%F{12}%F{4}V-LINE%f';   MODE_CURSOR_SEARCH="#ff00ff blinking underline"
setopt PROMPT_SUBST;  export KEYTIMEOUT=1 export LANG=en_US.UTF-8; export LC_ALL="en_US.UTF-8";
export LC_COLLATE='C' export LESS='-RMs'; export PAGER=less;       export VISUAL=vi
RPS1='${MODE_INDICATOR_PROMPT} ${vcs_info_msg_0_}'
#=== ANNEXES ==========================================
zi light-mode for "$ZI_REPO"/zinit-annex-{'bin-gem-node','binary-symlink','patch-dl','submods'}
#=== GITHUB BINARIES ==================================
zi from'gh-r' lbin'!' nocompile for \
  @dandavison/delta    @junegunn/fzf       \
  @koalaman/shellcheck @pemistahl/grex     \
  @melbahja/got        @r-darwish/topgrade \
  @sharkdp/fd          @sharkdp/hyperfine  \
  lbin'!* -> jq'     @stedolan/jq        \
  lbin'!* -> shfmt'  @mvdan/sh           \
  lbin'!**/nvim' @neovim/neovim      \
  lbin'!**/rg'       @BurntSushi/ripgrep \
  lbin atinit"
    alias ll='exa -al';
    alias l='exa -blF';
    alias la='exa -abghilmu';
    alias ls='exa --git --group-directories-first'" \
  @ogham/exa

zi as'command' light-mode for \
  pick'revolver' @molovo/revolver \
  pick'zunit' atclone'./build.zsh' @zunit-zsh/zunit
#=== COMPILED PROGRAMS ================================
zi lucid make'PREFIX=$PWD install' nocompile for \
  lbin'!**/tree*' Old-Man-Programmer/tree \
  lbin'!**/zsd*' $ZI_REPO/zshelldoc
#=== PYTHON ===========================================
function _pip_completion {
  local words cword; read -Ac words; read -cn cword
  reply=(
    $(
      COMP_WORDS="$words[*]"; COMP_CWORD=$(( cword-1 )) \
      PIP_AUTO_COMPLETE=1 $words 2>/dev/null
    )
  )
}; compctl -K _pip_completion pip3
#=== MISC. ============================================
zi light-mode for \
    atinit"bindkey -M vicmd '^e' edit-command-line" compile'zsh-vim-mode*.zsh' \
  softmoth/zsh-vim-mode \
  thewtex/tmux-mem-cpu-load \
    svn submods'zsh-users/zsh-history-substring-search -> external' \
  OMZ::plugins/history-substring-search \
    atpull'zinit creinstall -q .' blockf \
  zsh-users/zsh-completions \
    atload'_zsh_autosuggest_start' \
    atinit"
      ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
      bindkey '^_' autosuggest-execute
      bindkey '^ ' autosuggest-accept" \
  zsh-users/zsh-autosuggestions \
    atclone'(){local f;cd -q →*;for f (*~*.zwc){zcompile -Uz -- ${f}};}' \
    atload'FAST_HIGHLIGHT[chroma-man]=' atpull'%atclone' \
    compile'.*fast*~*.zwc' nocompletions \
  $ZI_REPO/fast-syntax-highlighting

zi for atload'
      zicompinit; zicdreplay
      _zsh_highlight_bind_widgets
      _zsh_autosuggest_bind_widgets' \
    as'null' id-as'zinit/cleanup' lucid nocd wait \
  $ZI_REPO/null

# vim:ft=zsh:sw=2:sts=2
