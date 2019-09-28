### Added by Zplugin's installer
source ~/.zplugin/bin/zplugin.zsh
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin installer's chunk

##### BEGIN Zplugin stuff #####
### needs: exa, fzy, lua, python3

# autosuggestions, trigger precmd hook upon load
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
zplugin ice wait"0a" lucid atload"_zsh_autosuggest_start"
zplugin light zsh-users/zsh-autosuggestions

# z
zplugin ice wait"0b" lucid
zplugin light skywind3000/z.lua

# cd
zplugin ice wait"0b" lucid
zplugin light b4b4r07/enhancd
export ENHANCD_FILTER=fzy

# History substring searching
zplugin ice wait"0b" lucid
zplugin light zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Tab completions
zplugin ice wait"0b" lucid blockf
zplugin light zsh-users/zsh-completions

# Syntax highlighting must be loaded last
zplugin ice wait"0c" lucid atinit"zpcompinit;zpcdreplay"
zplugin light zdharma/fast-syntax-highlighting

##### END Zplugin stuff #####

##### BEGIN zshrc generic #####

# Easy directory navigation
setopt autocd autopushd pushdignoredups
alias d='dirs -v | head -10'
alias b='pushd +1 > /dev/null'
alias 1='pushd +1 > /dev/null'
alias 2='pushd +2 > /dev/null'
alias 3='pushd +3 > /dev/null'
alias 4='pushd +4 > /dev/null'
alias 5='pushd +5 > /dev/null'
alias 6='pushd +6 > /dev/null'
alias 7='pushd +7 > /dev/null'
alias 8='pushd +8 > /dev/null'
alias 9='pushd +9 > /dev/null'

# Navigating backward/forward in command
bindkey '\e\e[D' backward-word
bindkey '\e\e[C' forward-word
bindkey '^[a' beginning-of-line
bindkey '^[e' end-of-line

# ctrl-W deletes up to a space OR '/'
export WORDCHARS=''

# Better ls
alias ls='exa'

# Path
export PATH=~/bin:$PATH

# Coloring
autoload colors && colors

##### END zshrc generic #####

##### BEGIN Mac specific #####

# iTerm2
source "${HOME}/.iterm2_shell_integration.zsh"
function it2setbadge() {
  printf "\e]1337;SetBadgeFormat=%s\a" $(echo -n "$1" | base64)
}

# Basic ENV Variables
export EDITOR=code

# Scripting ENV variables
export gLinux='jubi.sea.corp.google.com'
export cloudtop='jubishop.c.googlers.com'
export gLinuxMount='~/Desktop/gLinux'
export cloudtopMount='~/Desktop/Cloudtop'
export remoteHomeDir='/usr/local/google/home/jubi'
export remoteSrcDir='/google/src/cloud/jubi'

# SSH Helpers
function gssh() {
  ~/.iterm2/it2setcolor tab 000099
  ~/.iterm2/it2setcolor preset 'gLinuxPreset'
  it2setbadge $2
  ssh $1
  ~/.iterm2/it2setcolor tab default
  ~/.iterm2/it2setcolor preset 'MacPreset'
  it2setbadge Macbook
}
alias sshome="gssh $gLinux gLinux"
alias sshcloudtop="gssh $cloudtop Cloudtop"

# Prompt
# black, red, green, yellow, blue, magenta, cyan, white
PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )%{$reset_color%}"
PROMPT+="%{$fg[blue]%}Macbook%{$fg[white]%}:%{$fg[yellow]%}%3~"
PROMPT+="%{$fg_bold[green]%}#>%{$reset_color%}"

##### END Mac specific #####
