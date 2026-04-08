# Wordpress demo

We will deploy a wordpress frontend and a mysql backend with a volume mount for persistent storage.

## a. Read `docker-compose.yaml`

Start by reviewing the `docker-compose.yaml` file and reading the comments.

Remark: 
Wordpress stores its content in a DB and the plugins and themes locally.

## b. Build the project

Now, run `docker-compose up -d` from your project directory.

This runs `docker-compose up` in detached mode, pulls the needed Docker images, and starts the wordpress and database containers

Watch the logs and see the creation of the network, volumes.

Run `docker ps` to see the two containers running and their names.
Check the network and volumes with

```shell
docker network ls
docker volume ls
```

## c. Browse

Wordpress is exposed on port 8000. Browse to your Wordpress on port 8000 and initialise your website so you can login.

## d. Persistent volume

To proof the volumes are persistent we're gonna stop the containers and restart them again.

Run `docker-compose rm --stop --force` to stop and remove your containers and verify with `docker ps` that nothing is running.

Run `docker volume ls` to verify your volumes still exist.

Now start wordpress again with `docker-compose up -d` and verify your webpage status has not changed.

## Clean

```shell
docker-compose rm --stop --force
docker system prune --volumes

```