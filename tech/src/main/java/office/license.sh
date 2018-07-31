#!/bin/bash
abcd=`date "+%Y%m"`
if [ ${abcd:0:6} == '201710' ]
then
	chmod a=rwx /Library/Preferences/com.microsoft.office.licensingV2temp.plist
	mv /Library/Preferences/com.microsoft.office.licensingV2temp.plist /Library/Preferences/com.microsoft.office.licensingV2.plist
fi