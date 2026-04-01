# Use an Ubuntu image as base image
FROM ubuntu:latest

# Metadata for the container
LABEL description="This is a dummy container" author="Guillermo Barreiro"

# Set the working directory inside the container for the following Dockerfile instructions
WORKDIR /root

# Use an argument sent to the "docker build" command inside the Dockerfile
ARG USERNAME
RUN echo ${USERNAME} >> username

# Run several commands in a same line, for avoiding creating intermediate junk images
RUN /bin/bash -c 'apt-get update; apt-get install python3'

# Set environment variables 
ENV foo_folder /home

# Copy files to the container
COPY script.py /script.py

# Define a volume (in the Dockerfile you cannot set the location of a volume inside the host machine)
VOLUME /root/shared

# Set the entrypoint for the container, that means, the command to be executed when run
ENTRYPOINT ["python3", "script.py"]
