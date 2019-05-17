#!/bin/bash
if [[ $1 == "" ]]
then
	echo 'PLEASE INPUT PARAMETER FILE'
	exit
fi
cat $1 > abcd.txt

paste -s -d ' ' abcd.txt > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/(public BaseResponse.*?)\{.*?;     \}/\1;/g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/public class/public interface/g' > efgh.txt
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


cat abcd.txt |  perl -pe 's/\@RestController/\@FeignClient/g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/\@RequestParam\(required = (.*?)\) String (\w+)([,|\)])/\@RequestParam(required = \1, value="\2") String \2\3/g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/\@RequestParam\(required = (.*?)\) Integer (\w+)([,|\)])/\@RequestParam(required = \1, value="\2") Integer \2\3/g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/\@RequestParam\(required = (.*?)\) Long (\w+)([,|\)])/\@RequestParam(required = \1, value="\2") Long \2\3/g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/\@PathVariable\(required = (.*?)\) String (\w+)([,|\)])/\@PathVariable(required = \1, value="\2") String \2\3/g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/\@PathVariable\(required = (.*?)\) Integer (\w+)([,|\)])/\@PathVariable(required = \1, value="\2") Integer \2\3/g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/\@PathVariable\(required = (.*?)\) Long (\w+)([,|\)])/\@PathVariable(required = \1, value="\2") Long \2\3/g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt ; rm abcd.txt