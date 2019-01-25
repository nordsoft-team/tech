#!/bin/bash
paste -s -d '\0' abcd.txt | tee efgh.txt
cat efgh.txt |  perl -pe 's/public BaseResponse.*?({.*?;    })/;/g' > abcd.txt