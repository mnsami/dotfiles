#!/usr/bin/env bash

# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# coreutils
brew install coreutils

# Install `wget`
brew install wget

# Install more recent versions of some macOS tools.
brew install vim
brew install grep

# install  useful libraries
brew install git
brew install bash-completion
brew install httpie
brew install tree
brew install htop
brew install python

# install dev
brew install node
npm install -g create-react-app

# Remove outdated versions from the cellar.
brew cleanup
