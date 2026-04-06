# Lab 8 - Volumes

## Goal

Learn how to persist data with Docker using bind mounts and named volumes.

---

## Lab 8a - Bind Mount

### Goal

Share files between your host machine and a container.

### Steps

### 1. Create a directory on your host

```bash
mkdir mydata
```

### 2. Run a container with a bind mount

Mount the `mydata` directory into the container at `/app`:

```bash
docker run -it -v $(pwd)/mydata:/app alpine sh
```

### 3. Explore from inside the container

List files in the mounted directory:

```bash
ls -l /app
```

Create a file inside the container:

```bash
echo foo > /app/bar.txt
```

### 4. Verify on your host

Open a new terminal and check if the file appears on your host:

```bash
ls mydata/
cat mydata/bar.txt
```

You should see `bar.txt` with the content `foo`. This demonstrates that bind mounts provide a direct link between the host filesystem and the container.

---

## Lab 8b - Named Volumes

### Goal

Use Docker-managed named volumes to persist data across containers.

### Steps

#### 1. Create a named volume

```bash
docker volume create my-vol
```

#### 2. Run a container with the named volume

```bash
docker run -it -v my-vol:/app alpine sh
```

#### 3. Write data inside the container

```bash
echo "hello from container 1" > /app/hello.txt
exit
```

#### 4. Start a new container with the same volume

```bash
docker run -it -v my-vol:/app alpine sh
```

Verify the data persists:

```bash
cat /app/hello.txt
exit
```

You should see `hello from container 1` — the data survived even though the first container is gone.

#### 5. Inspect the volume

```bash
docker volume inspect my-vol
```

This shows where Docker stores the volume data on the host.

#### 6. Clean up

```bash
docker volume rm my-vol
```

---

## Useful Commands

```bash
docker run -v <host-path>:<container-path> <image>   # Run with bind mount
docker run -v <volume-name>:<container-path> <image>  # Run with named volume
docker volume create my-vol                           # Create a named volume
docker volume ls                                      # List volumes
docker volume inspect my-vol                          # Inspect a volume
docker volume rm my-vol                               # Remove a volume
docker volume prune                                   # Remove all unused volumes
docker volume --help                                  # Volume help
```

> **Note:** Lab 8a doesn't work on Docker Desktop on Windows.
