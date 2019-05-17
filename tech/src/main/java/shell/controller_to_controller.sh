#!/bin/bash
if [[ $1 == "" ]]
then
	echo 'PLEASE INPUT PARAMETER FILE'
	exit
fi
cat $1 > abcd.txt

paste -s -d ' ' abcd.txt > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/(public BaseResponse.*? )(.*?)(\(.*? )\{(.*?;     )\}/\1\2\3\{return service.\2;\}/g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/extends ExceptionHandlerController//g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/\@Slf4j//g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt ; rm abcd.txt