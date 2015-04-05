FROM debian:jessie
MAINTAINER Edgar Lee "edgar@brackety.co"

# Get development tools
RUN apt-get update && apt-get install -y \
    zsh \
    vim \
    tmux \
    git \
    curl \
    silversearcher-ag \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create shared volume for SSH keys and other files from host
RUN mkdir -p /var/shared
VOLUME /var/shared

# Copy over home directory files
ENV HOME /home
COPY .* $HOME/
WORKDIR $HOME

# Setup prezto
RUN git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto" \
  && chsh -s /bin/zsh \
  && for rc in $HOME/.zprezto/runcoms/z* ; do ln -s "${rc}" "$HOME/.$(basename $rc)" ; done \
  && exec zsh && setopt EXTENDED_GLOB

# Install vim plugins
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && mkdir -p ~/.vim/plugged \
    && vim +PlugInstall +qall

CMD ["zsh"]
