#!/bin/bash
cd
xcode-select --install
sudo /usr/bin/xcode-select --switch /Library/Developer/CommandLineTools

export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.bfsu.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.bfsu.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.bfsu.edu.cn/homebrew-bottles"

git clone --depth=1 https://mirrors.bfsu.edu.cn/git/homebrew/install.git brew-install
/bin/bash brew-install/install.sh
rm -rf brew-install

#git clone https://mirrors.bfsu.edu.cn/git/homebrew/homebrew-cask.git /opt/homebrew/Library/Taps/homebrew/homebrew-cask
#git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.bfsu.edu.cn/git/homebrew/homebrew-cask.git
#brew install --cask xxx
#brew info --cask xxx

grep -qF '/opt/homebrew/bin' /etc/paths || sudo sed -i "" $'1i\\\n/opt/homebrew/bin\n' /etc/paths
grep -qF '/opt/homebrew/share/man' /etc/manpaths || sudo sed -i "" $'1i\\\n/opt/homebrew/share/man\n' /etc/manpaths

git -C "$(/opt/homebrew/bin/brew --repo)" remote set-url origin https://mirrors.bfsu.edu.cn/git/homebrew/brew.git
git -C "$(/opt/homebrew/bin/brew --repo homebrew/core)" remote set-url origin https://mirrors.bfsu.edu.cn/git/homebrew/homebrew-core.git

/opt/homebrew/bin/brew update-reset
echo 'export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.bfsu.edu.cn/homebrew-bottles"' >> ~/.zshrc

echo "Installation successful! Open a new terminal window to use!"
echo "abcd" | pbcopy
rm -rf ~/abcd