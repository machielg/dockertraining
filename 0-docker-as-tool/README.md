# Docker as a tool

Docker makes it possible to run tools that are not available on the system or in a develop environment. Only a single container is needed to use the tool of your choice.

# `jq`

`jq` is a popular tool to process json structured data.

## a. Run `jq`
Run `jq` (don't install it):
```shell
jq
```
Spoiler: `jq` is not yet installed. 

## b. Set alias for `jq`
If `jq` cannot be installed, you can still make it available by pointing the `jq` command to a `docker run` command. For this exercise we ***do not*** install it with apt.

Copy and paste the command below in your shell:
```shell
alias jq='docker run -i --rm mwendler/jq'
```
When ever `jq` is used in the current shell, the docker command is run.

## c. Run `jq` again
Now run again:
```shell
jq
```
The first time the command is run the image is pulled.

Now try to use the tool by running:
```shell
docker version --format '{{json .}}' | jq '.Server.Components[0]' 
```
The first part (before the pipe character) just produces some json to be parsed by `jq`.

## d. Breakdown
Docker command breakdown:
```
docker run        # docker command to start a container from an image
  -i              # add interactive stream (STDIN)
  --rm            # remove container when finished
  mwendlser/jq    # image to use: https://hub.docker.com/r/mwendler/jq
```

# `git`

The same can be done with the git client in Linux. Git runs operations on files and that makes it a bit more challenging to run it in a docker container.

## a. Run `git`
Check the version of the git client installed:
```
git version
```

## b. Create new command `git_cc`
Copy and paste the command below in your shell:
```shell
alias git_cc='echo "Using git container..."; \
    docker run \
    -ti \
    --rm \
    --user $(id -u):$(id -g) \
    --env HOME=${HOME} \
    -v $HOME:$HOME:rw \
    -v /etc/passwd:/etc/passwd:ro \
    -v /etc/group:/etc/group:ro \
    -v $PWD:$PWD:rw \
    -w $PWD \
    alpine/git'
```
When ever `git_cc` is started in the curren shell, the docker command is run. If you want to replace the installed git client with the docker command, just rename `git_cc` to `git`.

## c. Run new command `git_cc`
Now run the new command:
```shell
git_cc version
```

## d. Set author name
Set the author name by running:
```shell
git_cc config --global user.name cinqict
```
Verify the author name has been set:
```
cat ~/.gitconfig
```

## e. Create a new git repository
Run to create a new repository:
```shell
git_cc init myrepo
```
Verify all directories have the correct owner and group:
```shell
ls -la myrepo
```

## f. Breakdown
Docker command breakdown:
```
docker run                       # docker command to start a container from an image
  -ti                            # use pseudo TTY and add interactive stream (STDIN)
  --rm                           # remove container when finished
  --user $(id -u):$(id -g)       # run container with user id and group id of current user
  --env HOME=${HOME}             # set HOME path to HOME environment variable in container
  -v $HOME:$HOME:rw              # mount home directory of current user in container (.gitconfig)
  -v /etc/passwd:/etc/passwd:ro  # mount passwd in container, provides user id mapping
  -v /etc/group:/etc/group:ro    # mount group in container, provides group id mapping
  -v $PWD:$PWD:rw                # mount current path (the git repository) in container
  -w $PWD                        # swith to this work directory (current path but in the container)
  alpine/git                     # image to use: https://hub.docker.com/r/alpine/git
```