FROM zeroc0d3lab/centos-base:latest
MAINTAINER ZeroC0D3 Team <zeroc0d3.team@gmail.com>

## SET ENVIRONMENT ##
ENV CONSUL_VERSION=0.8.3 \
    CONSULUI_VERSION=0.8.3 \
    CONSULTEMPLATE_VERSION=0.18.3 \
    RUBY_VERSION=2.4.1

RUN mkdir -p /var/lib/consul \
    && groupadd consul \
    && useradd -r -g consul consul \
    && chown -R consul:consul /var/lib/consul

## FIND FASTEST REPO & UPDATE REPO ##
RUN yum makecache fast \
    && yum -y update

## INSTALL WORKSPACE DEPENDENCY ##
RUN yum -y install git \
         nano \
         zip \
         unzip \
         zsh \
         gcc \
         automake \
         make \
         libevent-devel \
         ncurses-devel \
         glibc-static \
         nodejs \

    && curl -sSL https://releases.hashicorp.com/consul/${CONSULUI_VERSION}/consul_${CONSULUI_VERSION}_linux_amd64.zip -o /tmp/consul.zip \
    && unzip /tmp/consul.zip -d /bin \
    && rm /tmp/consul.zip \
    && mkdir -p /var/lib/consului \
    && curl -sSL https://releases.hashicorp.com/consul/${CONSULUI_VERSION}/consul_${CONSULUI_VERSION}_web_ui.zip -o /tmp/consului.zip \
    && unzip /tmp/consului.zip -d /var/lib/consului \
    && rm /tmp/consului.zip \
    && curl -sSL https://releases.hashicorp.com/consul-template/${CONSULTEMPLATE_VERSION}/consul-template_${CONSULTEMPLATE_VERSION}_linux_amd64.zip -o /tmp/consul-template.zip \
    && unzip /tmp/consul-template.zip -d /bin \
    && rm -f /tmp/consul-template.zip

## INSTALL RUBY DEPENDENCY ##
RUN yum -y install git-core \
         zlib \
         zlib-devel \
         gcc-c++ \
         patch \
         readline \
         readline-devel \
         libyaml-devel \
         libffi-devel \
         openssl-devel \
         make \
         bzip2 \
         bison \
         autoconf \
         automake \
         libtool \
         sqlite-devel \

## CLEAN UP ALL CACHE ##
    && yum clean all

## DOWNLOAD & INSTALL
## - bash_it (bash + themes)
## - oh-my-zsh (zsh + themes)
RUN rm -rf /root/.bash_it \
    && rm -rf /root/.oh-my-zsh \
    && touch /root/.bashrc \
    && touch /root/.zshrc \
    && cd /root \
    && git clone https://github.com/Bash-it/bash-it.git /root/bash_it \
    && git clone https://github.com/speedenator/agnoster-bash.git /root/bash_it/themes/agnoster-bash \
    && git clone https://github.com/robbyrussell/oh-my-zsh.git /root/oh-my-zsh \
    && mv /root/bash_it /root/.bash_it \
    && mv /root/oh-my-zsh /root/.oh-my-zsh

## DOWNLOAD tmux + themes
RUN rm -rf /tmp/tmux \
    && rm -rf /root/.tmux/plugins/tpm \
    && touch /root/.tmux.conf \
    && git clone https://github.com/tmux-plugins/tpm.git /root/tmux/plugins/tpm \
    && git clone https://github.com/tmux/tmux.git /tmp/tmux \
    && git clone https://github.com/seebi/tmux-colors-solarized.git /root/tmux-colors-solarized \
    && mv /root/tmux /root/.tmux

## INSTALL tmux
RUN cd /tmp/tmux \
    && /bin/sh autogen.sh \
    && /bin/sh ./configure \
    && sudo make \
    && sudo make install

## DOWNLOAD & INSTALL dircolors
RUN git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git /root/solarized \
    && mv /root/solarized /root/.solarized

## DOWNLOAD vim
RUN git clone https://github.com/vim/vim.git /root/vim

## INSTALL vim
RUN cd /root/vim/src \
    && /bin/sh ./configure \
    && sudo make \
    && sudo make install \
    && sudo mkdir /usr/share/vim \
    && sudo mkdir /usr/share/vim/vim80/ \
    && sudo cp -fr /root/vim/runtime/* /usr/share/vim/vim80/ \
    && git clone https://github.com/zeroc0d3/vim-ide.git /root/vim-ide \
    && /bin/sh /root/vim-ide/step02.sh

## DOWNLOAD & INSTALL vim themes
RUN git clone https://github.com/dracula/vim.git /tmp/themes/dracula \
    && git clone https://github.com/blueshirts/darcula.git /tmp/themes/darcula \
    && sudo cp /tmp/themes/dracula/colors/dracula.vim /root/.vim/bundle/vim-colors/colors/dracula.vim \
    && sudo cp /tmp/themes/darcula/colors/darcula.vim /root/.vim/bundle/vim-colors/colors/darcula.vim

## INSTALL ruby ##
# - copy .zshrc & .bashrc for installation
COPY ./rootfs/root/.zshrc /root/.zshrc
COPY ./rootfs/root/.bashrc /root/.bashrc

## INSTALL  rbenv (default) ##
RUN git clone https://github.com/rbenv/rbenv.git /root/.rbenv \
    && git clone https://github.com/rbenv/ruby-build.git /root/.rbenv/plugins/ruby-build \
    && ./root/.rbenv/bin/rbenv install ${RUBY_VERSION} \
    && ./root/.rbenv/bin/rbenv global ${RUBY_VERSION} \
    && ./root/.rbenv/bin/rbenv rehash \
    && ./root/.rbenv/shims/ruby -v

## INSTALL rvm (alternatives) ##
# RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
#     && curl -sSL https://get.rvm.io | bash -s stable \
#     && ./root/.rvm/scripts/rvm install ${RUBY_VERSION} \
#     && ./root/.rvm/scripts/rvm use ${RUBY_VERSION} --default
#     && ./usr/bin/ruby -v

## INSTALL bundler, rails, docker-api & other ruby packages
RUN ./root/.rbenv/shims/gem install bundler \
    && ./root/.rbenv/shims/gem install rails \
    && ./root/.rbenv/shims/gem install rspec \
    && ./root/.rbenv/shims/gem install serverspec \
    && ./root/.rbenv/shims/gem install docker-api \
    && ./root/.rbenv/shims/gem install sqlite3 \
    && ./root/.rbenv/shims/gem install mongoid \
    && ./root/.rbenv/shims/gem install sequel \
##  Skip gems installation (need other containers)
#   && ./root/.rbenv/shims/gem install pg \
#   && ./root/.rbenv/shims/gem install mysql2 \
#   && ./root/.rbenv/shims/gem install sequel_pg \
    && ./root/.rbenv/shims/gem install apktools

## INSTALL Javascipt Unit Test
RUN ./usr/bin/npm install chai \
    && ./usr/bin/npm install tv4 \
    && ./usr/bin/npm install newman \

## INSTALL Yarn, Bower, Grunt, Gulp, Yeoman
    && ./usr/bin/npm install bower \
    && ./usr/bin/npm install grunt \
    && ./usr/bin/npm install gulp \
    && ./usr/bin/npm install yo

## INSTALL Composer
RUN wget https://getcomposer.org/download/1.4.2/composer.phar -O /usr/local/bin/composer \
    && sudo chmod +x /usr/local/bin/composer

## FINALIZE (reconfigure) ##
COPY rootfs/ /

## RUN INIT ##
ENTRYPOINT ["/init"]
CMD []

## SET PORT ##
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8501 8600 8600/udp

## SET VOLUME ##
VOLUME ["/var/lib/consul"]

## CHECK DOCKER CONTAINER ##
HEALTHCHECK CMD /etc/cont-consul/check || exit 1
# HEALTHCHECK CMD [ $(curl -sI -w '%{http_code}' --out /dev/null http://localhost:8500/v1/agent/self) == "200" ] || exit 1

## NOTE:
## *) Run vim then >> :PluginInstall
## *) Update plugin vim (vundle) >> :PluginUpdate
