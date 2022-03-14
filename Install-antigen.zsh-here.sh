#! /bin/sh

here="$(dirname $(realpath $0))"

(
cd "$here"
curl -L git.io/antigen > antigen.zsh 
)