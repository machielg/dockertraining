
# Lab - Web app Springboot

ToDo

- Inspect Dockerfile
- build image
  - `docker build -t webapp .`
  - Compare Dockerfile to build output
- verify if image works
  - run container
    - in background
    - publish port on host port 8080
  - browse to web app at:
    http://localhost:8080/health/ping

## Learning goals

- Get familiar with 
  - Mature / real Springboot Dockerfile
  - build app inside container
    - No build tools needed on your machine!
  - Multistage Dockerfile
- Get used to
  - build images
  - run a container locally
  - publishing ports
  - locally running web apps
