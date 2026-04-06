# Lab 12 - Automated Testing with Container Structure Test

## Goal

Learn how to use [container-structure-test](https://github.com/GoogleContainerTools/container-structure-test) to validate Docker images. You will write tests that verify image metadata, file contents, installed commands, and runtime behavior — catching problems before containers reach production.

## What is Container Structure Test?

Container Structure Test is a tool by Google that validates the structure of a Docker image. It lets you test things like:

- Does the image have the right files and permissions?
- Are the correct packages installed?
- Is the entrypoint/cmd set correctly?
- Do commands produce expected output?
- Are environment variables set?
- Are unnecessary files excluded?

## Prerequisites

### Install container-structure-test

**macOS:**

```bash
brew install container-structure-test
```

**Linux:**

```bash
curl -LO https://github.com/GoogleContainerTools/container-structure-test/releases/latest/download/container-structure-test-linux-amd64
chmod +x container-structure-test-linux-amd64
sudo mv container-structure-test-linux-amd64 /usr/local/bin/container-structure-test
```

Verify the installation:

```bash
container-structure-test version
```

---

## Part 1 - Build a sample image

Create a `Dockerfile`:

```Dockerfile
FROM alpine:3.20

RUN apk add --no-cache curl jq

ENV APP_ENV=production
ENV APP_PORT=8080

LABEL maintainer="training@eduvision.nl"
LABEL version="1.0"

RUN mkdir -p /app/config && \
    echo '{"name": "demo-app", "version": "1.0"}' > /app/config/app.json

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN chown -R appuser:appgroup /app

WORKDIR /app

USER appuser

CMD ["sh", "-c", "echo 'App is running'"]
```

Build the image:

```bash
docker build -t test-app:1.0 .
```

---

## Part 2 - Command Tests

Command tests run a command inside the image and check the output.

Create `test-commands.yaml`:

```yaml
schemaVersion: "2.0.0"

commandTests:
  # Test that curl is installed
  - name: "curl is installed"
    command: "curl"
    args: ["--version"]
    expectedOutput: ["curl \\d+\\.\\d+"]

  # Test that jq is installed
  - name: "jq is installed"
    command: "jq"
    args: ["--version"]
    expectedOutput: ["jq-\\d+"]

  # Test that the app config file has correct content
  - name: "app config contains app name"
    command: "cat"
    args: ["/app/config/app.json"]
    expectedOutput: ["demo-app"]

  # Test that a command is NOT available
  - name: "wget is not installed"
    command: "which"
    args: ["wget"]
    exitCode: 1
```

Run the tests:

```bash
container-structure-test test --image test-app:1.0 --config test-commands.yaml
```

---

## Part 3 - File Existence Tests

Verify that files and directories exist with the correct ownership and permissions.

Create `test-files.yaml`:

```yaml
schemaVersion: "2.0.0"

fileExistenceTests:
  # Check the config file exists
  - name: "app config exists"
    path: "/app/config/app.json"
    shouldExist: true
    permissions: "-rw-r--r--"
    uid: 100
    gid: 101

  # Check the app directory exists
  - name: "app directory exists"
    path: "/app"
    shouldExist: true
    isDirectory: true

  # Ensure no secrets are accidentally included
  - name: "no .env file"
    path: "/app/.env"
    shouldExist: false

  - name: "no private keys"
    path: "/app/key.pem"
    shouldExist: false
```

Run the tests:

```bash
container-structure-test test --image test-app:1.0 --config test-files.yaml
```

---

## Part 4 - File Content Tests

Check the actual contents of files inside the image.

Create `test-file-content.yaml`:

```yaml
schemaVersion: "2.0.0"

fileContentTests:
  # Verify app.json contains expected fields
  - name: "app config has correct name"
    path: "/app/config/app.json"
    expectedContents: ["demo-app"]

  - name: "app config has version"
    path: "/app/config/app.json"
    expectedContents: ["1.0"]

  # Verify something is NOT in a file
  - name: "no debug flag in config"
    path: "/app/config/app.json"
    excludedContents: ["debug"]
```

Run the tests:

```bash
container-structure-test test --image test-app:1.0 --config test-file-content.yaml
```

---

## Part 5 - Metadata Tests

Validate image metadata like environment variables, entrypoint, cmd, exposed ports, labels, user, and workdir.

Create `test-metadata.yaml`:

```yaml
schemaVersion: "2.0.0"

metadataTest:
  # Environment variables
  env:
    - key: "APP_ENV"
      value: "production"
    - key: "APP_PORT"
      value: "8080"

  # Labels
  labels:
    - key: "maintainer"
      value: "training@eduvision.nl"
    - key: "version"
      value: "1.0"

  # CMD
  cmd: ["sh", "-c", "echo 'App is running'"]

  # Working directory
  workdir: "/app"

  # User
  user: "appuser"
```

Run the tests:

```bash
container-structure-test test --image test-app:1.0 --config test-metadata.yaml
```

---

## Part 6 - Run all tests together

You can pass multiple config files in a single run:

```bash
container-structure-test test \
  --image test-app:1.0 \
  --config test-commands.yaml \
  --config test-files.yaml \
  --config test-file-content.yaml \
  --config test-metadata.yaml
```

Or combine everything into a single `test-all.yaml` file.

---

## Part 7 - Make a test fail

Try breaking something and see how the tool reports it.

### Exercise A: Remove a package

Edit the Dockerfile and remove `jq` from the `apk add` line. Rebuild and rerun:

```bash
docker build -t test-app:1.0 .
container-structure-test test --image test-app:1.0 --config test-commands.yaml
```

You should see the "jq is installed" test fail.

### Exercise B: Change an environment variable

Change `APP_ENV` to `development` in the Dockerfile. Rebuild and rerun:

```bash
docker build -t test-app:1.0 .
container-structure-test test --image test-app:1.0 --config test-metadata.yaml
```

The metadata test for `APP_ENV` should fail.

---

## Summary

| Test Type | What it checks |
|---|---|
| `commandTests` | Run commands and check output/exit code |
| `fileExistenceTests` | Files exist with correct permissions and ownership |
| `fileContentTests` | File contents match (or exclude) patterns |
| `metadataTest` | ENV, labels, CMD, ENTRYPOINT, USER, WORKDIR |

## Useful Commands

```bash
container-structure-test test --image <image> --config <file.yaml>   # Run tests
container-structure-test test --image <image> --config a.yaml --config b.yaml  # Multiple configs
container-structure-test version                                      # Show version
```

## Why use this?

- Catch misconfigurations before deploying
- Verify security hardening (non-root user, no secrets, minimal packages)
- Automate in CI/CD pipelines alongside `docker build`
- Document image expectations as testable specifications
