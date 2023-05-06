#! /bin/zsh

# SHELL_CONFIG_DIR this need to point to the repo folder this file is in. The scirpt rely on this 
# to find relative file location

[ -z ${SHELL_CONFIG_DIR+x} ] && SHELL_CONFIG_DIR="$(dirname $(realpath $0))"


#########################################
# Setup antigen
source ${SHELL_CONFIG_DIR}/antigen.zsh
antigen init ${SHELL_CONFIG_DIR}/antigenrc
#########################################


#########################################
# These are settings for oh my zsh

export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME_RANDOM_CANDIDATES=(
    "avit" "bira" "fishy" "gnzh")
ZSH_THEME=random

HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"

source $ZSH/oh-my-zsh.sh
######################################

######################################
# Configure and Enable CD history.
# source: https://unix.stackexchange.com/a/157773
setopt AUTO_PUSHD                  # pushes the old directory onto the stack
# PushHD Minus is a matter of persional taste, and I don't think this change anything on my machine.
# setopt PUSHD_MINUS                 # exchange the meanings of '+' and '-'
setopt CDABLE_VARS                 # expand the expression (allows 'cd -2/<subfolder>')
autoload -U compinit && compinit   # load + start completion
zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'
######################################

######################################
# special fix for systemd 
_systemctl_unit_state() {
  typeset -gA _sys_unit_state
  _sys_unit_state=( $(__systemctl list-unit-files "$PREFIX*" | awk '{print $1, $2}') ) }
######################################



######################################
# External tools, changing system editor/pager/etc

export EDITOR='${HOME}/micro' # always default to micro first
# Setting for using editor
if [[ -z ${SSH_CONNECTION+x} ]]; then
  # Case of non ssh, try to use vscode as editor
  [ -n $(command -v code) ] && export EDITOR='code --wait' 
else
  # Case of ssh connection
  LIBGL_ALWAYS_INDIRECT=1
fi

# Change pager to most if it exists
if type most > /dev/null; then
  export PAGER="most"
fi

# enable mcfly
if type most > /dev/null; then
  eval "$(mcfly init zsh)"
fi 
######################################

######################################

# Section for adding additional PATH.

# Seems like zsh doesnt auto add ~/.local/bin
# set PATH so it includes user's private ~/.local/bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Specific one for rust cargo
if [ -f "$HOME/.cargo/env" ] ; then
  source "$HOME/.cargo/env"
fi

######################################

######################################
# Source my custom helper 
source ${SHELL_CONFIG_DIR}/setup-shell-helpers.sh
######################################

