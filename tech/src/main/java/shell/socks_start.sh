#!/bin/bash

#brew install httpie
#brew install shadowsocks-libev
#brew install polipo

cd ~
networksetup -setsocksfirewallproxystate 'Wi-Fi' off;

txt=`http https://free.ishadowx.org/ | egrep 'IP Address:|Port:|Password:|Method:'|awk -Fspan '{print $2}'|awk -F\> '{print $2}'|awk -F\< '{print $1}'`
echo $txt > abcd.txt


if [[ $1 == "" ]]
then 
	let a=0
elif [[ $1 -lt "0" || $1 -gt "8" || ($1 -gt "2" && $1 -lt "6")]]
then
	echo 'PLEASE INPUT CORRECT PARAMETER (0-2, 6-8) OR JUST DO NOT INPUT PARAMETER'
	exit
else
	let a=$1
fi


let a=3*a+1
let b=a+1
let c=b+1

server=`awk '{print $"'"$a"'"}' abcd.txt`
port=`awk '{print $"'"$b"'"}' abcd.txt`
password=`awk '{print $"'"$c"'"}' abcd.txt`

echo
echo '==> SOCKS INFO:'
echo SERVER:$server
echo PORT:$port
echo PASSWORD:$password
echo
echo '==> PROXY INFO:'
echo SERVER:`ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'`
echo PORT:8123
echo

# echo $a
# echo $b
# echo $c

sed -i "" 's/"server".*$/"server":"'"$server"'",/g' /usr/local/etc/shadowsocks-libev.json
sed -i "" 's/"server_port".*$/"server_port":'"$port"',/g' /usr/local/etc/shadowsocks-libev.json
sed -i "" 's/"password".*$/"password":"'"$password"'",/g' /usr/local/etc/shadowsocks-libev.json
sed -i "" 's/"method".*$/"method":"aes-256-cfb"/g' /usr/local/etc/shadowsocks-libev.json

rm abcd.txt


brew services restart shadowsocks-libev;
networksetup -setsocksfirewallproxy 'Wi-Fi' 'localhost' '1080';

cd /usr/local/opt/polipo
plutil -replace ProgramArguments -json "[]" homebrew.mxcl.polipo.plist
plutil -insert ProgramArguments.0 -string "/usr/local/opt/polipo/bin/polipo" homebrew.mxcl.polipo.plist
plutil -insert ProgramArguments.1 -string "proxyAddress=0.0.0.0" homebrew.mxcl.polipo.plist
plutil -insert ProgramArguments.2 -string "socksParentProxy=localhost:1080" homebrew.mxcl.polipo.plist

brew services restart polipo;
cd ~
