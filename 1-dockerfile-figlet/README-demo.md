
# Dockerfile Demo

## Prerequisites

Before we start, verify your docker setup by running:

```shell
docker version
docker run hello-world
```

Both should return multilines with reasonable info.

## Inspect Dockerfile

Inspect Dockerfile we see three lines:

```shell
FROM ubuntu
```

Here we set `ubuntu` to be our base image.

You can check the [Ubuntu image on Docker Hub](https://hub.docker.com/_/ubuntu)

```shell
RUN apt-get update
```

Here we update the local list of `apt` packages.

```shell
RUN apt-get install figlet -y
```

Finally we install the latest `figlet` package, where `-y` is for accepting the installation.

## Build image

To build the image we run

```shell
docker build -t figlet .
```

This will

- look in the current directory "." (that is what the dot means)
- for the file `Dockerfile` (by default)
- build an image
- give it the tag figlet with `-t figlet`.

Look into the output and see if you can get some highlevel idea of what happens.

We now have an image. Verify this by listing all local images.

```shell
docker image ls
```

## Run image

We can now use our figlet image to start a container. This can be done with the `docker run` command:

```shell
docker run [OPTIONS] IMAGE [COMMAND]
```

In our case we do

```shell
docker run -it figlet bash
```

This will:

- start a container from image `figlet`
- execute `bash` command inside the container (bash is a shell)
- `-it` stands for options `--interactive --tty` which are needed to keep the shell open and use it properly

Once the container is started your shell will be inside the running container.

Here you can now use figlet by running

```shell
figlet foobar
```



