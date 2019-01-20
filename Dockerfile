FROM ubuntu:18.10
MAINTAINER Sam Paul <sampaulmobile@gmail.com>

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y make build-essential software-properties-common \
  libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
  llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
  libffi-dev wget curl man zsh vim git tmux ripgrep

# clone dotfiles
RUN git clone https://github.com/sampaulmobile/dotfiles.git ~/dotfiles

# Install oh-my-zsh
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && chsh -s /bin/zsh

# symlink dots (and some others)
RUN ~/dotfiles/bin/symlink_files.sh

# setup vim
RUN ~/dotfiles/bin/install_vim_plug.sh
RUN ~/dotfiles/bin/update_vim_plugs.sh
# RUN /scripts/setup_ycm.sh

# setup zsh shell/prompt
RUN ~/dotfiles/bin/install_zsh_syntax_highlighting.sh
RUN ~/dotfiles/bin/zsh_git_prompt.sh

# install pyenv/python
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
ENV PYTHON_CONFIGURE_OPTS --enable-shared
RUN pyenv install 3.7.0 && \
    pyenv global 3.7.0
RUN ~/dotfiles/bin/pip_installs.sh

# install tpm/plugins
RUN ~/dotfiles/bin/install_tpm.sh
RUN ~/dotfiles/bin/update_tpm_plugins.sh

WORKDIR /root
CMD ["zsh"]
