FROM ruby:2.2-slim
MAINTAINER Edgar Lee "edgar@brackety.co"

# Install dependencies & clean up
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    apt-transport-https \
    locales \
    ssh \
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

# Install docker & docker-compose
RUN curl -fLo /usr/local/bin/docker \
    https://get.docker.io/builds/Linux/x86_64/docker-latest \
    && chmod +x /usr/local/bin/docker \
    && curl -fLo /usr/local/bin/docker-compose \
    https://github.com/docker/compose/releases/download/1.1.0/docker-compose-`uname -s`-`uname -m` \
    && chmod +x /usr/local/bin/docker-compose

# Prepare home
ENV HOME /home
WORKDIR $HOME

# Install gems
RUN gem install tmuxinator \
  && curl -fLo $HOME/.bin/tmuxinator.zsh --create-dirs \
  https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh

# Home sweet home
COPY . $HOME

# Better zsh with prezto
RUN chsh -s /bin/zsh \
  && for rc in $HOME/.zprezto/runcoms/z* ; do \
  ln -s "${rc}" "$HOME/.$(basename $rc)" ; done \
  && exec zsh && setopt EXTENDED_GLOB

# Dot it up
RUN for rc in $HOME/.dotfiles/* ; do \
  ln -s "${rc}" "$HOME/.$(basename $rc)" ; done

# Install vim plugins
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && mkdir -p ~/.vim/plugged \
    && vim +PlugInstall +qall

CMD ["zsh"]
