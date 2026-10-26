#!/bin/bash

function newline {
    printf "\n"
}

function loadDotEnv {
    # Compose reads .env from the project directory, so container names defined
    # there have to be visible before any variables can be expanded.
    [[ -f .env ]] || return 0

    local line name value
    while IFS= read -r line || [[ -n "${line}" ]]; do
        [[ "${line}" =~ ^[[:space:]]*# ]] && continue
        [[ "${line}" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]] || continue

        name="${line%%=*}"
        value="${line#*=}"
        value="${value%\"}"; value="${value#\"}"
        value="${value%\'}"; value="${value#\'}"

        export "${name}=${value}"
    done < .env
}

function expandComposeVars {
    # Resolves ${VAR}, ${VAR:-default} and ${VAR-default} the way Compose does.
    local value="$1" match name fallback

    while [[ "${value}" =~ \$\{([A-Za-z_][A-Za-z0-9_]*)(:?-([^}]*))?\} ]]; do
        match="${BASH_REMATCH[0]}"
        name="${BASH_REMATCH[1]}"
        fallback="${BASH_REMATCH[3]}"
        value="${value//${match}/${!name:-${fallback}}}"
    done

    printf '%s' "${value}"
}

function getContainerFromDockerCompose {

    local container_name=$(grep -i container_name docker-compose.yml | awk '{print $2}' | head -n1)

    if [[ -z "${container_name}" ]]; then
        echo "Error: 'container_name' not found in docker-compose.yml" >&2
        exit 1
    fi

    loadDotEnv
    expandComposeVars "${container_name}"
}

function dockerExecInContainer {
    local container_name
    container_name=$(getContainerFromDockerCompose) || exit 1

    if ! docker ps --format '{{.Names}}' | grep -q "^${container_name}\$"; then
        echo "Container '${container_name}' is not running!"
        exit 1
    fi

    # Interactive REPLs (tinker, psql) need a TTY, but keep it off when stdin is
    # piped so `echo ... | ce php artisan tinker` still works.
    local exec_flags='-i'
    if [ -t 0 ] && [ -t 1 ]; then
        exec_flags='-it'
    fi

    printf "You passed in command \033[38;5;233m\033[48;5;50m%s\033[0m to container \033[38;5;233m\033[48;5;50m%s\033[0m\n" "$*" "${container_name}"
    printf 'docker exec %s %s %s' "${exec_flags}" "${container_name}" "$*"
    newline
    docker exec "${exec_flags}" "${container_name}" "$@"
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
