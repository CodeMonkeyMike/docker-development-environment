FROM phusion/baseimage:latest

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Where tool config things go
RUN mkdir $HOME/.config && mkdir -p $HOME/.local/share

# For NVIM
RUN add-apt-repository ppa:neovim-ppa/unstable

# For Fish Shell
RUN add-apt-repository ppa:fish-shell/nightly-master

# For PHP 7
#RUN apt-get install --assume-yes language-pack-en-base
#RUN add-apt-repository ppa:ondrej/php

# Because added PPA's
RUN apt-get --assume-yes update

# For Neovim
RUN apt-get --assume-yes install \
    software-properties-common \
    neovim

# Utilities
RUN apt-get --assume-yes install \
    stow \
    git \
    fish \
    wget \
    zip \
    unzip \
    httpie

# For PGCLI
#RUN apt-get --assume-yes install \
#    python-pip \
#    libpq-dev \
#    python-dev

# PGCLI
#RUN pip install pgcli

# PHP 7
#RUN apt-get --assume-yes install \
#    php7.0 \
#    php7.0-sqlite3 \
#    php7.0-mbstring \
#    php-ast

# Replace all editors with NVIM
RUN update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
RUN update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
RUN update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60

# Fisher.fish
RUN curl --location --output ~/.config/fish/functions/fisher.fish --create-dirs \
    https://raw.githubusercontent.com/fisherman/fisherman/master/fisher.fish

# Install Fish Packages
RUN /usr/bin/fish -c "fisher metro fzf"

# Build tools Tmux
RUN apt-get --assume-yes install automake libtool pkg-config
RUN apt-get --assume-yes build-dep tmux

# Clone and build Tmux
RUN git clone https://github.com/tmux/tmux.git /tmp/tmux && \
    cd /tmp/tmux && \
    git checkout tags/2.2 && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local && \
    make && \
    make install

# Plug.vim
RUN curl --location --output ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# FZF Fuzzy File Finder
RUN git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && \
    $HOME/.fzf/install

# Platinum Searcher ACK replacement
RUN curl --location --output /tmp/pt.tar.gz --create-dirs \
    https://github.com/monochromegane/the_platinum_searcher/releases/download/v2.1.1/pt_linux_amd64.tar.gz && \
    cd /tmp && \
    tar -xvzf pt.tar.gz pt_linux_amd64/pt && \
    mv /tmp/pt_linux_amd64/pt /usr/local/bin

# Composer
#RUN curl --silent --show-error https://getcomposer.org/installer | \
#    php -- --install-dir=/usr/local/bin --filename=composer

# Psysh (PHP REPL)
#RUN composer global require \
#    psy/psysh:@stable \
#    symfony/event-dispatcher:@stable \
#    symfony/process:@stable \
#    psr/log:@stable

# PHP Manual For Psysh
#RUN curl --location --output /usr/local/share/psysh/php_manual.sqlite --create-dirs \
#    http://psysh.org/manual/en/php_manual.sqlite

# Dotfiles
RUN git clone https://github.com/CodeMonkeyMike/dotfiles.git $HOME/dotfiles && \
    cd $HOME/dotfiles && \
    stow nvim && \
    stow fish && \
    stow tmux && \
    stow zsh && \
    stow git && \
    tic $HOME/dotfiles/terminfo/tmux-256color-italic.terminfo && \
    tic $HOME/dotfiles/terminfo/xterm-256color-italic.terminfo

RUN apt-get --assume-yes install wamerican
RUN apt-get --assume-yes install hunspell

RUN git clone https://github.com/universal-ctags/ctags.git /tmp/ctags && \
    cd /tmp/ctags && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local && \
    make && \
    make install
