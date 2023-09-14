#! /usr/bin/sh
# source a file if file exists 

source_if_exists () {
# First argument is the file to source, 
# Second argument is flag to show warning 
    if [ -f "${1}" ] ; then 
        . "${1}"

        # Echo if second argumentis true
        if "${2}" ; then 
            echo -e "\e[32m File { ${1} } is sourced \e[0m"
        fi
    fi
}