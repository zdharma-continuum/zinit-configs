#
# Exports
#

module_path+=("$HOME/.zplugin/bin/zmodules/Src"); zmodload zdharma/zplugin

typeset -g HISTSIZE=290000 SAVEHIST=290000 HISTFILE=~/.zhistory ABSD=${${(M)OSTYPE:#*(darwin|bsd)*}:+1}

typeset -ga mylogs
zflai-msg() { mylogs+=( "$1" ); }
zflai-assert() { mylogs+=( "$4"${${${1:#$2}:+FAIL}:-OK}": $3" ); }

(( ABSD )) && {
    export LSCOLORS=dxfxcxdxbxegedabagacad CLICOLOR="1" 
    export ANDROID_ROOT=/opt/android
}

export EDITOR="vim" LESS="-iRFX" CVS_RSH="ssh"

umask 022

#
# Setopts
#

setopt interactive_comments hist_ignore_dups  octal_zeroes   no_prompt_cr  notify
setopt no_hist_no_functions no_always_to_end  append_history list_packed
setopt inc_append_history   complete_in_word  no_auto_menu   auto_pushd
setopt pushd_ignore_dups    no_glob_complete  no_glob_dots   c_bases
setopt numeric_glob_sort    no_share_history  promptsubst    auto_cd
setopt rc_quotes

#setopt IGNORE_EOF
#setopt NO_SHORT_LOOPS
#setopt PRINT_EXIT_VALUE
#setopt RM_STAR_WAIT

#
# Bindkeys
#

autoload up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -v
[[ -n "$terminfo[kpp]"   ]] && bindkey "$terminfo[kpp]"   up-line-or-beginning-search   # PAGE UP
[[ -n "$terminfo[knp]"   ]] && bindkey "$terminfo[knp]"   down-line-or-beginning-search # PAGE DOWN
[[ -n "$terminfo[khome]" ]] && bindkey "$terminfo[khome]" beginning-of-line             # HOME
[[ -n "$terminfo[kend]"  ]] && bindkey "$terminfo[kend]"  end-of-line                   # END
[[ -n "$terminfo[kdch1]" ]] && bindkey "$terminfo[kdch1]" delete-char                   # DELETE
[[ -n "$terminfo[kbs]"   ]] && bindkey "$terminfo[kbs]"   backward-delete-char          # BACKSPACE

zflai-assert "${+terminfo[kpp]}${+terminfo[knp]}${+terminfo[khome]}${+terminfo[kend]}" "1111" "terminfo test" "[zshrc] "

bindkey "^A"      beginning-of-line     "^E"      end-of-line
bindkey "^?"      backward-delete-char  "^H"      backward-delete-char
bindkey "^W"      backward-kill-word    "\e[1~"   beginning-of-line
bindkey "\e[7~"   beginning-of-line     "\e[H"    beginning-of-line
bindkey "\e[4~"   end-of-line           "\e[8~"   end-of-line
bindkey "\e[F"    end-of-line           "\e[3~"   delete-char
bindkey "^J"      accept-line           "^M"      accept-line
bindkey "^T"      accept-line           "^R"      history-incremental-search-backward

#
# Modules
#

zmodload -i zsh/complist

#
# Autoloads
#

autoload -Uz allopt zed zmv zcalc colors
colors

autoload -Uz edit-command-line
zle -N edit-command-line
#bindkey -M vicmd v edit-command-line

autoload -Uz select-word-style
select-word-style shell

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

#url_quote_commands=(links wget youtube-dl curl); zstyle -e :urlglobber url-other-schema '[[ $url_quote_commands[(i)$words[1]] -le ${#url_quote_commands} ]] && reply=("*") || reply=(http https ftp ssh)'

#
# Aliases
#

alias pl='print -rl --'
alias ls="exa -bh ${${${ABSD#0}:+-G}:---color=auto}"
alias l="ls"      l.='ls -d .*'   la='ls -a'   ll='ls -lbt created'  rm='command rm -i'
alias df='df -h'  du='du -h'      cp='cp -v'   mv='mv -v'      plast="last -20"
alias reload="exec $SHELL -l -i"  grep="command grep --colour=auto"
alias lynx="command lynx -accept-all-cookies"  ult="ulimit -c 195312; echo $$"
ulimit -c $(( 100000000 / 512 ))

# Git
alias g1log_branches="git log --color=always --oneline --decorate --graph --branches"
alias g1log_branches_intag="echo You can append a tag name; LANG=C sleep 0.5; git log --color=always --oneline --decorate --graph --branches"
alias g1log_simplify_decfull="git log --color=always --decorate=full --simplify-by-decoration"
alias g1log_simplify="git log --color=always --simplify-by-decoration --decorate"

# Image Magick
alias i1montage_concat_topbo_black="montage -mode concatenate -tile 1x -background black"
alias i1montage_concat_topbo_white="montage -mode concatenate -tile 1x -background white"
alias i1convert_append_topbo_black="convert -append -background black"
alias i1convert_append_topbo_white="convert -append -background white"
alias i1convert_append_lefri_black="convert +append -background black"
alias i1convert_append_lefri_white="convert +append -background white"


# Homebrew
alias b1s="brew search"    b1i="brew install" 	   b1muver="brew ls --versions --multiple"
alias b1info="brew info"   b1desc="brew desc" 	   b1descs="brew desc --search"
alias b1ls="brew list"     b1leaves="brew leaves"  b1upgrade="brew update; brew upgrade; brew cleanup"
alias b1home="brew home"   b1u="brew uninstall"    b1uses_installed="brew uses --installed"
alias b1up="brew upgrade"
# Homebrew/cask
alias b1cask_s="brew cask search"    b1cask_i="brew cask install"
alias b1cask_u="brew cask uninstall" b1cask_info="brew cask info"
alias b1cask_ls="brew cask list"     b1cask_home="brew cask home"
alias b1cask_up="brew cask upgrade"

# Quick typing
alias n1ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias n1ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias n1sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias n1httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Show/hide hidden files in Finder
alias x1show_hidden="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias x1hide_hidden="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias x1hide_desktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias x1show_desktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Disable / enable Spotlight
alias x1spotoff="sudo mdutil -a -i off"
alias x1spoton="sudo mdutil -a -i on"

# Flush Directory Service cache
alias x1flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

alias x1mute="osascript -e 'set volume output muted true'"
alias x1lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Email screenshot
alias x1email_screen="screencapture -C -M screen-`date +%d.%m.%Y-%H`.png"
alias x1email_screen10s="screencapture -T 10 -C -M screen-`date +%d.%m.%Y-%H`.png"
alias x1email_window="screencapture -W -M screen-`date +%d.%m.%Y-%H`.png"
alias x1email_snippet="screencapture -s -M screen-`date +%d.%m.%Y-%H`.png"

#
# General tools
#

alias newest_ls="ls -lh --modified | head -25"
alias cpfile="rsync --progress"
alias zmv='noglob zmv -w'
alias recently_changed='find . -newerct "15 minute ago" -print'
recently_changed_x() { find . -newerct "$1 minute ago" -print; }
alias -g SPRNG=" | curl -F 'sprunge=<-' http://sprunge.us"

#
# Patches for various problems
#

alias slocate='locate'
alias updatedb="sudo /usr/libexec/locate.updatedb"

# alias ls=psls ... - retain ls options but substitute the command with psls
if altxt=`alias ls`; then
    altxt="${altxt#alias }" # for sh
    if [ "$altxt" != "${altxt#ls=\'ls}" ]; then
        altxt=${altxt#ls=\'ls}
        altxt=${altxt%\'}
        altxt="ls=psls$altxt"
        alias "$altxt"
        zflai-msg "[zshrc] \`ls' alias: $altxt"
    fi
else
    alias ls="psls"
    zflai-msg "[zshrc] \`ls' alias: ls=psls"
fi

fpath+=( $HOME/functions )

autoload -Uz psprobe_host   psffconv    pssetup_ssl_cert    psrecompile    pscopy_xauth  \
             psls           pslist      psfind \
             mandelbrot     optlbin_on  optlbin_off         localbin_on    localbin_off    g1all   g1zip \
             zman \
             t1uncolor 	    t1fromhex   t1countdown \
             f1rechg_x_min  f1biggest \
             n1gglinks      n1dict      n1diki              n1gglinks      n1ggw3m         n1ling  n1ssl_tunnel \
	     n1ssl_rtunnel  \
             pngimage       deploy-code

function run_diso {
  sh -c "$@" &
  disown
}

function pbcopydir {
  pwd | tr -d "\r\n" | pbcopy
}

function from-where {
    echo $^fpath/$_comps[$1](N.)
    whence -v $_comps[$1]
    #which $_comps[$1] 2>&1 | head
}

whichcomp() {
    for 1; do
        ( print -raC 2 -- $^fpath/${_comps[$1]:?unknown command}(NP*$1*) )
    done
}

osxnotify() {
    osascript -e 'display notification "'"$*"'"'
}


localbin_on

PS1="READY > "
zstyle ":plugin:zconvey" greeting "none"
zstyle ':notify:*' command-complete-timeout 3
zstyle ':notify:*' notifier /Users/sgniazdowski/.zplugin/plugins/zdharma---zconvey/cmds/plg-zsh-notify

palette() { local colors; for n in {000..255}; do colors+=("%F{$n}$n%f"); done; print -cP $colors; }

# Run redis-server port forwarding, from the public 3333 port
#n1ssl_rtunnel 3333 localhost 4815 zredis.pem zredis_client.crt &!
zflai-msg "[zshrc] ssl tunnel PID: $!"

#
# Zplugin
#

typeset -F4 SECONDS=0

source "$HOME/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

# Assign each zsh session an unique ID, available in
# ZUID_ID and also a codename (ZUID_CODENAME)
zplugin load zdharma/zsh-unique-id

# Loaded mostly to stay in touch with the plugin (for the users)
# and for the themes 2 & 3 (lambda-mod-zsh-theme & lambda-gitster)
zplugin ice wait lucid
zplugin snippet OMZ::lib/git.zsh

# Loaded mostly to stay in touch with the plugin (for the users)
zplugin ice wait atload"unalias grv g" lucid
zplugin snippet OMZ::plugins/git/git.plugin.zsh
# zsh-startify, a vim-startify -like plugin
zplugin ice wait'0b' lucid atload'zsh-startify'
zplugin load zdharma/zsh-startify

# On OSX, you might need to install coreutils from homebrew and use the
# g-prefix – gsed, gdircolors
zplugin ice wait'0c' lucid \
    atclone"git reset --hard; sed -i \
            '/DIR/c\DIR                   38;5;63;1' LS_COLORS; \
            dircolors -b LS_COLORS > c.zsh" \
            atpull'%atclone' pick"c.zsh" nocompile'!'
zplugin light trapd00r/LS_COLORS

# Zconvey shell integration plugin
zplugin ice wait silent
zplugin load zdharma/zconvey

# z-plugin (a Zplugin extension) which allows to explicitly clone submodules
zplugin ice wait lucid
zplugin light zdharma/z-p-submods

# Another load of the same plugin, to add zc-bg-notify to PATH
zplugin ice pick"cmds/zc-bg-notify" as"command" wait"1" id-as'zconvey-cmd' silent
zplugin load zdharma/zconvey

# fzy
zplugin ice wait'1' lucid as"command" make"!PREFIX=$ZPFX install" \
    atclone"cp contrib/fzy-* $ZPFX/bin/" \
    pick"$ZPFX/bin/fzy*"
zplugin light jhawthorn/fzy

# fzf, for fzf-marks
zplugin ice wait lucid as"command" from"gh-r"
zplugin light junegunn/fzf-bin

# fzf-marks, at slot 0, for quick Ctrl-G accessibility
zplugin ice wait lucid
zplugin load urbainvaes/fzf-marks

# zredis together with some binding/tying
zstyle ":plugin:zredis" configure_opts "--without-tcsetpgrp"
zstyle ":plugin:zredis" cflags  "-Wall -O2 -g -Wno-unused-but-set-variable"
zplugin ice wait'1' atload'ztie -d db/redis -a 127.0.0.1:4815/5 -zSL main rdhash' lucid
zplugin load zdharma/zredis

# a service that runs the redis database, in background, single instance
zplugin ice service"redis" lucid wait"1"
zplugin light zservices/redis

# zsh-editing-workbench & zsh-navigation-tools
zplugin ice wait'1' lucid
zplugin load psprint/zsh-editing-workbench
zplugin ice wait'1' lucid
zplugin load psprint/zsh-navigation-tools   # for n-history

# zdharma/history-search-multi-word
zstyle ":history-search-multi-word" page-size "11"
zplugin ice wait"1" lucid
zplugin load zdharma/history-search-multi-word

# Github-Issue-Tracker – the notifier thread
zplugin ice lucid id-as'GitHub-notify' \
        ice on-update-of'~/.cache/zsh-github-issues/new_titles.log' \
        notify'New issue: $NOTIFY_MESSAGE'
zplugin light zdharma/zsh-github-issues

# Github-Issue-Tracker – the issue-puller thread
GIT_SLEEP_TIME=700
GIT_PROJECTS=zdharma/zsh-github-issues:zdharma/zplugin

zplugin ice service"GIT" pick"zsh-github-issues.service.zsh" wait'2' lucid
zplugin light zdharma/zsh-github-issues

# Theme no. 1 - zprompts
zplugin ice load'![[ $MYPROMPT = 1 ]]' unload'![[ $MYPROMPT != 1 ]]' atload'!promptinit; typeset -g PSSHORT=0; prompt sprint3' lucid
zplugin load psprint/zprompts

# Theme no. 2 – lambda-mod-zsh-theme
zplugin ice load'![[ $MYPROMPT = 2 ]]' unload'![[ $MYPROMPT != 2 ]]' lucid
zplugin load halfo/lambda-mod-zsh-theme

# Theme no. 3 – lambda-gitster
zplugin ice load'![[ $MYPROMPT = 3 ]]' unload'![[ $MYPROMPT != 3 ]]' lucid
zplugin load ergenekonyigit/lambda-gitster

# Theme no. 4 – pure
GEOMETRY_COLOR_DIR=63 GEOMETRY_PATH_COLOR=63
zplugin ice load'![[ $MYPROMPT = 4 ]]' unload'![[ $MYPROMPT != 4 ]]' atload"prompt_geometry_render" lucid
zplugin load geometry-zsh/geometry

# Theme no. 5 – pure
zplugin ice ice load'![[ $MYPROMPT = 5 ]]' unload'![[ $MYPROMPT != 5 ]]' \
             multisrc"{async,pure}.zsh" pick"/dev/null" idas"my/pure/login"
zplugin load sindresorhus/pure

# Theme no. 6 - agkozak-zsh-theme
AGKOZAK_FORCE_ASYNC_METHOD=subst-async
zplugin ice ice load'![[ $MYPROMPT = 6 ]]' unload'![[ $MYPROMPT != 6 ]]' lucid
zplugin load agkozak/agkozak-zsh-theme

# Theme no. 7 - zinc
zplugin ice load'![[ $MYPROMPT = 7 ]]' unload'![[ $MYPROMPT != 7 ]]' \
    nocompletions atclone'prompt_zinc_compile' atpull'%atclone' \
    compile"{zinc_functions/*,segments/*,zinc.zsh}" atload'zinc_selfdestruct_setup'
zplugin load robobenklein/zinc

# ZUI and Crasis
zplugin ice wait"1" lucid
zplugin load zdharma/zui
zplugin ice wait'[[ -n ${ZLAST_COMMANDS[(r)cras*]} ]]' lucid
zplugin load zdharma/zplugin-crasis

# Gitignore plugin – commands gii and gi
zplugin ice wait"2" lucid
zplugin load voronkovich/gitignore.plugin.zsh

# Autosuggestions & fast-syntax-highlighting
zplugin ice wait"0c" atload"_zsh_autosuggest_start" lucid
zplugin light zsh-users/zsh-autosuggestions
zplugin ice wait"1" atinit"ZPLGM[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" lucid
zplugin light zdharma/fast-syntax-highlighting

# Disabled - as the user probably doesn't have access to this plugin
# that's only available to the patreon.com Patrons
: zplugin ice wait"1" from:gl lucid
: zplugin load psprint/fsh-auto-themes

# ogham/exa, replacement for ls
zplugin ice  wait'2' lucid from"gh-r" as"command" mv"exa* -> exa"
zplugin light ogham/exa

# vramsteg
zplugin ice wait"2" lucid as'command' pick'src/vramsteg' \
            atclone'cmake .' atpull'%atclone' make
zplugin load psprint/vramsteg-zsh

# zsh-diff-so-fancy
zplugin ice wait"2" lucid as"program" pick"bin/git-dsf"
zplugin load zdharma/zsh-diff-so-fancy

# git-now
zplugin ice wait"2" lucid as"program" pick"$ZPFX/bin/git-now" make"prefix=$ZPFX install"
zplugin load iwata/git-now

# git-extras
zplugin ice wait"2" lucid as"program" pick"$ZPFX/bin/git-alias" make"PREFIX=$ZPFX"
zplugin load tj/git-extras

# git-cal
zplugin ice wait"2" lucid as"program" atclone'perl Makefile.PL PREFIX=$ZPFX' \
    atpull'%atclone' make'install' pick"$ZPFX/bin/git-cal"
zplugin load k4rthik/git-cal

# git-url
zplugin ice wait"2" lucid as"program" pick"$ZPFX/bin/git-(url|guclone)" make"install PREFIX=$ZPFX GITURL_NO_CGITURL=1"
zplugin load zdharma/git-url

# git-recall
zplugin ice wait"3" lucid pick"git-recall" as"command"
zplugin load Fakerr/git-recall

# git-quick-stats
zplugin ice wait"3" lucid make"PREFIX=$ZPFX install" as"command" \
    pick"$ZPFX/bin/git-quick-stats" \
    atload"export _MENU_THEME=legacy"
zplugin load arzzen/git-quick-stats.git

# zsh-tag-search
zplugin ice wait lucid bindmap'^R -> ^G'
zplugin load ~/gitlab/zsh-tag-search.git

: zplugin ice wait blockf lucid
: zplugin light marzocchi/zsh-notify
: zplugin ice wait lucid
: zplugin light rimraf/k
: zplugin light zsh-users/zsh-syntax-highlighting
: zplugin ice load'![[ $PWD = */github/* ]]' unload'![[ $PWD != */github/* ]]'
: zplugin light denysdovhan/spaceship-zsh-theme
: zplugin ice wait"1"
: zplugin load b4b4r07/zsh-vimode-visual

zflai-msg "[zshrc] Zplugin block took ${(M)$(( SECONDS * 1000 ))#*.?} ms"

MYPROMPT=1

#
# Zstyles & other
#

zle -N znt-kill-widget
bindkey "^Y" znt-kill-widget

cdpath=( "$HOME/github" "$HOME/github2" "$HOME/gitlab" )

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ":completion:*:descriptions" format "%B%d%b"
zstyle ':completion:*:*:*:default' menu yes select search
zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”

function double-accept { deploy-code "BUFFER[-1]=''"; }
zle -N double-accept
bindkey -M menuselect '^F' history-incremental-search-forward
bindkey -M menuselect '^R' history-incremental-search-backward
bindkey -M menuselect ' ' double-accept

function mem() { ps -axv | grep $$ }

# added by travis gem
[ -f /Users/sgniazdowski/.travis/travis.sh ] && source /Users/sgniazdowski/.travis/travis.sh

export GOPATH="/Users/sgniazdowski/go"

zflai-msg "[zshrc] Finishing, loaded custom modules: ${(j:, :@)${(k)modules[@]}:#zsh/*}"
