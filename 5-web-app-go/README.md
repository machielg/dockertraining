
# Lab - Web app Go

ToDo

- Inspect Dockerfile
- build image
  - `docker build -t webapp .`
  - Compare Dockerfile to build output
- verify if image works
  - run container
    - in background
    - publish port
  - browse to web app

## Learning goals

- Get familiar with 
  - Mature/real Dockerfile
  - Mature/real webapp
- Get used to
  - build images
  - run a container locally
  - publishing ports
  - locally running web apps

# Lab - Web app Go - multistage

ToDo

- Inspect Dockerfile.multistage
- build image
  - `docker build -t webapp:xs -f Dockerfile.multistage .`
  - Compare Dockerfile to build output
  - Compare image size `docker image ls`
- verify if image works
  - run container
    - in background
    - publish port
  - browse to web app

## Learning goals

- Get familiar with 
  - Multistage Dockerfile
  - image size reduction
- Get used to
  - build images
  - run a container locally
  - publishing ports
  - locally running web apps
