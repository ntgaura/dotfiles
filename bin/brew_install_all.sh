#! /bin/bash

read -sp "Password: " PASSWORD
sudo -S -v <<< ${PASSWORD} 2> /dev/null

brew install git
brew install zsh
brew tap neovim/neovim
brew install neovim
brew install python
brew install python3
pip2 install neovim --upgrade
pip3 install neovim --upgrade
sudo -S gem install neovim
brew cask install iterm2
brew cask install skype
brew install fzf
brew install fzy
brew install peco
brew install ghq
brew install rust
brew install rename
brew cask install kindle
brew install rbenv
brew install youtube-dl
brew install percol
brew install mplayer
brew install pyenv
brew install terraform
brew install aws-shell
brew install direnv
brew install docker
brew cask install docker
brew cask install ngrok
brew install imagemagick
brew cask install java
brew install sbt
brew install pyenv-virtualenv
brew install tree
brew install jq
brew install go
brew install glide
brew install haskell-stack
stack setup
brew install zlib
brew cask install hyperswitch
brew cask install virtualbox
brew install kubernetes-cli
brew cask install minikube
brew cask install marp
brew install coreutils
brew install git-crypt
brew install terminal-notifier
brew cask install clipy
brew install ncdu

brew install mas
mas install 405843582 # Alfred
mas install 425424353 # The Unarchiver
mas install 441258766 # Magnet
mas install 409183694 # Keynote
mas install 803453959 # Slack
mas install 409201541 # Pages
mas install 539883307 # LINE
mas install 508957583 # Nozbe
mas install 409203825 # Numbers
mas install 405399194 # Kindle
mas install 414855915 # WinArchiver Lite
mas install 409789998 # Twitter
mas install 528183797 # Joystick Mapper
mas install 515886877 # Joystick Show

echo "====== brew install all done! ======"
