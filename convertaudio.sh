#!/bin/bash

for file in *.{mp4,MP4}; do
    ffmpeg -y -i "$file" -map 0:v -map 0:a -map -0:s -c:v copy -c:a aac -strict experimental -ac 2 -b:a 256k -metadata "title=${file%.*}" "Converted_${file%.*}.mp4"
done