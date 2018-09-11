#!/usr/bin/env bash

# install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# coreutils
brew install coreutils

# Install `wget`
brew install wget

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep

# install  useful libraries
brew install git
brew install bash-completion
brew install httpie
brew install tree
brew install htop

# install dev
brew install node
npm install -g create-react-app

# Remove outdated versions from the cellar.
brew cleanup