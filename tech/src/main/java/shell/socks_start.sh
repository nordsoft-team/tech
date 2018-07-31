#!/bin/bash
networksetup -setsocksfirewallproxystate 'Wi-Fi' off;

txt=`http https://my.ishadowx.net/ | egrep 'IP Address:|Port:|Password:|Method:'|awk -Fspan '{print $2}'|awk -F\> '{print $2}'|awk -F\< '{print $1}'`
echo $txt > abcd.txt

if [[ $1 != "" && $1 -ge "0" && $1 -lt "9" ]]
then
	let a=$1
else
	let a=$RANDOM%9
fi

let a=3*a+1
let b=a+1
let c=b+1

server=`awk '{print $"'"$a"'"}' abcd.txt`
port=`awk '{print $"'"$b"'"}' abcd.txt`
password=`awk '{print $"'"$c"'"}' abcd.txt`

# echo $server
# echo $port
# echo $password
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