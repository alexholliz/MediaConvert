MediaConvert
============

```bash
for f in *.mkv; do ffmpeg -i "$f" -c:v copy -c:a aac -strict experimental -ac 2 -b:a 256k -metadata "title=${f%}" "${f%.mkv}.mp4"; rm "$f"; done

for f in *.mkv; do ffmpeg -i "$f" -c:v copy -c:a copy -metadata "title=${f%}" "${f%.mkv}.mp4"; rm "$f"; done

for g in *.wmv; do ffmpeg -i "$g" -c:v libx264 -preset superfast -crf 23 -tune film -b:v 8M -maxrate:v 8M -bufsize:v 8M -c:a aac -strict experimental -ac 2 -b:a 256k -metadata "title=${g%}" "${g%.wmv}.mp4"; rm "$g"; done

for h in *.avi; do ffmpeg -i "$h" -c:v libx264 -preset superfast -crf 23 -tune film -b:v 8M -maxrate:v 8M -bufsize:v 8M -c:a aac -strict experimental -ac 2 -b:a 256k -metadata "title=${h%}" "${h%.avi}.mp4"; rm "$h"; done

for i in *.f4v; do ffmpeg -i "$i" -c:v libx264 -preset superfast -crf 23 -tune film -b:v 8M -maxrate:v 8M -bufsize:v 8M -c:a aac -strict experimental -ac 2 -b:a 256k -metadata "title=${i%}" "${i%.f4v}.mp4"; rm "$i"; done

for j in *.mkv; do ffmpeg -i "$j" -c:v libx264 -preset superfast -crf 23 -tune film -b:v 8M -maxrate:v 8M -bufsize:v 8M -c:a aac -strict experimental -ac 2 -b:a 256k -metadata "title=${j%}" "${j%.mkv}.mp4"; rm "$j"; done

for j in *.mkv; do ffmpeg -i "$j" -c:v libx264 -preset superfast -crf 23 -tune film -b:v 8M -maxrate:v 8M -bufsize:v 8M -c:a copy -metadata "title=${j%}" "${j%.mkv}.mp4"; rm "$j"; done
```


```bash
ffmpeg -i 'somevideo.mkv' -c:v libx264 -preset superfast -crf 23 -tune film -b:v 8M -maxrate:v 8M -bufsize:v 8M -c:a aac -ac 2 -ab 256K -strict experimental -threads 4 -loglevel info -metadata 'title=Some Video' -y somevideo.mp4

ffmpeg -i -c:v copy -c:a aac -strict experimental -ac 2 -b:a 256k 
ffmpeg -i -c:v copy -c:a copy
ffmpeg -i -c:v libx264 -preset superfast -crf 23 -tune film -b:v 8M -maxrate:v 8M -bufsize:v 8M -c:a copy
```


```bash
for f in *.mkv; do ffmpeg -i "$f" -c:v copy -c:a aac -strict experimental -ac 2 -b:a 256k "${f%.mkv}.mp4"; rm "$f"; done
```


#FFMPEG RECURSIVE
```bash
for f in */*.mkv; do ffmpeg -i "$f" -c:v copy -c:a aac -strict experimental -ac 2 -b:a 256k "${f%.mkv}.mp4"; rm "$f"; done
```


#FFPROBE
```bash
for f in *.mkv; do ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$f"; done

for f in *.mkv; do ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$f"; done
```

#FFPROBE RECURSIVE
```bash
for f in */*.mkv; do ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$f"; done

for f in */*.mkv; do ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$f"; done
```




```bash
for file in */*.{mp4,MP4,wmv,WMV,mkv,MKV,avi,AVI}; do
	VIDEO=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file")
	AUDIO=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file")

	VTRANSCODE=0
	ATRANSCODE=0

	if [ "$VIDEO" != "h264" ]; then
		VTRANSCODE=1
	fi
	if [ "$AUDIO" != "aac"]; then
		ATRANSCODE=1
	fi
	# if [ "$VTRANSCODE" == 1 && "$ATRANSCODE" == 1 ]; then
	# 	ffmpeg -i "$file" -c:v libx264 -preset superfast -crf 23 -tune film -b:v 8M -maxrate:v 8M -bufsize:v 8M -c:a aac -strict experimental -ac 2 -b:a 256k -metadata "title=${file%}" "${file%}.mp4" && rm "$file"
	# elif [ "$VTRANSCODE" == 0 && "$ATRANSCODE" == 1 ]; then
	# 	ffmpeg -i "$file" -c:v copy -c:a aac -strict experimental -ac 2 -b:a 256k -metadata "title=${file%}" "${file%}.mp4" && rm "$file"
	# elif [ "$VTRANSCODE" == 1 && "$ATRANSCODE" == 0 ]; then
	# 	ffmpeg -i "$file" -c:v libx264 -preset superfast -crf 23 -tune film -b:v 8M -maxrate:v 8M -bufsize:v 8M -c:a copy -metadata "title=${file%}" "${file%}.mp4"; rm "$file"
	# elif [ "$VTRANSCODE" == 0 && "$ATRANSCODE" == 0 ]; then
	# 	ffmpeg -i "$file" -c:v copy -c:a copy -metadata "title=${file%}" "${file%}.mp4"; rm "$file"
	# fi
	echo "$file, v:$VTRANSCODE a:$ATRANSCODE"
done
```