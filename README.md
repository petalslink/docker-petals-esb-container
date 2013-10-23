# Docker image for Petals ESB

Runs the latest Petals ESB distribution in a docker container (http://docker.io).

## Howto

    git clone me
    vagrant up
    vagrant ssh
    docker build -t petalslink/esb .
    docker run -d petalslink/esb