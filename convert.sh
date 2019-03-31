#!/bin/bash

#Tell the script not to throw errors if the extension is not found
shopt -s nullglob 

#for mp4 files specifically in the directories below the cwd
for file in */*.{mp4,MP4}; do
	#Use ffprobe to determine if the video and audio stream are h264 and aac
	VIDEO=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file")
	AUDIO=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file")

	#set the transcode flags to 0 until they are updated
	VTRANSCODE=0
	ATRANSCODE=0

	#set the transcode flags if transcoding needs to take place
	if [ "$VIDEO" != "h264" ]; then
		VTRANSCODE=1
	fi
	if [ "$AUDIO" != "aac" ]; then
		ATRANSCODE=1
	fi

	#if statements for various possibilities of transcoding
	if [ "$VTRANSCODE" == 1 ] && [ "$ATRANSCODE" == 1 ]; then
		#ffmpeg call to do the appropriate transcoding, automatically answering yes to overwrite files, and because this is already an mp4 file, don't delete it at the end.
		ffmpeg -y -i "$file" -c:v libx264 -preset superfast -crf 23 -tune film -b:v 8M -maxrate:v 8M -bufsize:v 8M -c:a aac -strict experimental -ac 2 -b:a 256k "${file%.*}.mp4"
	elif [ "$VTRANSCODE" == 0 ] && [ "$ATRANSCODE" == 1 ]; then
		#the handy file% arguments say, "hey, get that filename, and delete everything after the period" so we can lose the original file extension
		ffmpeg -y -i "$file" -c:v copy -c:a aac -strict experimental -ac 2 -b:a 256k "${file%.*}.mp4"
	elif [ "$VTRANSCODE" == 1 ] && [ "$ATRANSCODE" == 0 ]; then
		ffmpeg -y -i "$file" -c:v libx264 -preset superfast -crf 23 -tune film -b:v 8M -maxrate:v 8M -bufsize:v 8M -c:a copy "${file%}.mp4"
	
	#if no transcoding is necessary, skip this file and continue the loop
	elif [ "$VTRANSCODE" == 0 ] && [ "$ATRANSCODE" == 0 ]; then
		continue
	fi
done

#for video files in the directories below the cwd
for file in */*.{wmv,WMV,mkv,MKV,avi,AVI,m4v,M4V}; do

	VIDEO=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file")
	AUDIO=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file")

	VTRANSCODE=0
	ATRANSCODE=0

	if [ "$VIDEO" != "h264" ]; then
		VTRANSCODE=1
	fi
	if [ "$AUDIO" != "aac" ]; then
		ATRANSCODE=1
	fi
	if [ "$VTRANSCODE" == 1 ] && [ "$ATRANSCODE" == 1 ]; then
		##ffmpeg call to do the appropriate transcoding, automatically answering yes to overwrite files, and because this is not already an mp4 file, delete the original file at the end.
		ffmpeg -i "$file" -c:v libx264 -preset superfast -crf 23 -tune film -b:v 8M -maxrate:v 8M -bufsize:v 8M -c:a aac -strict experimental -ac 2 -b:a 256k "${file%.*}.mp4" && rm "$file"
	elif [ "$VTRANSCODE" == 0 ] && [ "$ATRANSCODE" == 1 ]; then
		ffmpeg -i "$file" -c:v copy -c:a aac -strict experimental -ac 2 -b:a 256k "${file%.*}.mp4" && rm "$file"
	elif [ "$VTRANSCODE" == 1 ] && [ "$ATRANSCODE" == 0 ]; then
		ffmpeg -i "$file" -c:v libx264 -preset superfast -crf 23 -tune film -b:v 8M -maxrate:v 8M -bufsize:v 8M -c:a copy "${file%}.mp4" && rm "$file"
	elif [ "$VTRANSCODE" == 0 ] && [ "$ATRANSCODE" == 0 ]; then
		ffmpeg -i "$file" -c:v copy -c:a copy "${file%.*}.mp4" && rm "$file"
	fi
done
