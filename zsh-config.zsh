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

export ZSH="/home/$USER/.oh-my-zsh"

ZSH_THEME_RANDOM_CANDIDATES=(
    "avit" "bira" "fishy" "gnzh")
ZSH_THEME=random

HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"

source $ZSH/oh-my-zsh.sh
######################################


######################################
# SSH related settings 

export EDITOR='${HOME}/micro' # always default to micro first
# Setting for using editor
if [[ -z ${SSH_CONNECTION+x} ]]; then
  # Case of non ssh, try to use vscode as editor
  [ -n $(command -v code) ] && export EDITOR='code --wait' 
else
  # Case of ssh connection
  LIBGL_ALWAYS_INDIRECT=1
fi
######################################


######################################
# special fix for systemd 
_systemctl_unit_state() {
  typeset -gA _sys_unit_state
  _sys_unit_state=( $(__systemctl list-unit-files "$PREFIX*" | awk '{print $1, $2}') ) }
######################################


######################################
# Source my custom helper 
source ${SHELL_CONFIG_DIR}/setup-shell-helpers.sh
######################################
