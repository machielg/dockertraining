
# Lab - Container Registry

Azure Container Registry fqdn is `eduvisionacr.azurecr.io`.

User: eduvisionacr
Pwd: <shared during course>

```shell

# Prep image
docker pull alpine:3.15
docker tag alpine eduvisionacr.azurecr.io/alpine:3.15
docker image ls

# Login
# use admin credentials
docker login eduvisionacr.azurecr.io

# Push image
docker push eduvisionacr.azurecr.io/alpine:3.15

# Remove local image
docker image rm eduvisionacr.azurecr.io/alpine:3.15
docker image ls

# Run image from ACR
docker run eduvisionacr.azurecr.io/alpine:3.15

# Admin only
# Browse to azure portal to show images

```

## Learning goals

- Get familiar with 
  - image nameing conventions
  - image tags
  - re-tagging images
  - registry login
  - push images
  - run images from a registry
