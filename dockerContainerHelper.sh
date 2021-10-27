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

function help {
    printf "Usage: `container-exec bash` or `container exec 'composer install'`\n"
}

function main {
    echo "$@"
    # help
    while getopts "help" OPTION
    do
        help
        return 0
    done

    # ensure there's an actual docker-compose file to use
    if [ ! -f docker-compose.yml ]; then
        printf "No docker-compose.yml file found in directory.\n"
        return 1
    fi

    # do the stuff
    dockerExecInContainer "$@"
}

main "$@"
