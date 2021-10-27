#!/bin/bash

function newline {
    printf "\n"
}

function getContainerFromDockerCompose {
    cat docker-compose.yml | grep -i container_name | awk '{print $2}'
}

function dockerExecInContainer {
    printf "You passed in command \033[38;5;233m\033[48;5;50m$@\033[0m to container \033[38;5;233m\033[48;5;50m$( getContainerFromDockerCompose )\033[0m\n"
    printf "docker exec -it $( getContainerFromDockerCompose ) $@"
    newline
    docker exec -it $( getContainerFromDockerCompose ) $@
}

function checkForComposeFile {
    # ensure there's an actual docker-compose file to use
    if [ ! -f docker-compose.yml ]; then
        printf "\033[38;5;255m\033[48;5;160mNo docker-compose.yml file found in directory.\033[0m"
                exit
    fi
}

function help {
    printf "\033[38;5;86m\033[48;5;18mUsage: 'container-exec bash' or 'container-exec composer install'\033[0m"
}

function main {
    # help
    while getopts ":h" option; do
        case $option in
            h)
                help
                exit;;
        esac
    done

    # ensure compose file exists in current directory
    checkForComposeFile

    # do the stuff
    dockerExecInContainer "$@"
}

main "$@"
