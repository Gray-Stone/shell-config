#! /bin/zsh
setopt EXTENDED_HISTORY # Also record time info in history.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_VERIFY # verify expansion arguments before executing.

# Where and how much history to keep
: ${HISTFILE:="$HOME/.zsh_history"}
HISTSIZE=100000          # in-memory history lines
SAVEHIST=100000           # lines saved to disk (↑ from OMZ's 10000)


# This makes the history command display all history with time stamp. Help on pipeing it into grep.
history() {
  if [[ ${@[-1]} = *([0-9])* ]]; then
    builtin fc -il "$@"
  else
    builtin fc -il "$@" 1
  fi
}