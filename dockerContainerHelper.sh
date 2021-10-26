#!/bin/bash

function getContainerFromDockerCompose {
    cat docker-compose.yml | grep -i container_name | awk '{print $2}'
}

function dockerExecInContainer {
    docker exec -it $( getContainerFromDockerCompose ) $1
}

function help {
    printf "Usage: `container-exec bash` or `container exec 'composer install'`\n"
}


function main {
    # help
    while getopts "help" OPTION
    do
        help
        return 0
    done

    # validate params
    if [ "$#" -ne 1 ]; then
        echo "Only pass in one argument. Longer commands can be passed in within single quotes.\n"
        return 1
    fi

    # ensure there's an actual docker-compose file to use
    if [ ! -f docker-compose.yml ]; then
        printf "No docker-compose.yml file found in directory.\n"
        return 1
    fi

    # do the stuff
    printf "You passed in command \033[38;5;233m\033[48;5;50m$1\033[0m to container \033[38;5;233m\033[48;5;50m$( getContainerFromDockerCompose )\033[0m\n"

    dockerExecInContainer $1
}

main $1

