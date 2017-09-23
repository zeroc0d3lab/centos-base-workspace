# CentOS Workspace Docker (Base-Workspace Container)
[![Build Status](https://travis-ci.org/zeroc0d3lab/centos-base-workspace.svg?branch=master)](https://travis-ci.org/zeroc0d3lab/centos-base-workspace) [![](https://images.microbadger.com/badges/image/zeroc0d3lab/centos-base-workspace:latest.svg)](https://microbadger.com/images/zeroc0d3lab/centos-base-workspace:latest "Layers") [![](https://images.microbadger.com/badges/version/zeroc0d3lab/centos-base-workspace:latest.svg)](https://microbadger.com/images/zeroc0d3lab/centos-base-workspace:latest "Version") [![GitHub issues](https://img.shields.io/github/issues/zeroc0d3lab/centos-base-workspace.svg)](https://github.com/zeroc0d3lab/centos-base-workspace/issues) [![GitHub forks](https://img.shields.io/github/forks/zeroc0d3lab/centos-base-workspace.svg)](https://github.com/zeroc0d3lab/centos-base-workspace/network) [![GitHub stars](https://img.shields.io/github/stars/zeroc0d3lab/centos-base-workspace.svg)](https://github.com/zeroc0d3lab/centos-base-workspace/stargazers) [![GitHub license](https://img.shields.io/badge/license-GPLv2-blue.svg)](https://raw.githubusercontent.com/zeroc0d3lab/centos-base-workspace/master/LICENSE)

This docker image includes:

## Features:
* bash (+ themes)
* oh-my-zsh (+ themes)
* tmux (+ themes)
* vim (+ plugins with vundle & themes)
* rbenv / rvm
  - [X] gem test unit (rspec, serverspec)
  - [X] gem docker-api
  - [X] gem sqlite3, mongoid, sequel, apktools
  - [X] gem mysql2 (run: yum install -y mysql-devel)
  - [X] gem pg, sequel_pg (run: yum install -y postgresql-libs postgresql-devel)
  - [X] gem rubocop
* npm
  - [X] npm test unit (ChaiJS, TV4, Newman)
* js package manager
  - [X] yarn
  - [X] bower
  - [X] grunt
  - [X] gulp
  - [X] yeoman
* composer

## Notes:
* Run vim then
  ```
  :PluginInstall
  ```
* Update plugin vim (vundle)
  ```
  :PluginUpdate
  ```

## License
GNU General Public License v2
