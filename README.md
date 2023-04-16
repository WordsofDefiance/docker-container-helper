# docker-container-helper
A command line helper for Docker containers

I got sick and tired of typing `docker exec -it $CONTAINER_NAME$ $COMMAND$` every time I wanted to poke inside a container. So I made this.

Right now it looks for a docker-compose file with a `container_name` variable and executes the command in there.

## Requirements

- Docker installed on your machine
- A docker-compose.yml file containing a `container-name` value

## Installation:

- Clone this repo.
- Make the `dockerContainerHelper.sh` file executable with `chmod +x dockerContainerHelper.sh`.
- Move the file to a directory in your $PATH, such as /usr/local/bin.

If you want more flexibility, create a symlink called `container-exec` somewhere in your `$PATH` linked to the `dockerContainerHelper.sh` file within the repo. This allows you to continue to develop with Git while maintaining the convenience of the command line executable. Plus, Zsh (I think) provides auto-complete for executables in the `$PATH`, so that's a nifty bonus of using a symlink.

```
cd $SOMEWHERE_IN_PATH$
ln -s $dockerContainerHelper.sh_LOCATION$ container-exec
```

## Usage

```
container-exec composer install
container-exec bash
```
