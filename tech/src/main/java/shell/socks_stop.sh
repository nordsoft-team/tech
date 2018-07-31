#!/bin/bash
networksetup -setsocksfirewallproxystate 'Wi-Fi' off;
brew services start shadowsocks-libev; 
brew services stop shadowsocks-libev; 