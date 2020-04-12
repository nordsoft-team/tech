#!/bin/bash
sudo rm -rf /usr/local/Homebrew
sudo mkdir -p /usr/local/Homebrew
sudo git clone https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git /usr/local/Homebrew

sudo rm -rf /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core
sudo mkdir -p /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core
sudo git clone https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core

sudo ln -s /usr/local/Homebrew/bin/brew /usr/local/bin/brew
sudo chown -R $(whoami) /usr/local/Homebrew
chmod u+w /usr/local/Homebrew

echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles' >> ~/.bash_profile
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles' >> ~/.zshrc
source ~/.bash_profile
source ~/.zshrc

echo "brew doctor"
brew doctor
echo "brew update"
brew update


#cd "$(brew --repo)"
#git remote set-url origin https://mirrors.aliyun.com/homebrew/brew.git
#cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
#git remote set-url origin https://mirrors.aliyun.com/homebrew/homebrew-core.git

#cd "$(brew --repo)"
#git remote set-url origin https://github.com/Homebrew/brew.git
#cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
#git remote set-url origin https://github.com/Homebrew/homebrew-core.git

echo "abcd" | pbcopy
rm -rf abcd