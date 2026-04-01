
# Lab - Look around

Let's look around in a running container.

Normally it isn't good practice to go inside of a container. You do that only locally when you develop an image or sometimes for troubleshooting.

ToDo

- Run figlet or ubuntu container with command `bash`
  `docker run -it ubuntu bash`
- Execute commands:
  - `pwd`
  - `ps -ef`
  - `whoami`
- Look around

- Experiment with Dockerfile INSTRUCTIONS, e.g.
USER, COPY

## Learning goals

- Get familiar with 
  - inside container (it's just like a VM)
  - proces isolation
- Get used to
  - build images
  - run a container locally
optional:
- Apply Dockerfile intructions: USER, COPY
