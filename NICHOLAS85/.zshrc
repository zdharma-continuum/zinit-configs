# https://github.com/NICHOLAS85/dotfiles/blob/xps_13_9365_refresh/.zshrc

# Change shell behavior when opening the terminal view in dolphin. MYPROMPT set by konsole profile
if ! [[ $MYPROMPT = dolphin ]]; then
    isdolphin=false
    # Use chpwd_recent_dirs to start new sessions from last working dir
    # Populate dirstack with chpwd history
    autoload -Uz chpwd_recent_dirs add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':chpwd:*' recent-dirs-file "${TMPDIR:-/tmp}/chpwd-recent-dirs"
    dirstack=($(awk -F"'" '{print $2}' ${$(zstyle -L ':chpwd:*' recent-dirs-file)[4]} 2>/dev/null))
    [[ ${PWD} = ${HOME}  || ${PWD} = "." ]] && (){
        local dir
        for dir ($dirstack){
            [[ -d "${dir}" ]] && { cd -q "${dir}"; break }
        }
    } 2>/dev/null
else
    isdolphin=true
fi

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-${HOME}/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-${HOME}/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZINIT_HOME="${ZINIT_HOME:-${ZPLG_HOME:-${ZDOTDIR:-${HOME}}/.zinit}}"
ZINIT_BIN_DIR_NAME="${${ZINIT_BIN_DIR_NAME:-${ZPLG_BIN_DIR_NAME}}:-bin}"
### Added by Zinit's installer
if [[ ! -f "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}/zinit.zsh" ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "${ZINIT_HOME}" && command chmod g-rwX "${ZINIT_HOME}"
    command git clone https://github.com/zdharma/zinit "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "${ZINIT_HOME}/${ZINIT_BIN_DIR_NAME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

# A binary Zsh module which transparently and automatically compiles sourced scripts
module_path+=( "${HOME}/.zinit/bin/zmodules/Src" )
zmodload zdharma/zplugin &>/dev/null

# Functions to make configuration less verbose
# zt() : First argument is a wait time and suffix, ie "0a". Anything that doesn't match will be passed as if it were an ice mod. Default ices depth'3' and lucid
zt(){ zinit depth'3' lucid ${1/#[0-9][a-c]/wait"${1}"} "${@:2}"; }

##################
#    Annexes     #
# Config source  #
#     Prompt     #
##################

zt light-mode blockf svn id-as for \
        https://github.com/NICHOLAS85/dotfiles/trunk/.zinit/snippets/config

# zcompile doesn't support Unicode file names, planned on using compile'*handler' ice.
# https://www.zsh.org/mla/workers/2020/msg01057.html
zt light-mode for \
        zinit-zsh/z-a-patch-dl \
        zinit-zsh/z-a-submods \
        NICHOLAS85/z-a-linkman \
        NICHOLAS85/z-a-linkbin

(){ # Load $MYPROMPT configuration and powerlevel10k
    if [[ -f "${thmf}/${1}-pre.zsh" || -f "${thmf}/${1}-post.zsh" ]] && {
        zt light-mode for \
                romkatv/powerlevel10k \
            id-as"${1}-theme" \
            atinit"[[ -f ${thmf}/${1}-pre.zsh ]] && source ${thmf}/${1}-pre.zsh" \
            atload"[[ -f ${thmf}/${1}-post.zsh ]] && source ${thmf}/${1}-post.zsh" \
                zdharma/null
    } || print -P "%F{220}Theme \"${1}\" not found%f"
} "${MYPROMPT=p10k}"

###########
# Plugins #
###########

######################
# Trigger-load block #
######################

zt light-mode for \
    trigger-load'!x' svn \
        OMZ::plugins/extract \
    trigger-load'!man' \
        ael-code/zsh-colored-man-pages \
    trigger-load'!ga;!grh;!glo;!gd;!gcf;!gclean;!gss;!gcp' \
        wfxr/forgit \
    trigger-load'!zshz' blockf \
        agkozak/zsh-z \
    trigger-load'!updatelocal' blockf compile'f*/*~*.zwc' \
        NICHOLAS85/updatelocal \
    trigger-load'!zhooks' \
        agkozak/zhooks \
    trigger-load'!gcomp' blockf \
    atclone'command rm -rf lib/*;git ls-files -z lib/ |xargs -0 git update-index --skip-worktree' \
    submods'RobSis/zsh-completion-generator -> lib/zsh-completion-generator;
    nevesnunes/sh-manpage-completions -> lib/sh-manpage-completions' \
    atload' gcomp(){gencomp "${@}" && zinit creinstall -q ${ZINIT[SNIPPETS_DIR]}/config 1>/dev/null}' \
         Aloxaf/gencomp

##################
# Wait'0a' block #
##################

zt 0a light-mode for \
        OMZL::history.zsh \
        OMZP::systemd/systemd.plugin.zsh \
        OMZP::sudo/sudo.plugin.zsh \
    atload'zstyle ":completion:*" special-dirs false' \
        OMZL::completion.zsh \
    as'completion' atpull'zinit cclear' blockf \
        zsh-users/zsh-completions \
    as'completion' nocompile mv'*.zsh -> _git' patch"${pchf}/%PLUGIN%.patch" reset \
        felipec/git-completion \
    ver'develop' atload'_zsh_autosuggest_start' \
        zsh-users/zsh-autosuggestions

##################
# Wait'0b' block #
##################

zt 0b light-mode patch"${pchf}/%PLUGIN%.patch" reset nocompile'!' for \
    atload'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(__fz_zsh_completion)' \
        changyuheng/fz \
    atload'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(autopair-insert)' \
        hlissner/zsh-autopair \
    pack'no-dir-color-swap' atload"zstyle ':completion:*' list-colors \${(s.:.)LS_COLORS}" \
        trapd00r/LS_COLORS \
    atload'add-zsh-hook chpwd @chwpd_dir-history-var;
    add-zsh-hook zshaddhistory @append_dir-history-var; @chwpd_dir-history-var' \
        kadaan/per-directory-history \
    compile'h*' \
        zdharma/history-search-multi-word \
    trackbinds bindmap'\e[1\;6D -> ^[[1\;5B; \e[1\;6C -> ^[[1\;5A' \
        michaelxmcbride/zsh-dircycle \
    blockf nocompletions compile'functions/*~*.zwc' \
        marlonrichert/zsh-edit

zt 0b light-mode for \
    blockf compile'lib/*f*~*.zwc' \
        Aloxaf/fzf-tab \
    autoload'#manydots-magic' \
        knu/zsh-manydots-magic \
        RobSis/zsh-reentry-hook \
    atinit'zicompinit_fast; zicdreplay' atload'FAST_HIGHLIGHT[chroma-man]=' \
    atclone'(){local f;cd -q →*;for f (*~*.zwc){zcompile -Uz -- ${f}};}' \
    compile'.*fast*~*.zwc' nocompletions atpull'%atclone' \
        zdharma/fast-syntax-highlighting \
    pick'autoenv.zsh' nocompletions \
        Tarrasch/zsh-autoenv \
    atload'bindkey "${terminfo[kcuu1]}" history-substring-search-up;
    bindkey "${terminfo[kcud1]}" history-substring-search-down' \
        zsh-users/zsh-history-substring-search

##################
# Wait'0c' block #
##################

zt 0c light-mode binary from'gh-r' lman lbin for \
    lbin'**/gh' atclone'./**/gh completion --shell zsh > _gh' atpull'%atclone' \
        cli/cli \
    atclone'./just --completions zsh > _just' atpull'%atclone' \
        casey/just \
    bpick'*linux64*' \
        zyedidia/micro \
    atclone'mv -f **/*.zsh _bat' atpull'%atclone' \
        @sharkdp/bat \
        @sharkdp/hyperfine \
        @sharkdp/fd

zt 0c light-mode binary for \
    lbin \
        laggardkernel/git-ignore \
    lbin from'gh-r' \
        Peltoche/lsd \
    lbin'!' patch"${pchf}/%PLUGIN%.patch" reset \
        kazhala/dotbare

zt 0c light-mode null for \
    lbin'!**/winapps' patch"${pchf}/%PLUGIN%.patch" reset \
        Fmstrat/winapps \
    lbin'*d.sh;*n.sh' \
        bkw777/notify-send.sh \
    lbin'antidot* -> antidot' from'gh-r' atclone'./**/antidot* update 1>/dev/null' atpull'%atclone' \
        doron-cohen/antidot \
    lbin from'gh-r' bpick'*x_x86*' \
        charmbracelet/glow \
    lbin'nnn* -> nnn' from'gh-r' bpick'*nerd*' \
        jarun/nnn \
    lbin \
        paulirish/git-open \
    lbin'**/*nal;**/*nal-run' from'gh-r' \
        tycho-kirchner/shournal \
    lbin'*/delta;git-dsf' from'gh-r' patch"${pchf}/%PLUGIN%.patch" \
        dandavison/delta \
    lbin lman patch"${pchf}/%PLUGIN%.patch" reset \
        nateshmbhat/rm-trash \
    lbin from'gh-r' dl'https://raw.githubusercontent.com/junegunn/fzf/master/man/man1/fzf.1' lman \
        junegunn/fzf \
    id-as'Cleanup' nocd atinit'unset -f zt; _zsh_autosuggest_bind_widgets' \
        zdharma/null
