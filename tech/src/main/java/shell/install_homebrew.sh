#!/bin/bash
sudo rm -rf /usr/local/Homebrew
sudo mkdir -p /usr/local/Homebrew
sudo git clone https://mirrors.ustc.edu.cn/brew.git /usr/local/Homebrew

sudo rm -rf /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core
sudo mkdir -p /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core
sudo git clone https://github.com/Homebrew/brew.git /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core

sudo rm -rf /usr/local/bin/brew
sudo ln -s /usr/local/Homebrew/bin/brew /usr/local/bin/brew
sudo chown -R $(whoami) /usr/local/Homebrew
chmod u+w /usr/local/Homebrew
sudo chown -R $(whoami) /usr/local/var/homebrew

echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles' >> ~/.bash_profile
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles' >> ~/.zshrc
source ~/.bash_profile
source ~/.zshrc

echo "brew doctor"
brew doctor
echo "brew update"
brew update

echo "abcd" | pbcopy
rm -rf abcd