#!/bin/bash
paste -s -d '\0\ ' abcd.txt | tee efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/public BaseResponse.*?({.*?    })/\1;/g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/public class/public interface/g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/public class/public interface/g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/extends ExceptionHandlerController//g' > efgh.txt
cat efgh.txt > abcd.txt ; rm efgh.txt

cat abcd.txt |  perl -pe 's/@Api//g' > efgh.txt
