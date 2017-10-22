#!/bin/sh

DATE=`date '+%Y-%m-%d %H:%M:%S'`
DEFAULT_VERSION='2.4.2'
DEFAULT_PACKAGE='rbenv'

logo() {
  echo "--------------------------------------------------------------------------"
  echo "  __________                  _________ _______       .___________        "
  echo "  \____    /___________  ____ \_   ___ \\   _  \    __| _/\_____  \  LAB  "
  echo "    /     // __ \_  __ \/  _ \/    \  \//  /_\  \  / __ |   _(__  <       "
  echo "   /     /\  ___/|  | \(  <_> )     \___\  \_/   \/ /_/ |  /       \      "
  echo "  /_______ \___  >__|   \____/ \______  /\_____  /\____ | /______  /      "
  echo "          \/   \/                     \/       \/      \/        \/       "
  echo "--------------------------------------------------------------------------"
  echo " Date / Time: $DATE"
}

check_version() {
  if [ "${RUBY_VERSION}" = "" ]
  then
    INSTALL_VERSION = $DEFAULT_VERSION
  else
    INSTALL_VERSION = ${RUBY_VERSION}   
  fi
}

check_ruby_package() {
  if [ "${RUBY_VERSION}" = "" ]
  then
    INSTALL_PACKAGE = $DEFAULT_PACKAGE
  else
    INSTALL_PACKAGE = ${RUBY_PACKAGE}   
  fi
}

load_env() {
  echo "--------------------------------------------------------------------------"
  echo "## Load Environment: "
  echo "   $HOME/.bashrc"
  source ~/.bashrc
  exec $SHELL
}

install_ruby() {
  if [ "$INSTALL_PACKAGE" = "rbenv" ]
  then
    #-----------------------------------------------------------------------------
    # Install Ruby with rbenv (default)
    #-----------------------------------------------------------------------------
    git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv \
    && git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build \
    && exec $SHELL \
    && $HOME/.rbenv/bin/rbenv install $INSTALL_VERSION \
    && $HOME/.rbenv/bin/rbenv global $INSTALL_VERSION \
    && $HOME/.rbenv/bin/rbenv rehash \
    && $HOME/.rbenv/shims/ruby -v
  else
    #-----------------------------------------------------------------------------
    # Install Ruby with rvm (alternatives)
    #-----------------------------------------------------------------------------
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
    && curl -sSL https://get.rvm.io | sudo bash -s stable \
    && sudo usermod -a -G rvm root \
    && sudo usermod -a -G rvm docker \
    && source ~/.bashrc \
    && /usr/local/rvm/bin/rvm install $INSTALL_VERSION \
    && /usr/local/rvm/bin/rvm use $INSTALL_VERSION --default \
    && /usr/bin/ruby -v
  fi
}

check(){
  echo "--------------------------------------------------------------------------"
  echo "## Ruby Version: "
  RUBY=`which ruby`
  RUBY_V=`$RUBY -v`
  echo "   $RUBY_V"
  echo "--------------------------------------------------------------------------"
  echo "## Path Ruby: "
  echo "   $RUBY"
  echo "--------------------------------------------------------------------------"
  echo "## Path Gem: "
  GEM=`which gem`
  echo "   $GEM"
}

install_bundle() {
  echo "--------------------------------------------------------------------------"
  echo "## Install Bundle: "
  echo "   $GEM install bundle"
  $GEM install bundle
}

main() {
  logo
  check_version
  check_ruby_package
  install_ruby
  load_env
  check
  install_bundle
}

### START HERE ###
main