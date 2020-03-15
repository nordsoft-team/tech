sudo rm -rf /usr/local/Homebrew
sudo mkdir /usr/local/Homebrew
sudo git clone https://mirrors.ustc.edu.cn/brew.git /usr/local/Homebrew

sudo rm -rf /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core
sudo mkdir /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core
sudo git clone https://mirrors.ustc.edu.cn/homebrew-core.git /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core

sudo ln -s /usr/local/Homebrew/bin/brew /usr/local/bin/brew
sudo chown -R $(whoami) /usr/local/Homebrew

echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.bash_profile
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.zshrc
brew doctor
brew update


#cd "$(brew --repo)"
#git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
#cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
#git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git

#cd "$(brew --repo)"
#git remote set-url origin https://github.com/Homebrew/brew.git
#cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
#git remote set-url origin https://github.com/Homebrew/homebrew-core.git

rm -rf abcd