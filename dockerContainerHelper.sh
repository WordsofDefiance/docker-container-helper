#!/bin/bash

function getContainerFromDockerCompose {
    cat docker-compose.yml | grep -i container_name | awk '{print $2}'
}

function dockerExecInContainer {
    docker exec -it $( getContainerFromDockerCompose ) $1
}


printf "You passed in command \033[38;5;233m\033[48;5;50m$1\033[0m to container \033[38;5;233m\033[48;5;50m$( getContainerFromDockerCompose )\033[0m\n"
dockerExecInContainer $1


