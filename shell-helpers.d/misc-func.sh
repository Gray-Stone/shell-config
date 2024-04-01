#! /bin/zsh

function cursor-back(){
  echo -ne '\e[?25h'
}


alias rsync_remote_partial="rsync --stats --compress --partial --append-verify --progress --human-readable"

alias to-clip="xclip -selection clipboard"
