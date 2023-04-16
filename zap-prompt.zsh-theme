#!/usr/bin/env zsh

autoload -Uz vcs_info
autoload -U colors && colors

zstyle ':vcs_info:*' enable git 

precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

# Set cursor shape depending on Vi mode
function zle-line-init zle-keymap-select {
  echo -ne '\e['"${${KEYMAP/vicmd/1}/(main|viins|)/5}"' q'
}
local _set_default_cursor() { echo -ne '\e[5 q' ;}
precmd_functions+=(_set_default_cursor)

zle -N zle-line-init
zle -N zle-keymap-select
echo -ne '\e[5 q'

zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
# 
+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        hook_com[staged]+='!' # signify new files with a bang
    fi
}

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats " %{$fg[blue]%}(%{$fg[red]%}%m%u%c%{$fg[yellow]%}%{$fg[magenta]%} %b%{$fg[blue]%})%{$reset_color%}"

icon="🐧";
[[ $HOST =~ [Ff]rog ]] && icon="🐸"
[[ $HOST =~ [Rr]abbit ]] && icon="🐇"
[[ $HOST =~ [Bb]ee ]] && icon="🐝"
[[ $HOST =~ [Ee]lephant ]] && icon="🐘"
[ -f "/run/.toolboxenv" ] && icon="🧰"

PROMPT="%B%{$fg[yellow]%}${icon} % "                                      # icon
PROMPT+="%{$fg[cyan]%}%c%{$reset_color%}"                                 # current dir
PROMPT+="\$vcs_info_msg_0_"                                               # version control info
PROMPT+="%(?:%{$fg_bold[green]%} ❯:%{$fg_bold[red]%} ❯)%{$reset_color%} " # cursor char coloured by last command status

#vim:set filetype=zsh:syntax=zsh
