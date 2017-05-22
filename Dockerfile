FROM zeroc0d3lab/centos-base:latest
MAINTAINER ZeroC0D3 Team <zeroc0d3.team@gmail.com>

ENV CONSULTEMPLATE_VERSION=0.18.3

RUN mkdir -p /var/lib/consul \
    && groupadd consul \
    && useradd -r -g consul consul \
    && chown -R consul:consul /var/lib/consul

RUN yum makecache fast \
    && yum -y update \
    && yum -y install git \
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

    && curl -sSL https://releases.hashicorp.com/consul-template/${CONSULTEMPLATE_VERSION}/consul-template_${CONSULTEMPLATE_VERSION}_linux_amd64.zip -o /tmp/consul-template.zip \
    && unzip /tmp/consul-template.zip -d /bin \
    && rm -f /tmp/consul-template.zip \
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
    && mv /root/tmux /root/.tmux

## INSTALL tmux
RUN cd /tmp/tmux \
    && /bin/sh autogen.sh \
    && /bin/sh ./configure \
    && sudo make \
    && sudo make install

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
    && wget https://raw.githubusercontent.com/zeroc0d3/vim-ide/master/step02.sh \
    && /bin/sh step02.sh

## DOWNLOAD & INSTALL vim themes
RUN git clone https://github.com/dracula/dracula-theme.git /tmp/themes/dracula-theme --recursive \
    && git clone https://github.com/blueshirts/darcula.git /tmp/themes/darcula --recursive \
    && sudo cp /tmp/themes/dracula-theme/vim/colors/dracula.vim /root/.vim/bundle/vim-colors/colors/dracula.vim \
    && sudo cp /tmp/themes/darcula/colors/darcula.vim /root/.vim/bundle/vim-colors/colors/darcula.vim

## DOWNLOAD & INSTALL dircolors
RUN git clone https://github.com/sigurdga/gnome-terminal-colors-solarized.git /root/solarized \
    && mv /root/solarized /root/.solarized

COPY rootfs/ /

HEALTHCHECK CMD /etc/cont-consul/check || exit 1

EXPOSE 22

VOLUME ["/sys/fs/cgroup", "/tmp"]
CMD ["/usr/sbin/init"]

## NOTE:
## *) Run vim then >> :PluginInstall
## *) Update plugin vim (vundle) >> :PluginUpdate
