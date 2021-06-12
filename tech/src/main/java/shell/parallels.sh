sudo cp /Library/Preferences/Parallels/network.desktop.xml /Library/Preferences/Parallels/network.desktop.xml.default
sudo sed -i '' 's/>-1</>0</g' /Library/Preferences/Parallels/network.desktop.xml
