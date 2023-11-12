# use brew or use node-v20.9.0.pkg
brew install node@20
echo 'export PATH="/usr/local/opt/node@20/bin:$PATH"' >> ~/.zshrc

# install angular
sudo npm install -g @angular/cli
ng new exam-frontend