#!/bin/sh

#-----------------------------------------------------------------------------
# Download & Install
# -) vim
# -) vundle + themes
#-----------------------------------------------------------------------------
cd /usr/local/src \
# && sudo rm -rf /usr/local/share/vim /usr/bin/vim \
  && git clone https://github.com/vim/vim.git \
  && cd vim \
  && git checkout v${VIM_VERSION} \
  && cd src \
  && make autoconf \
  && ./configure \
          --prefix=/usr \
          --enable-multibyte \
          --enable-perlinterp=dynamic \
          --enable-rubyinterp=dynamic \
          --with-ruby-command=`which ruby` \
          --enable-pythoninterp=dynamic \
          --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
          --enable-python3interp \
          --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
          --enable-luainterp \
          --with-luajit \
          --with-lua-prefix=/usr/include/lua5.1 \
          --enable-cscope \
          --enable-gui=auto \
          --with-features=huge \
          --with-x \
          --enable-fontset \
          --enable-largefile \
          --disable-netbeans \
          --with-compiledby="ZeroC0D3 Team" \
          --enable-fail-if-missing \
  && make distclean \
  && make \
  && cp config.mk.dist auto/config.mk \
  && sudo make install \
  && sudo mkdir -p /usr/share/vim \
  && sudo mkdir -p /usr/share/vim/vim80/ \
  && sudo cp -fr /usr/local/src/vim/runtime/* /usr/share/vim/vim80/

git clone https://github.com/zeroc0d3/vim-ide.git $HOME/vim-ide \
  && sudo /bin/sh $HOME/vim-ide/step02.sh

git clone https://github.com/dracula/vim.git /opt/vim-themes/dracula \
  && git clone https://github.com/blueshirts/darcula.git /opt/vim-themes/darcula \
  && mkdir -p $HOME/.vim/bundle/vim-colors/colors \
  && cp /opt/vim-themes/dracula/colors/dracula.vim $HOME/.vim/bundle/vim-colors/colors/dracula.vim \
  && cp /opt/vim-themes/darcula/colors/darcula.vim $HOME/.vim/bundle/vim-colors/colors/darcula.vim
