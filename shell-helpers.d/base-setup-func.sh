#! /usr/bin/sh
# source a file if file exists 

source_if_exists () {
# First argument is the file to source, 
# Second argument is flag to show warning 
    if [ -f "${1}" ] ; then 
        . "${1}"

        # Echo if second argumentis true
        # Having strange bug when calling this inside another script that also get 
        # called by this. Seems like the arguments affects each other.
        if "${2}" ; then 
            echo -e "\e[32m File [ ${1} ] is sourced \e[0m"
        fi
    fi
}

# Add file to path if exists

add_path_if_exists(){
    if [ -d "${1}" ] ; then
        PATH="${1}:$PATH"
    fi
}