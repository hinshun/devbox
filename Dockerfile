FROM debian:jessie
MAINTAINER Edgar Lee "edgar@brackety.co"

# Install dependencies & clean up
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    locales \
    curl \
    zsh \
    vim \
    git \
    tmux \
    silversearcher-ag \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# UTF-8
RUN cp /usr/share/zoneinfo/Canada/Eastern /etc/localtime \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && /usr/sbin/locale-gen \
    && /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Create shared volume for SSH keys and other files from host
RUN mkdir -p /var/shared
VOLUME /var/shared

# Home sweet home
ENV HOME /home
WORKDIR $HOME

# Better zsh with prezto
COPY prezto $HOME/.zprezto
RUN chsh -s /bin/zsh \
  && for rc in $HOME/.zprezto/runcoms/z* ; do \
  ln -s "${rc}" "$HOME/.$(basename $rc)" ; done \
  && exec zsh && setopt EXTENDED_GLOB

# Dot it up
COPY dotfiles $HOME/.dotfiles
RUN for rc in $HOME/.dotfiles/* ; do \
  ln -s "${rc}" "$HOME/.$(basename $rc)" ; done

# Install vim plugins
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && mkdir -p ~/.vim/plugged \
    && vim +PlugInstall +qall

CMD ["zsh"]
