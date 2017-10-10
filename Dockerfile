FROM zeroc0d3lab/centos-base:latest
MAINTAINER ZeroC0D3 Team <zeroc0d3.team@gmail.com>

#-----------------------------------------------------------------------------
# Set Environment
#-----------------------------------------------------------------------------
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=1 \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    TERM=xterm \
    CONSUL_VERSION=0.8.3 \
    CONSULUI_VERSION=0.8.3 \
    CONSULTEMPLATE_VERSION=0.18.3 \
    RUBY_VERSION=2.4.1

#-----------------------------------------------------------------------------
# Set Group & User for 'consul'
#-----------------------------------------------------------------------------
RUN mkdir -p /var/lib/consul \
    && groupadd consul \
    && useradd -r -g consul consul \
    && chown -R consul:consul /var/lib/consul

#-----------------------------------------------------------------------------
# Find Fastest Repo & Update Repo
#-----------------------------------------------------------------------------
RUN yum makecache fast \
    && yum -y update

#-----------------------------------------------------------------------------
# Install Workspace Dependency
#-----------------------------------------------------------------------------
RUN yum -y install \
           --setopt=tsflags=nodocs \
           --disableplugin=fastestmirror \
         git \
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
         fontconfig \

#-----------------------------------------------------------------------------
# Install MySQL (MariaDB) Library
#-----------------------------------------------------------------------------
         mysql-devel \

#-----------------------------------------------------------------------------
# Install PostgreSQL Library
#-----------------------------------------------------------------------------
### PostgreSQL 9.2 (default)###
         postgresql-libs \
         postgresql-devel \

### PostgreSQL 9.6 ###
    && rpm -iUvh https://yum.postgresql.org/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm \
    && yum install -y postgresql96-libs postgresql96-server postgresql96-devel \

#-----------------------------------------------------------------------------
# Install Consul Library
#-----------------------------------------------------------------------------
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

#-----------------------------------------------------------------------------
# Install Ruby Dependency
#-----------------------------------------------------------------------------
RUN yum -y install \
           --setopt=tsflags=nodocs \
           --disableplugin=fastestmirror \
         git-core \
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
         sqlite-devel

#-----------------------------------------------------------------------------
# Install NodeJS
#-----------------------------------------------------------------------------
# RUN yum -y install nodejs npm --enablerepo=epel \
RUN yum -y install https://kojipkgs.fedoraproject.org//packages/http-parser/2.7.1/3.el7/x86_64/http-parser-2.7.1-3.el7.x86_64.rpm nodejs \


#-----------------------------------------------------------------------------
# Clean Up All Cache
#-----------------------------------------------------------------------------
    && yum clean all

#-----------------------------------------------------------------------------
# Setup Locale UTF-8
#-----------------------------------------------------------------------------
RUN ["/usr/bin/localedef", "-i", "en_US", "-f", "UTF-8", "en_US.UTF-8"]

#-----------------------------------------------------------------------------
# Download & Install
# -) bash_it (bash + themes)
# -) oh-my-zsh (zsh + themes)
#-----------------------------------------------------------------------------
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

#-----------------------------------------------------------------------------
# Download & Install
# -) tmux + themes
#-----------------------------------------------------------------------------
RUN rm -rf /tmp/tmux \
    && rm -rf /root/.tmux/plugins/tpm \
    && touch /root/.tmux.conf \
    && git clone https://github.com/tmux-plugins/tpm.git /root/tmux/plugins/tpm \
    && git clone https://github.com/tmux/tmux.git /tmp/tmux \
    && git clone https://github.com/seebi/tmux-colors-solarized.git /root/tmux-colors-solarized \
    && mv /root/tmux /root/.tmux

RUN cd /tmp/tmux \
    && /bin/sh autogen.sh \
    && /bin/sh ./configure \
    && sudo make \
    && sudo make install

#-----------------------------------------------------------------------------
# Install Font Config
#-----------------------------------------------------------------------------
RUN mkdir -p /root/.fonts \
    && mkdir -p /root/.config/fontconfig/conf.d/ \
    && mkdir -p /usr/share/fonts/local \
    && wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf -O /root/.fonts/PowerlineSymbols.otf \
    && wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf -O /root/.config/fontconfig/conf.d/10-powerline-symbols.conf \
    && cp /root/.fonts/PowerlineSymbols.otf /usr/share/fonts/local/PowerlineSymbols.otf \
    && cp /root/.fonts/PowerlineSymbols.otf /usr/share/fonts/PowerlineSymbols.otf \
    && cp /root/.config/fontconfig/conf.d/10-powerline-symbols.conf /etc/fonts/conf.d/10-powerline-symbols.conf \
    && ./usr/bin/fc-cache -vf /root/.fonts/ \
    && ./usr/bin/fc-cache -vf /usr/share/fonts

#-----------------------------------------------------------------------------
# Download & Install
# -) dircolors (terminal colors)
#-----------------------------------------------------------------------------
RUN git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git /root/solarized \
    && mv /root/solarized /root/.solarized

#-----------------------------------------------------------------------------
# Download & Install
# -) vim
# -) vundle + themes
#-----------------------------------------------------------------------------
RUN git clone https://github.com/vim/vim.git /root/vim

RUN cd /root/vim/src \
    && /bin/sh ./configure \
    && sudo make \
    && sudo make install \
    && sudo mkdir /usr/share/vim \
    && sudo mkdir /usr/share/vim/vim80/ \
    && sudo cp -fr /root/vim/runtime/* /usr/share/vim/vim80/ \
    && git clone https://github.com/zeroc0d3/vim-ide.git /root/vim-ide \
    && /bin/sh /root/vim-ide/step02.sh

RUN git clone https://github.com/dracula/vim.git /tmp/themes/dracula \
    && git clone https://github.com/blueshirts/darcula.git /tmp/themes/darcula \
    && sudo cp /tmp/themes/dracula/colors/dracula.vim /root/.vim/bundle/vim-colors/colors/dracula.vim \
    && sudo cp /tmp/themes/darcula/colors/darcula.vim /root/.vim/bundle/vim-colors/colors/darcula.vim

#-----------------------------------------------------------------------------
# Prepare Install Ruby
# -) copy .zshrc to /root
# -) copy .bashrc to /root
#-----------------------------------------------------------------------------
COPY ./rootfs/root/.zshrc /root/.zshrc
COPY ./rootfs/root/.bashrc /root/.bashrc

#-----------------------------------------------------------------------------
# Install Ruby with rbenv (default)
#-----------------------------------------------------------------------------
RUN git clone https://github.com/rbenv/rbenv.git /root/.rbenv \
    && git clone https://github.com/rbenv/ruby-build.git /root/.rbenv/plugins/ruby-build \
    && ./root/.rbenv/bin/rbenv install ${RUBY_VERSION} \
    && ./root/.rbenv/bin/rbenv global ${RUBY_VERSION} \
    && ./root/.rbenv/bin/rbenv rehash \
    && ./root/.rbenv/shims/ruby -v

#-----------------------------------------------------------------------------
# Install Ruby with rvm (alternatives)
#-----------------------------------------------------------------------------
# RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
#     && curl -sSL https://get.rvm.io | bash -s stable \
#     && ./root/.rvm/scripts/rvm install ${RUBY_VERSION} \
#     && ./root/.rvm/scripts/rvm use ${RUBY_VERSION} --default
#     && ./usr/bin/ruby -v

#-----------------------------------------------------------------------------
# Copy package dependencies in Gemfile
#-----------------------------------------------------------------------------
COPY ./rootfs/root/Gemfile /root/Gemfile
COPY ./rootfs/root/Gemfile.lock /root/Gemfile.lock

#-----------------------------------------------------------------------------
# Install Ruby Packages (rbenv/rvm)
#-----------------------------------------------------------------------------
COPY ./rootfs/root/gems.sh /root/gems.sh
RUN chmod a+x /root/gems.sh \
    && ./root/gems.sh

#-----------------------------------------------------------------------------
# Install Javascipt Unit Test
#-----------------------------------------------------------------------------
RUN ./usr/bin/npm install chai \
    && ./usr/bin/npm install tv4 \
    && ./usr/bin/npm install newman \

#-----------------------------------------------------------------------------
# Install Javascipt Packages Manager
#-----------------------------------------------------------------------------
    && ./usr/bin/npm install --global yarn \
    && ./usr/bin/npm install --global bower \
    && ./usr/bin/npm install --global grunt \
    && ./usr/bin/npm install --global gulp \
    && ./usr/bin/npm install --global yo

#-----------------------------------------------------------------------------
# Upgrade Javascipt Packages Manager
#-----------------------------------------------------------------------------
RUN ./usr/bin/npm upgrade --global chai \
    && ./usr/bin/npm upgrade --global tv4 \
    && ./usr/bin/npm upgrade --global newman \
    && ./usr/bin/npm upgrade --global yarn \
    && ./usr/bin/npm upgrade --global bower \
    && ./usr/bin/npm upgrade --global grunt \
    && ./usr/bin/npm upgrade --global gulp \
    && ./usr/bin/npm upgrade --global yo

#-----------------------------------------------------------------------------
# Move 'node_modules' To 'root' Folder
#-----------------------------------------------------------------------------
RUN mv /node_modules /root/node_modules

#-----------------------------------------------------------------------------
# Install Composer PHP Packages Manager
#-----------------------------------------------------------------------------
RUN wget https://getcomposer.org/download/1.4.2/composer.phar -O /usr/local/bin/composer \
    && sudo chmod +x /usr/local/bin/composer

#-----------------------------------------------------------------------------
# Setup TrueColors (Terminal)
#-----------------------------------------------------------------------------
COPY ./rootfs/root/colors/24-bit-color.sh /root/colors/24-bit-color.sh
RUN chmod a+x /root/colors/24-bit-color.sh \
    ./root/colors/24-bit-color.sh

#-----------------------------------------------------------------------------
# Finalize (reconfigure)
#-----------------------------------------------------------------------------
COPY rootfs/ /

#-----------------------------------------------------------------------------
# Run Init Docker Container
#-----------------------------------------------------------------------------
ENTRYPOINT ["/init"]
CMD []

## NOTE:
## *) Run vim then >> :PluginInstall
## *) Update plugin vim (vundle) >> :PluginUpdate
