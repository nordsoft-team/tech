#!/bin/bash
networksetup -setsocksfirewallproxystate 'Wi-Fi' off;
brew services start polipo;
brew services stop polipo;
brew services start shadowsocks-libev; 
brew services stop shadowsocks-libev; 
