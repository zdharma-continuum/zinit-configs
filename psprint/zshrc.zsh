#
# Exports
#

module_path+=("$HOME/.zplugin/bin/zmodules/Src"); zmodload zdharma/zplugin

typeset -g HISTSIZE=290000 SAVEHIST=290000 HISTFILE=~/.zhistory ABSD=1

typeset -ga mylogs
zflai-msg() { mylogs+=( "$1" ); }
zflai-assert() { mylogs+=( "$4"${${${1:#$2}:+FAIL}:-OK}": $3" ); }

(( ABSD )) && {
    export LSCOLORS=dxfxcxdxbxegedabagacad CLICOLOR="1" 
    export ANDROID_ROOT=/opt/android
}

if [[ -x /usr/bin/dircolors ]]; then
    typeset -g DIRCPATH="/usr/bin/dircolors"
elif [[ -x /usr/local/bin/dircolors ]]; then
    typeset -g DIRCPATH="/usr/local/bin/dircolors"
else
    typeset -g DIRCPATH="/usr/bin/false"
fi

if [[ -f /etc/DIR_COLORS ]]; then
    builtin eval `$DIRCPATH -b /etc/DIR_COLORS`
    zflai-msg "[zshrc] dircolors at $DIRCPATH, using /etc/DIR_COLORS"
else
    builtin eval `$DIRCPATH`
    zflai-msg "[zshrc] dircolors at $DIRCPATH, no DIR_COLORS file"
fi

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
	     n1ssl_rtunnel

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
n1ssl_rtunnel 3333 localhost 4815 zredis.pem zredis_client.crt &!
zflai-msg "[zshrc] ssl tunnel PID: $!"

#
# Zplugin
#

typeset -F4 SECONDS=0

source "$HOME/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

repeat 1; do

zplugin load zdharma/zsh-unique-id

zplugin ice wait"0" lucid
zplugin snippet OMZ::lib/git.zsh

zplugin ice wait"0" svn atload"unalias grv g" lucid
zplugin snippet OMZ::plugins/git

zplugin ice wait'0b' lucid atload'zsh-startify'
zplugin load zdharma/zsh-startify

# Note the `g' prefix to the tools – because I'm on OS X using
# Homebrew installed coreutils
zplugin ice wait'0c' lucid atclone"git reset --hard; gsed -i '/DIR/c\DIR                   38;5;63;1' LS_COLORS; gdircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!'
zplugin light trapd00r/LS_COLORS

zplugin ice wait"0" silent
zplugin load zdharma/zconvey

zplugin ice pick"cmds/zc-bg-notify" as"command" wait"0" id-as'zconvey-cmd' silent
zplugin load zdharma/zconvey

zplugin ice wait'1' atload'ztie -d db/redis -a 127.0.0.1:4815/5 -P $HOME/.zredisconf -zSL main rdhash' lucid
zplugin load zdharma/zredis
zplugin ice service"redis" lucid wait"1"
zplugin light zservices/redis

zplugin ice wait"0" lucid
zplugin load psprint/zsh-editing-workbench
zplugin ice wait"0" lucid
zplugin load psprint/zsh-navigation-tools   # for n-history

zstyle ":history-search-multi-word" page-size "11"
zplugin ice wait"1" lucid
zplugin load zdharma/history-search-multi-word

zplugin ice load'![[ $MYPROMPT = 1 ]]' unload'![[ $MYPROMPT != 1 ]]' atload'!promptinit; typeset -g PSSHORT=0; prompt sprint3' lucid
zplugin load psprint/zprompts
zplugin ice load'![[ $MYPROMPT = 2 ]]' unload'![[ $MYPROMPT != 2 ]]' lucid
zplugin load halfo/lambda-mod-zsh-theme
zplugin ice load'![[ $MYPROMPT = 3 ]]' unload'![[ $MYPROMPT != 3 ]]' lucid
zplugin load ergenekonyigit/lambda-gitster

GEOMETRY_COLOR_DIR=63 GEOMETRY_PATH_COLOR=63
zplugin ice load'![[ $MYPROMPT = 4 ]]' unload'![[ $MYPROMPT != 4 ]]' atload"prompt_geometry_render" lucid
zplugin load geometry-zsh/geometry
#zplugin ice load'![[ $MYPROMPT = 4 ]]' unload'![[ $MYPROMPT != 4 ]]' atload"geometry::clear_title; geometry::prompt; geometry::rprompt" lucid # ver"mnml"
#zplugin load jedahan/geometry

zplugin ice ice load'![[ $MYPROMPT = 5 ]]' unload'![[ $MYPROMPT != 5 ]]' \
             multisrc"{async,pure}.zsh" pick"/dev/null" idas"my/pure/login"; zplugin load sindresorhus/pure

AGKOZAK_FORCE_ASYNC_METHOD=subst-async
zplugin ice ice load'![[ $MYPROMPT = 6 ]]' unload'![[ $MYPROMPT != 6 ]]' lucid
zplugin load agkozak/agkozak-zsh-theme

zplugin ice wait"1" lucid
zplugin load zdharma/zui
zplugin ice wait'[[ -n ${ZLAST_COMMANDS[(r)cras*]} ]]' lucid
zplugin load zdharma/zplugin-crasis

zplugin ice wait"2" lucid
zplugin load voronkovich/gitignore.plugin.zsh

#ZSH_AUTOSUGGEST_USE_ASYNC=1
zplugin ice wait"0" atload"_zsh_autosuggest_start" lucid
zplugin load zsh-users/zsh-autosuggestions
zplugin ice wait"1" atinit"ZPLGM[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" zatinit"FAST_WORK_DIRS=XDG; zpcompinit; zpcdreplay" lucid
zplugin load zdharma/fast-syntax-highlighting

zplugin ice wait"1" from:gl lucid
zplugin load psprint/fsh-auto-themes

# ogham/exa, replacement for ls
zplugin ice from"gh-r" as"command" mv"exa* -> exa" wait'2' lucid
zplugin light ogham/exa

# vramsteg
zplugin ice wait"2" lucid as'command' pick'src/vramsteg' atclone'cmake .' atpull'%atclone' make
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
zplugin ice wait"2" lucid as"program" atclone'perl Makefile.PL PREFIX=$ZPFX' atpull'%atclone' \
            make'install' pick"$ZPFX/bin/git-cal"
zplugin load k4rthik/git-cal

# git-url
zplugin ice wait"2" lucid as"program" pick"$ZPFX/bin/git-(url|guclone)" make"install PREFIX=$ZPFX"
zplugin load zdharma/git-url

# git-recall
zplugin ice wait"3" lucid pick"git-recall" as"command"
zplugin load Fakerr/git-recall

: zplugin ice wait"0" blockf lucid
: zplugin light marzocchi/zsh-notify
: zplugin ice wait"0" lucid
: zplugin light rimraf/k
: zplugin light zsh-users/zsh-syntax-highlighting
: zplugin ice load'![[ $PWD = */github/* ]]' unload'![[ $PWD != */github/* ]]'
: zplugin light denysdovhan/spaceship-zsh-theme
: zplugin ice wait"1"
: zplugin load b4b4r07/zsh-vimode-visual

zflai-msg "[zshrc] Zplugin block took ${(M)$(( SECONDS * 1000 ))#*.?} ms"

MYPROMPT=1

done

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

function double-accept { accept-line; accept-line; }
zle -N double-accept
bindkey -M menuselect '^F' history-incremental-search-forward
bindkey -M menuselect '^R' history-incremental-search-backward
bindkey -M menuselect ' ' double-accept

function mem() { ps -axv | grep $$ }

# added by travis gem
[ -f /Users/sgniazdowski/.travis/travis.sh ] && source /Users/sgniazdowski/.travis/travis.sh

export GOPATH="/Users/sgniazdowski/go"

zflai-msg "[zshrc] Finishing, loaded custom modules: ${(j:, :@)${(k)modules[@]}:#zsh/*}"
