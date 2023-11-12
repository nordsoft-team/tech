# use brew or use node-v20.9.0.pkg
brew install node@20
echo 'export PATH="/usr/local/opt/node@20/bin:$PATH"' >> ~/.zshrc
sudo chown -R $(whoami) ~/.npm
sudo chown -R $(whoami) /usr/local/lib/node_modules

# install angular
npm install -g @angular/cli
ng add @angular/material
ng new exam-frontend