#!/bin/bash
git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
/bin/bash -c "$(sed -e 's|^HOMEBREW_BREW_GIT_REMOTE=.*$|HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"|g' -e 's|HOMEBREW_CORE_GIT_REMOTE=.*$|HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"|g' brew-install/install.sh)"
rm -rf brew-install

grep -qF '/opt/homebrew/bin' /etc/paths || sudo sed -i "" '1i /opt/homebrew/bin' /etc/paths
grep -qF '/opt/homebrew/share/man' /etc/manpaths || sudo sed -i "" '1i /opt/homebrew/share/man' /etc/manpaths

git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git

brew update-reset

echo "abcd" | pbcopy
rm -rf ~/abcd