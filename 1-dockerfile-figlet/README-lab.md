# Lab - Dockerfile figlet

ToDo

- Inspect Dockerfile.lab
- build image
  - `docker build -t figlet .`
  - Compare build output to Dockerfile
- verify if image works
  - run container: `docker run -it figlet bash`
  - execute: `figlet foobar`
  - run `exit` to quit the container

- Modify the Dockerfile so you can run:
  `docker run figlet foobar`

## Learning goals

- Get familiar with
  - basic Dockerfile
  - `docker build` command
  - `docker run -it IMAGE bash` command
- Apply Dockerfile intruction: CMD
