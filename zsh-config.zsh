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

# Theme setup. 

# fpath+=($SHELL_CONFIG_DIR/pure)
# autoload -U promptinit; promptinit
# prompt pure

LP_PATH_METHOD="truncate_chars_from_dir_middle"
LP_ENABLE_TIME=1
LP_ENABLE_TEMP=0

#########################################


#########################################
# History settings.

source ${SHELL_CONFIG_DIR}/history_setup.zsh

#########################################


######################################
# Configure and Enable CD history.

setopt AUTO_CD # the option for cd without typing cd


# source: https://unix.stackexchange.com/a/157773
setopt AUTO_PUSHD                  # pushes the old directory onto the stack
# PushHD Minus is a matter of persional taste, and I don't think this change anything on my machine.
# setopt PUSHD_MINUS                 # exchange the meanings of '+' and '-'
setopt CDABLE_VARS                 # expand the expression (allows 'cd -2/<subfolder>')

zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'

# Short cuts to remember:

# ctrl q : push-input - push the entire input (multi-line) onto a stach. And pop back into 
# command prompt after a command
# explain: https://sgeb.io/posts/bash-zsh-half-typed-commands/

######################################


#########################################
# Key binding setup

bindkey -e # This set the keymapping style to emacs.

# These are for ctrl+arrow key
bindkey '\e[1;5C' forward-word   # Ctrl+Right
bindkey '\e[1;5D' backward-word  # Ctrl+Left

bindkey '\e[H'  beginning-of-line   # Home
bindkey '\e[F'  end-of-line         # End


# Copied from on my zsh

# [Delete] - delete forward
if [[ -n "${terminfo[kdch1]}" ]]; then
  bindkey "${terminfo[kdch1]}" delete-char
else
  bindkey "^[[3~" delete-char

  bindkey "^[3;5~" delete-char
fi
# [Ctrl-Delete] - delete whole forward-word
bindkey '^[[3;5~' kill-word

# Start typing + [Up-Arrow] - fuzzy find history forward
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search
if [[ -n "${terminfo[kcuu1]}" ]]; then
  bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

# Start typing + [Down-Arrow] - fuzzy find history backward
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[B" down-line-or-beginning-search
if [[ -n "${terminfo[kcud1]}" ]]; then
  bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey "${terminfo[kcbt]}" reverse-menu-complete
fi
## This is replacement for COMPLETION_WAITING_DOTS="true"
# Print dots when ZSH is generating completeion options.
# AI generated code.
expand-or-complete-with-dots() {
  echo -n "\e[31m...\e[0m"   # Print red dots
  zle expand-or-complete      # Call the default completion
  zle redisplay               # Refresh the prompt
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots   # Bind Tab to the new widget




# Setup for promp styling. 

## replaces  HYPHEN_INSENSITIVE="true"

zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Z}' \
  'r:|=*' \
  'm:{-_}={_-}'

zstyle ':completion:*' completer _expand _complete _ignored _match _approximate _prefix
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu select=1
zstyle ':completion:*' prompt 'potentional of %e error detected'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' substitute 1


setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt LONG_LIST_JOBS
setopt INTERACTIVE_COMMENTS # Allow comments # be used in interactive shell

# Source: https://superuser.com/a/982399
# This change the default NOMATCH to off, 
# and pass the glob down instead of throwing error
setopt NO_NOMATCH 


######################################

# All setting related to the promp itself and zsh internal settings are done !

autoload -Uz compinit
compinit


######################################
# special fix for systemd 
_systemctl_unit_state() {
  typeset -gA _sys_unit_state
  _sys_unit_state=( $(__systemctl list-unit-files "$PREFIX*" | awk '{print $1, $2}') ) }
######################################


######################################
# Source my custom helper 
# These need to be sourced early so I can use the inner functions
source ${SHELL_CONFIG_DIR}/setup-shell-helpers.sh
######################################


######################################
# External tools, changing system editor/pager/etc

export EDITOR='micro' # always default to micro first
# Setting for using editor
if [[ -z ${SSH_CONNECTION+x} ]]; then
  # # Case of non ssh, try to use vscode as editor
  # [ -n $(command -v code) ] && export EDITOR='code --wait'
   # 
   export EDITOR='micro'
else
  # Case of ssh connection
  LIBGL_ALWAYS_INDIRECT=1
fi

# Change pager to most if it exists
if type most > /dev/null; then
  export PAGER="most"
fi

# enable mcfly
if type mcfly > /dev/null; then
  eval "$(mcfly init zsh)"
  export MCFLY_FUZZY=2
  export MCFLY_RESULTS=30
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

# Add emcas bin folder if exits
if [ -d "$HOME/.config/emacs/bin" ] ; then 
  PATH="$HOME/.config/emacs/bin:$PATH"
fi 

######################################


######################################
# Alias 

alias pssh="parallel-ssh"
alias bat="batcat"
alias ls='ls --color=auto' # This adds good color to ls output
######################################


######################################
# Additional notes:

# To get python arg completion, the following packages are needed 
# argcomplete
# Then this command needs to be executed to register into zshenv `activate-global-python-argcomplete`

# To get rclone tab complete, 
# sudo rclone genautocomplete zsh
# Also if not done before, `/usr/share/zsh/vendor-completions` folder needs to be manually created.
######################################
