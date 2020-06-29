#
# Exports
#

module_path+=("$HOME/.zinit/bin/zmodules/Src"); zmodload zdharma/zplugin &>/dev/null

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

setopt interactive_comments hist_ignore_dups  octal_zeroes   no_prompt_cr
setopt no_hist_no_functions no_always_to_end  append_history list_packed
setopt inc_append_history   complete_in_word  no_auto_menu   auto_pushd
setopt pushd_ignore_dups    no_glob_complete  no_glob_dots   c_bases
setopt numeric_glob_sort    no_share_history  promptsubst    auto_cd
setopt rc_quotes            extendedglob      notify

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
#alias ls="gls -bh --color=auto"
alias ls="exa -bh --color=auto"
alias l="ls"      l.='ls -d .*'   la='ls -a'   ll='ls -lbt created'  rm='command rm -i'
alias df='df -h'  du='du -h'      cp='cp -v'   mv='mv -v'      plast="last -20"
alias reload="exec $SHELL -l -i"  grep="command grep --colour=auto --binary-files=without-match --directories=skip"
alias lynx="command lynx -accept-all-cookies"  ult="ulimit -c 195312; echo $$"
ulimit -c unlimited

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

alias newest_ls="ls -lh --sort date -r --color=always | head -25"
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
    if [ "$altxt" != "${altxt#ls=\'(ls|exa)}" ]; then
        altxt=${altxt#ls=\'exa}
        altxt=${altxt%\'}
        altxt="ls=psls$altxt"
        alias "$altxt"
        zflai-msg "[zshrc] \`ls' alias: $altxt"
    fi
else
    alias ls="psls"
    zflai-msg "[zshrc] \`ls' alias: ls=psls"
fi

unset altxt

fpath+=( $HOME/functions )

autoload -Uz psprobe_host   psffconv    pssetup_ssl_cert    psrecompile    pscopy_xauth  \
             psls           pslist      psfind \
             mandelbrot     optlbin_on  optlbin_off         localbin_on    localbin_off    g1all   g1zip \
             zman \
             t1uncolor 	    t1fromhex   t1countdown \
             f1rechg_x_min  f1biggest \
             n1gglinks      n1dict      n1diki              n1gglinks      n1ggw3m         n1ling  n1ssl_tunnel \
	     n1ssl_rtunnel  \
             pngimage       deploy-code deploy-message

autoload +X zman
functions[zzman]="${functions[zman]}"
function run_diso {
  sh -c "$@" &
  disown
}

function pbcopydir {
  pwd | tr -d "\r\n" | pbcopy
}

function from-where {
    echo $^fpath/$_comps[$1](N)
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

#PS1="READY > "
zstyle ":plugin:zconvey" greeting "none"
zstyle ':notify:*' command-complete-timeout 3
zstyle ':notify:*' notifier plg-zsh-notify

palette() { local colors; for n in {000..255}; do colors+=("%F{$n}$n%f"); done; print -cP $colors; }

# Run redis-server port forwarding, from the public 3333 port
#n1ssl_rtunnel 3333 localhost 4815 zredis.pem zredis_client.crt &!
zflai-msg "[zshrc] ssl tunnel PID: $!"

#
# Zplugin
#

typeset -F4 SECONDS=0

[[ ! -f ~/.zinit/bin/zinit.zsh ]] && {
    command mkdir -p ~/.zinit
    command git clone https://github.com/zdharma/zinit ~/.zinit/bin
}

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Zplugin annexes
# zinit-zsh/z-a-man \
zinit light-mode for \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-submods \
    zinit-zsh/z-a-bin-gem-node \
    zinit-zsh/z-a-rust

# Fast-syntax-highlighting & autosuggestions
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
    zdharma/fast-syntax-highlighting \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
 blockf \
    zsh-users/zsh-completions

# lib/git.zsh is loaded mostly to stay in touch with the plugin (for the users)
# and for the themes 2 & 3 (lambda-mod-zsh-theme & lambda-gitster)
zinit wait lucid for \
    zdharma/zsh-unique-id \
    OMZ::lib/git.zsh \
 atload"unalias grv g" \
    OMZ::plugins/git/git.plugin.zsh

# Theme no. 1 - zprompts
zinit lucid \
 load'![[ $MYPROMPT = 1 ]]' \
 unload'![[ $MYPROMPT != 1 ]]' \
 atload'!promptinit; typeset -g PSSHORT=0; prompt sprint3 yellow red green blue' \
 nocd for \
    psprint/zprompts

# Theme no. 2 – lambda-mod-zsh-theme
zinit lucid load'![[ $MYPROMPT = 2 ]]' unload'![[ $MYPROMPT != 2 ]]' nocd for \
    halfo/lambda-mod-zsh-theme

# Theme no. 3 – lambda-gitster
zinit lucid load'![[ $MYPROMPT = 3 ]]' unload'![[ $MYPROMPT != 3 ]]' nocd for \
    ergenekonyigit/lambda-gitster

# Theme no. 4 – geometry
zinit lucid load'![[ $MYPROMPT = 4 ]]' unload'![[ $MYPROMPT != 4 ]]' \
 atload'!geometry::prompt' nocd \
 atinit'GEOMETRY_COLOR_DIR=63 GEOMETRY_PATH_COLOR=63' for \
    geometry-zsh/geometry

# Theme no. 5 – pure
zinit lucid load'![[ $MYPROMPT = 5 ]]' unload'![[ $MYPROMPT != 5 ]]' \
 pick"/dev/null" multisrc"{async,pure}.zsh" atload'!prompt_pure_precmd' nocd for \
    sindresorhus/pure

# Theme no. 6 - agkozak-zsh-theme
zinit lucid load'![[ $MYPROMPT = 6 ]]' unload'![[ $MYPROMPT != 6 ]]' \
 atload'!_agkozak_precmd' nocd atinit'AGKOZAK_FORCE_ASYNC_METHOD=subst-async' for \
    agkozak/agkozak-zsh-theme

# Theme no. 7 - zinc
zinit load'![[ $MYPROMPT = 7 ]]' unload'![[ $MYPROMPT != 7 ]]' \
 compile"{zinc_functions/*,segments/*,zinc.zsh}" nocompletions \
 atload'!prompt_zinc_setup; prompt_zinc_precmd' nocd for \
    robobenklein/zinc

# Theme no. 8 - git-prompt
zinit lucid load'![[ $MYPROMPT = 8 ]]' unload'![[ $MYPROMPT != 8 ]]' \
 atload'!_zsh_git_prompt_precmd_hook' nocd for \
    woefe/git-prompt.zsh

# zunit, color
zinit wait"2" lucid as"null" for \
 sbin atclone"./build.zsh" atpull"%atclone" \
    molovo/zunit \
 sbin"color.zsh -> color" \
    molovo/color

# revolver
zinit wait"2" lucid as"program" pick"revolver" for psprint/revolver

zinit pack for dircolors-material

# Zconvey shell integration plugin
zinit wait lucid \
 sbin"cmds/zc-bg-notify" sbin"cmds/plg-zsh-notify" for \
    zdharma/zconvey

# zsh-startify, a vim-startify like plugin
: zinit wait"0b" lucid atload"zsh-startify" for zdharma/zsh-startify
: zinit wait lucid pick"manydots-magic" compile"manydots-magic" for knu/zsh-manydots-magic

# remark
zinit pack for remark

# zsh-autopair
# fzf-marks, at slot 0, for quick Ctrl-G accessibility
zinit wait lucid for \
    hlissner/zsh-autopair \
    urbainvaes/fzf-marks

# A few wait"1 plugins
zinit wait"1" lucid for \
    psprint/zsh-navigation-tools \
 atinit'zstyle ":history-search-multi-word" page-size "7"' \
    zdharma/history-search-multi-word \
 atinit"local zew_word_style=whitespace" \
    psprint/zsh-editing-workbench

# Github-Issue-Tracker – the notifier thread
zinit lucid id-as"GitHub-notify" \
 on-update-of'~/.cache/zsh-github-issues/new_titles.log' \
 notify'New issue: $NOTIFY_MESSAGE' for \
    zdharma/zsh-github-issues

# Github-Issue-Tracker – the issue-puller thread
GIT_SLEEP_TIME=700
GIT_PROJECTS=zdharma/zsh-github-issues:zdharma/zinit

zinit wait"2" lucid service"GIT" \
 pick"zsh-github-issues.service.zsh" for \
    zdharma/zsh-github-issues

# Gitignore plugin – commands gii and gi
zinit wait"2" lucid trigger-load'!gi;!gii' \
 dl'https://gist.githubusercontent.com/psprint/1f4d0a3cb89d68d3256615f247e2aac9/raw -> templates/Zsh.gitignore' \
 for \
    voronkovich/gitignore.plugin.zsh

# F-Sy-H automatic themes – available for patrons
# https://patreon.com/psprint
: zinit wait"1" lucid from"psprint@gitlab.com" for psprint/fsh-auto-themes

# ogham/exa, sharkdp/fd, fzf
zinit wait"2" lucid as"null" from"gh-r" for \
    mv"exa* -> exa" sbin  ogham/exa \
    mv"fd* -> fd" sbin"fd/fd"  @sharkdp/fd

# fzf, fzy
zinit pack"bgn-binary" for fzf
zinit pack"bgn" for fzy

# A few wait'2' plugins
zinit wait"2" lucid for \
    zdharma/declare-zsh \
    zdharma/zflai \
 blockf \
    zdharma/zui \
    zinit-zsh/zinit-console \
 trigger-load'!crasis' \
    zdharma/zinit-crasis \
 atinit"forgit_ignore='fgi'" \
    wfxr/forgit

# git-cal
zinit wait"2" lucid as"null" \
 atclone'perl Makefile.PL PREFIX=$ZPFX' \
 atpull'%atclone' make sbin"git-cal" for \
    k4rthik/git-cal

# A few wait'3' git extensions
zinit as"null" wait"3" lucid for \
    sbin Fakerr/git-recall \
    sbin paulirish/git-open \
    sbin paulirish/git-recent \
    sbin davidosomething/git-my \
    sbin atload"export _MENU_THEME=legacy" \
        arzzen/git-quick-stats \
    sbin iwata/git-now \
    make"PREFIX=$ZPFX"         tj/git-extras \
    sbin"bin/git-dsf;bin/diff-so-fancy" zdharma/zsh-diff-so-fancy \
    sbin"git-url;git-guclone" make"GITURL_NO_CGITURL=1" zdharma/git-url

# fbterm
: zinit wait"3" lucid as"command" \
 pick"$ZPFX/bin/fbterm" \
 dl"https://bugs.archlinux.org/task/46860?getfile=13513 -> ins.patch" \
 dl"https://aur.archlinux.org/cgit/aur.git/plain/0001-Fix-build-with-gcc-6.patch?h=fbterm-git" \
 patch"ins.patch; 0001-Fix-build-with-gcc-6.patch" \
 atclone"./configure --prefix=$ZPFX" \
 atpull"%atclone" \
 make"install" reset for \
    izmntuk/fbterm

# asciinema
: zinit wait lucid as"command" \
 atinit"export PYTHONPATH=$ZPFX/lib/python3.7/site-packages/" \
 atclone"PYTHONPATH=$ZPFX/lib/python3.7/site-packages/ \
 python3 setup.py --quiet install --prefix $ZPFX" \
 atpull'%atclone' test'0' \
 pick"$ZPFX/bin/asciinema" for \
    asciinema/asciinema

# Notifications, configured to use zconvey
: zinit wait lucid for marzocchi/zsh-notify

zflai-msg "[zshrc] Zplugin block took ${(M)$(( SECONDS * 1000 ))#*.?} ms"

MYPROMPT=1

#
# Zstyles & other
#

zle -N znt-kill-widget
bindkey "^Y" znt-kill-widget

cdpath=( "$HOME" "$HOME/github" "$HOME/github2" "$HOME/gitlab" )

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ":completion:*:descriptions" format "%B%d%b"
zstyle ':completion:*:*:*:default' menu yes select search
#zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”

function double-accept { deploy-code "BUFFER[-1]=''"; }
zle -N double-accept
bindkey -M menuselect '^F' history-incremental-search-forward
bindkey -M menuselect '^R' history-incremental-search-backward
bindkey -M menuselect ' ' .accept-line

function mem() { ps -axv | grep $$  }

# added by travis gem
[ -f /Users/sgniazdowski/.travis/travis.sh ] && source /Users/sgniazdowski/.travis/travis.sh

export GOPATH="/Users/sgniazdowski/go"

zflai-msg "[zshrc] Finishing, loaded custom modules: ${(j:, :@)${(k)modules[@]}:#zsh/*}"
