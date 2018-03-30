# Docker image for Petals ESB

This image allows to run a Petals node.  
A Petals node is a member of Petals domain / topology.
It is an instance of a Petals server that may interact with other ones (depending on its configuration).

> For the moment, this image targets a stand-alone instance.  


## Launch a container from this image

```properties
# Download the image
docker pull petalslink/petals-node:latest

# Start in detached mode
docker run -d -p 7700:7700 -p 7800:7800 --name petals petalslink/petals-node:latest

# Verify the container was launched
docker ps

# Watch what happens
docker logs petals

# Verify the ports used on the host (example)
sudo lsof -i :7700

# Get information about the container
docker inspect petals

# Introspect the container
docker exec -ti petals /bin/bash
```

Internal ports (7700 for JMX and 7800 for message transport) are here exposed on the same ports on the host system.  
To test the image is correct, check the JMX connection...

```properties
# Find the URL to connect with JMX
docker logs petals

# Launch the JConsole
jconsole &

# Type in the remote URL: service:jmx:rmi:///jndi/rmi://localhost:7700/PetalsJMX
# User/password: petals/petals
# If asked, click the "insecure connection" button.
```

The example shows how to get the last version.  
You can obviously change the version. Each Petals container version has its own image.
Versions match. As an example, to get Petals 5.1.0, just type in `docker pull petalslink/petals-node:5.1.0`.


## Warning

> With this default command, you launch a container but nothing that you deploy into it
> will be reachable from the outside. Docker does not allow to open ports once a container is started.
> You must declare ports in accordance with what you want to deploy in the container. And you must do
> it when you launch the container.

Example: let's assume you want to deploy the SOAP BC (a Petals component that allows to expose ESB services
as web services, and that also allows to invoke SOAP services). This component launches a web server on the 8080
port (by default). If you plan to deploy it inside a Dockerized Petals container, the container should have been
launched with `docker run -d -p 7700:7700 -p 7800:7800 -p 8080:8080 --name petals petalslink/petals-node:latest`.

If you launched the container without exposing the 8080 port, you would have to launch a new container and forget / drop
the old one. From this point of view, Petals and Docker work differently. You will find the same issue with all the ESB.
One way to by-pass the issue would be to expose many ports at once, with the possibility that most of them will never be
used, even if they are exposed by the container. In a container-management solution, like Kubernetes, specific strategies
can be setup to deal with such situations.


## Build an image (introduction)

This project allows to build a Docker image for both released and snapshot versions of Petals ESB.  
The process is a little bit different for each case. All of this relies on Docker build arguments and the presence
of the package in OW2's Maven repository (which is currently [Nexus](https://www.sonatype.com/nexus-repository-sonatype)).

| Argument | Optional | Default | Description |
| -------- | :------: | :-----: | ----------- |
| PETALS_VERSION | yes | LATEST | The version of the Petals ESB distribution to use. It can include a "-SNAPSHOT" suffix. In this case, the Maven policy should be "snapshots" instead of "releases". **LATEST** is a special keyword for Nexus' API, which is used at build time to resolve the artifact to download. |
| MAVEN_POLICY | - | releases | The Maven policy: should we search in the `snapshots` or in the `releases` repository? |
| BASE_URL | yes | https://repository.ow2.org/nexus/service/local/artifact/maven/redirect | The REST API used to resolve the Maven artifacts (the Debian packages are stored as Maven artifacts). One could reference another Nexus instance or [a mock of it](https://github.com/roboconf/dockerized-mock-for-nexus-api). |

By using these parameters correctly, you can achieve what you want, provided the packages are available in a Nexus repository.
Examples are given below.


## Build an image for a released version of Petals ESB

The example is quite simple to understand.

```
docker build \
		--build-arg PETALS_VERSION=5.1.0 \
		-t petalslink/petals-node:latest \
		-t petalslink/petals-node:5.1.0 \
		.
```

The **latest** tag for Docker should only be used if this is the last released version of Petals ESB.


## Build an image for a snapshot version of Petals ESB

Just like for a released version of Petals ESB, you need to know the version of Petals to use.
It must also be available in a Nexus repository. If you built it on your local machine, it is possible
to mimic a Nexus repository thanks to [this project](https://github.com/roboconf/dockerized-mock-for-nexus-api)
(that will pick up the artifacts to download in your local Maven repository).

You can then launch the build process with...

```
docker build \
		--build-arg PETALS_VERSION=5.2.0-SNAPSHOT \
		--build-arg MAVEN_POLICY=snapshots \
		-t petalslink/petals-node:5.2.0-SNAPSHOT \
		.
```

Such images should not be shared on Petals's official repository.


## Supported Docker versions

This image is officially supported on Docker version 1.9.0 and higher.  
Please see [the Docker installation documentation](https://docs.docker.com/install/)
for details on how to upgrade your Docker daemon.


## License

These images are licensed under the terms of the [LGPL 2.1](https://www.gnu.org/licenses/old-licenses/lgpl-2.1.fr.html).


## Documentation

Documentation for Petals ESB can be found on [its wiki](https://doc.petalslink.com).  
You can also visit [its official web site](http://petals.ow2.org).
