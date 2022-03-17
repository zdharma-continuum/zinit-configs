#!/usr/bin/env zsh
#
# numToStr zinit configuration
#
#
#=== HELPER METHODS ===================================
function error() { print -P "%F{160}[ERROR] ---%f%b $1" >&2 && exit 1; }
function info() { print -P "%F{34}[INFO] ---%f%b $1"; }
#=== ZINIT ============================================
typeset -gAH ZINIT;
ZINIT[HOME_DIR]=$XDG_DATA_HOME/zsh/zinit  ZPFX=$ZINIT[HOME_DIR]/polaris
ZINIT[BIN_DIR]=$ZINIT[HOME_DIR]/zinit.git ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=1
ZINIT[COMPLETIONS_DIR]=$ZINIT[HOME_DIR]/completions ZINIT[SNIPPETS_DIR]=$ZINIT[HOME_DIR]/snippets
ZINIT[ZCOMPDUMP_PATH]=$ZINIT[HOME_DIR]/zcompdump    ZINIT[PLUGINS_DIR]=$ZINIT[HOME_DIR]/plugins
ZI_REPO='zdharma-continuum'; GH_RAW_URL='https://raw.githubusercontent.com'
if [[ ! -e $ZINIT[BIN_DIR] ]]; then
  info 'Downloading Zinit' \
    && command git clone \
        --branch 'bugfix/system-gh-r-selection' \
        https://github.com/$ZI_REPO/zinit \
        $ZINIT[BIN_DIR] \
    || error 'Unable to download zinit' \
    && info 'Installing Zinit' \
    && command chmod g-rwX $ZINIT[HOME_DIR] \
    && zcompile $ZINIT[BIN_DIR]/zinit.zsh \
    && info 'Successfully installed Zinit' \
    || error 'Unable to install Zinit'
fi
source $ZINIT[BIN_DIR]/zinit.zsh \
  && autoload -Uz _zinit \
  && (( ${+_comps} )) \
  && _comps[zinit]=_zinit
#####################
# PROMPT            #
#####################
zinit lucid for \
    as"command" \
    from"gh-r" \
    atinit'export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"' atload'eval "$(starship init zsh)"' \
    starship/starship
##########################
# OMZ Libs and Plugins   #
##########################
# IMPORTANT:
# Ohmyzsh plugins and libs are loaded first as some these sets some defaults which are required later on.
# Otherwise something will look messed up
# ie. some settings help zsh-autosuggestions to clear after tab completion
setopt promptsubst
# Explanation:
# 1. Loading tmux first, to prevent jumps when tmux is loaded after .zshrc
# 2. History plugin is loaded early (as it has some defaults) to prevent empty history stack for other plugins
zinit lucid for \
    atinit"
      ZSH_TMUX_FIXTERM=false
      ZSH_TMUX_AUTOSTART=false
      ZSH_TMUX_AUTOCONNECT=false" \
  OMZP::tmux \
  atinit"HIST_STAMPS=dd.mm.yyyy" \
  OMZL::history.zsh \

zinit wait lucid for \
	OMZL::clipboard.zsh \
	OMZL::compfix.zsh \
	OMZL::completion.zsh \
	OMZL::correction.zsh \
    atload"
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ....='cd ../../..'
      alias .....='cd ../../../..'" \
	OMZL::directories.zsh \
	OMZL::git.zsh \
	OMZL::grep.zsh \
	OMZL::key-bindings.zsh \
	OMZL::spectrum.zsh \
	OMZL::termsupport.zsh \
    atload"alias gcd='gco dev'" \
	OMZP::git \
	OMZP::fzf \
    atload"
      alias dcupb='docker-compose up --build'" \
	OMZP::docker-compose \
    as"completion" \
  OMZP::docker/_docker \
  djui/alias-tips \
  hlissner/zsh-autopair \
  chriskempson/base16-shell
#####################
# PLUGINS           #
#####################
zinit wait lucid for \
    light-mode atinit"ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20" atload"_zsh_autosuggest_start" \
  zsh-users/zsh-autosuggestions \
    light-mode atinit"
      typeset -gA FAST_HIGHLIGHT; FAST_HIGHLIGHT[git-cmsg-len]=100;
      zpcompinit; zpcdreplay" \
  zdharma-continuum/fast-syntax-highlighting \
    atpull'zinit creinstall -q .' \
    atinit"
      zstyle ':completion:*' completer _expand _complete _ignored _approximate
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      zstyle ':completion:*' menu select=2
      zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
      zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm,cmd -w -w'
      zstyle ':completion:*:descriptions' format '-- %d --'
      zstyle ':completion:*:processes' command 'ps -au$USER'
      zstyle ':completion:complete:*:options' sort false
      zstyle ':fzf-tab:complete:_zlua:*' query-string input
      zstyle ':fzf-tab:complete:cd:*' extra-opts --preview=$extract'exa -1 --color=always ${~ctxt[hpre]}$in'
      zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap" \
    blockf light-mode \
  zsh-users/zsh-completions \
    atinit"
      zstyle :history-search-multi-word page-size 10
      zstyle :history-search-multi-word highlight-color fg=red,bold
      zstyle :plugin:history-search-multi-word reset-prompt-protect 1" \
    bindmap"^R -> ^H" \
  zdharma-continuum/history-search-multi-word \
    atclone"
      local P=${${(M)OSTYPE:#*darwin*}:+g}
      \${P}sed -i \
      '/DIR/c\DIR 38;5;63;1' LS_COLORS; \
      \${P}dircolors -b LS_COLORS > c.zsh" \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”' \
    atpull'%atclone' pick"c.zsh" nocompile'!' reset-prompt \
  trapd00r/LS_COLORS
#####################
# PROGRAMS          #
#####################
zinit wait'1' lucid light-mode for \
    pick"z.sh" \
  knu/z \
    as'command' \
    atinit'export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"' \
    pick"**/n" \
  tj/n \
    from'gh-r' as'command' atinit'export PATH="$HOME/.yarn/bin:$PATH"' mv'yarn* -> yarn' pick"yarn/bin/yarn" bpick'*.tar.gz' \
  yarnpkg/yarn
