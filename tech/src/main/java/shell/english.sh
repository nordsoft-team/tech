#!/bin/bash

#http http://www.chinaelt.cn/index.php/home/course/coursefids/ids/196

mainUrl=`$1 | egrep -o 'vShow.asp\?v=[0-9]+' |sort | uniq |awk '{print $1}'`

for url in $mainUrl
do 
 innerUrl=`http http://www.chinaelt.cn/index.php/home/Play/play/v/${url:12}| egrep -o 'http.*m3u8' | sort| uniq |awk '{print $1}'`
 
 
 //GENERATE VIDEO
 ffmpeg -i $innerUrl -c copy ${url:12}OLD.mp4
 
 //DELETE WATERMARK
 ffmpeg –i ${url:12}OLD.mp4 -acodec copy-vcodec copy -vf "movie=test.png[watermark];[in][watermark]overlay=10:10:1[out]" ${url:12}.mp4
 
 ffmpeg -i ${url:12}.mp4 -vf delogo=x=10:y=10:w=10:h=10 output.mp4
 
 
 //DELETE OLD VIDEO
 rm ${url:12}old.mp4
 
 echo "${url:12}.mp4 FINESHED."
 
done