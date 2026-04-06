# Lab 9 - Network

## Goal

Learn how to create a Docker network and enable containers to communicate with each other by name.

## Steps

### 1. Create a network with the bridge driver

```bash
docker network create my-net
```

### 2. Start two containers on the network

In one terminal, start the first container:

```bash
docker run -dit --name container1 --network my-net alpine sh
```

In another terminal, start the second container:

```bash
docker run -dit --name container2 --network my-net alpine sh
```

### 3. Check the container names

```bash
docker ps
```

Note the names (`container1` and `container2`).

### 4. Attach to one container and ping the other

```bash
docker exec -it container1 sh
```

From inside the container, ping the other by name:

```bash
ping -c 4 container2
```

You should see successful replies. Docker's built-in DNS resolves container names automatically on user-defined networks.

### 5. Clean up

```bash
docker rm -f container1 container2
docker network rm my-net
```

## Useful Commands

```bash
docker network create my-net          # Create a network
docker network ls                     # List networks
docker network inspect my-net         # Inspect a network
docker network rm my-net              # Remove a network
docker network --help                 # Network help
```
