#! /bin/sh

# SHELL_CONFIG_DIR this need to point to the repo folder this file is in. The scirpt rely on this 
# to find relative file location



if [ -z ${SHELL_CONFIG_DIR+x} ] ; then 
    SHELL_HELPER_DIR="$(dirname $(realpath $0))"
else 
    SHELL_HELPER_DIR=${SHELL_CONFIG_DIR}/shell-helpers.d
fi 

. "${SHELL_HELPER_DIR}/git-func.sh"
. "${SHELL_HELPER_DIR}/systemd-func.sh"
