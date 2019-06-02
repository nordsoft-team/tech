#!/bin/bash

ffmpeg -y -i "https://abcd.com/abcd.m3u8" -c copy -bsf:a aac_adtstoasc abcd.mp4