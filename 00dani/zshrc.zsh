#! zsh

export XDG_CACHE_HOME=${XDG_CACHE_HOME:=~/.cache}

typeset -A ZINIT
ZINIT_HOME=$XDG_CACHE_HOME/zsh/zinit
ZINIT[HOME_DIR]=$ZINIT_HOME
ZINIT[ZCOMPDUMP_PATH]=$XDG_CACHE_HOME/zsh/zcompdump

if [[ ! -f $ZINIT_HOME/bin/zinit.zsh ]]; then
	git clone https://github.com/psprint/zinit $ZINIT_HOME/bin
	zcompile $ZINIT_HOME/bin/zinit.zsh
fi
source $ZINIT_HOME/bin/zinit.zsh
load=light

zinit $load willghatch/zsh-saneopt

zinit $load mafredri/zsh-async
zinit $load rupa/z
zinit $load sindresorhus/pure

zinit ice nocompile:! pick:c.zsh atpull:%atclone atclone:'dircolors -b LS_COLORS > c.zsh'
zinit $load trapd00r/LS_COLORS

zinit ice silent wait:1 atload:_zsh_autosuggest_start
zinit $load zsh-users/zsh-autosuggestions

zinit ice blockf; zinit $load zsh-users/zsh-completions

zinit ice silent wait:1; zinit $load mollifier/cd-gitroot
zinit ice silent wait:1; zinit $load micha/resty
zinit ice silent wait:1; zinit $load supercrabtree/k

zinit ice silent wait!1 atload"ZINIT[COMPINIT_OPTS]=-C; zpcompinit"
zinit $load zdharma/fast-syntax-highlighting
