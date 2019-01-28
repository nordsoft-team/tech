#!/bin/bash
if [[ $1 == "" ]]
then
	echo 'PLEASE INPUT PARAMETER FILE'
	exit
fi
cat $1 > abcd.txt

paste -s -d ' ' abcd.txt > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/(public BaseResponse.*? )(.*?)(\(.*? )\{(.*?;     )\}/\1\2\3\{return feign.\2;\}/g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/\@.{3,7}?Mapping\(.*?\)//g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/extends ExceptionHandlerController//g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/\@ApiOperation\(.*?\"\)//g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/\@ApiImplicitParams\({.*?}\)//g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/\@Api\(.*?\)//g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/\@Slf4j//g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt


cat abcd.txt |  perl -pe 's/\@RestController/\@Service/g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/\public class (.*?)Controller/\public class \1Service/g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt ; rm abcd.txt