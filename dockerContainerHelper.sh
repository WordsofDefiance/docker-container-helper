#!/bin/bash

function newline {
    printf "\n"
}

function getContainerFromDockerCompose {

    local container_name=$(grep -i container_name docker-compose.yml | awk '{print $2}')

    if [[ -z "${container_name}" ]]; then
        echo "Error: 'container_name' not found in docker-compose.yml"
        exit 1
    fi

    echo "${container_name}"
}

function dockerExecInContainer {
    local container_name=$(getContainerFromDockerCompose)

    if ! docker ps | awk '{print $NF}' | grep -q "^${container_name}\$"; then
        echo "Container '${container_name}' is not running!"
        exit 1
    fi

    export vars="$@"
    printf "You passed in command \033[38;5;233m\033[48;5;50m$@\033[0m to container \033[38;5;233m\033[48;5;50m$( getContainerFromDockerCompose )\033[0m\n"
    printf "docker exec -it $( getContainerFromDockerCompose ) $vars"
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
    if [ "$#" -eq 0 ]; then
        help
        exit
    fi

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
