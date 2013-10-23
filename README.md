# Docker image for Petals ESB

Runs the latest Petals ESB distribution in a docker container (http://docker.io).

## Howto

### Run container from sources

    git clone https://github.com/petalslink/petalsesb-docker.git
    cd petalsesb-docker
    vagrant up
    vagrant ssh
    docker build -t petalslink/esb .
    docker run -d petalslink/esb

### Run container from docker repository

    TODO

