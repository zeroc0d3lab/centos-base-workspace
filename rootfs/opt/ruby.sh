#!/bin/sh

### Path Ruby RBENV / RVM ###
export RBENV_ROOT="$HOME/.rbenv"
export RVM_ROOT="/usr/local/rvm"

### rbenv (Ruby) default ###
if [ -d "$RBENV_ROOT" ] 
then
  # echo "Using rbenv"
  # echo "--------------------------"
  export PATH="$RBENV_ROOT/bin:${PATH}"
  eval "$(rbenv init -)"
  export PATH="$RBENV_ROOT/plugins/ruby-build/bin:$PATH"
  # export RAILS_ENV=staging
else
  ### rvm (Ruby) - alternative ###
  if [ -d "$RVM_ROOT" ] 
  then
    # echo "Using rvm"
    # echo "--------------------------"
    export PATH="$PATH:$RVM_ROOT/bin"
    source $RVM_ROOT/scripts/rvm

    # Set PATH alternatives using this:
    [[ -s "$RVM_ROOT/scripts/rvm"  ]] && source "$RVM_ROOT/scripts/rvm"

    ### rvm selector ###
    # function gemdir {
    #   if [[ -z "$1" ]] ; then
    #     echo "gemdir expects a parameter, which should be a valid RVM Ruby selector"
    #   else
    #     rvm "$1"
    #     cd $(rvm gemdir)
    #     pwd
    #   fi
    # }
  fi 
fi