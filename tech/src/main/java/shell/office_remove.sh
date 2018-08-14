#!/bin/bash

function removeFile(){
    if [[ $1 == *microsoft* ]] || [[ $1 == *Microsoft* ]] || [[ $1 == *UBF8T346G9* ]]
    then
    	echo "$1"
    	rm -rf "$1"
    fi
}


for file in /Applications/*
do
	removeFile "$file"
done

for file in /Library/Application\ Support/*
do
	removeFile "$file"
done

for file in /Library/LaunchDaemons/*
do
	removeFile "$file"
done

for file in /Library/Preferences/*
do
	removeFile "$file"
done

for file in /Library/PrivilegedHelperTools/*
do
	removeFile "$file"
done

for file in ~/Library/Containers/*
do
	removeFile "$file"
done

for file in ~/Library/Group\ Containers/*
do
	removeFile "$file"
done

for file in ~/Library/Preferences/*
do
	removeFile "$file"
done