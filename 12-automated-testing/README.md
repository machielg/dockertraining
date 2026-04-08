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

## Part 1 - Understand the test files

The test files for this lab are already provided. Before writing any code, read through each one to understand what they expect from the image.

### Command Tests (`test-commands.yaml`)

These tests run commands inside the image and check the output:

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
  - name: "foo is not installed"
    command: "which"
    args: ["foo"]
    exitCode: 1
```

### File Existence Tests (`test-files.yaml`)

These verify that files and directories exist with the correct ownership and permissions:

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

  # Ensure no secrets are accidentally included
  - name: "no .env file"
    path: "/app/.env"
    shouldExist: false

  - name: "no private keys"
    path: "/app/key.pem"
    shouldExist: false
```

### File Content Tests (`test-file-content.yaml`)

These check the actual contents of files inside the image:

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

### Metadata Tests (`test-metadata.yaml`)

These validate image metadata like environment variables, labels, cmd, user, and workdir:

```yaml
schemaVersion: "2.0.0"

metadataTest:
  # Environment variables
  envVars:
    - key: "APP_ENV"
      value: "production"
    - key: "APP_PORT"
      value: "8080"

  # Exposed ports
  exposedPorts:
    - "8080"
  unexposedPorts:
    - "22"

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

---

## Part 2 - Write a Dockerfile that passes all tests

Now that you understand what the tests expect, create a `Dockerfile` that makes all tests pass.

**Hints:**

- Use `alpine:3.20` as your base image
- Read the test files carefully — they tell you exactly what packages, files, environment variables, labels, users, and permissions are expected
- Pay attention to file ownership (`uid`/`gid`) in the file existence tests

Build your image:

```bash
docker build -t test-app:1.0 .
```

---

## Part 3 - Run the tests

Run each test file individually to see which tests pass and which fail:

```bash
container-structure-test test --image test-app:1.0 --config test-commands.yaml
container-structure-test test --image test-app:1.0 --config test-files.yaml
container-structure-test test --image test-app:1.0 --config test-file-content.yaml
container-structure-test test --image test-app:1.0 --config test-metadata.yaml
```

Fix your Dockerfile, rebuild, and rerun until all tests pass.

---

## Part 4 - Run all tests together

Once all individual test files pass, run them all in a single command:

```bash
container-structure-test test \
  --image test-app:1.0 \
  --config test-commands.yaml \
  --config test-files.yaml \
  --config test-file-content.yaml \
  --config test-metadata.yaml
```

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
