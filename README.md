# docker-container-helper
A command line helper for Docker containers

I got sick and tired of typing `docker exec -it $CONTAINER_NAME$ $COMMAND$` every time I wanted to poke inside a container so I made this. 

Right now it just looks for a docker-compose file with a `container_name` variable and executes your command in there. 

##Installation: 

```
git clone
ln -s $SOMEWHERE_IN_PATH$ container-exec
container-exec bash
```

### Todo

Make it so that you can execute multi-word commands like `composer install` inside the container.
