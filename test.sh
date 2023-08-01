#!/bin/bash


# testing 

function progress_bar() {
    x=("\\" "/" "-")
    for elem in ${x[@]}
    do
        echo -ne "\b$elem"
        sleep 0.4
    done
}

function interface() {
    #$2 - for newline $3 - for indent
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    if [ $2 -eq 1 ]; then
        echo -e "[${RED}+${NC}] $1" 
    else
        echo -ne "[${RED}+${NC}] $1" 
    fi
}


# plot
#greeting
#installing all stuff
#configurations (wallpaper, wifi settings, global variables, terminal color) 
#backup mb??