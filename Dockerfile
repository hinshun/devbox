FROM ubuntu:14.04
MAINTAINER Edgar Lee "edgar@brackety.co"

# Add our user and group first to ensure IDs get assigned correctly
RUN groupadd -r dev && useradd -r -g dev dev

# Get development tools
RUN apt-get update && apt-get install -y \
    vim \
    tmux \
    git \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create shared volume for SSH keys and other files from host
RUN mkdir -p /var/shared && chown -R dev /var/shared
VOLUME /var/shared

# Setup home directory
RUN mkdir -p /home/dev && chown -R dev /home/dev
WORKDIR /home/dev
ENV HOME /home/dev

# Enter container as 'dev'
USER dev

# Copy over home directory files
COPY . /home/dev

# Install vim plugins
RUN vim +PlugInstall +qa
