#!/bin/bash

# script stored in docker container
# to call from outside as a single run command

VIDEO_DOCKER_DIR="/home/crumbles/ffmpeg/bin"
VIDEO_LOCAL_DIR="/home/ec2-user/cineaste/code/PoCs"

# ****************************************************************
# ****  log with datetime stamp
# ****************************************************************
#usage: log 'Hello World'
function log {
   timestamp=$(date "+%Y-%m-%d %H:%M:%S")
   echo "$timestamp $@"
}

CALLER_ID=$1
#OUTPUT_DIR=$2

#log "START: [$CALLER_ID]"
#log "OUTPUT_DIR: [$OUTPUT_DIR]"
echo "$CALLER_ID,START,$(date '+%H:%M:%S')"

START=$(date +%s);

#FFMPEG_COMMAND="ffmpeg -stats -i  /home/crumbles/ffmpeg/bin/Buster.Keaton.The.Three.Ages.ogv -loop 0 -final_delay 500 -c:v gif -f gif -ss 00:49:42 -t 5 - > trow_ball.gif"
#FFMPEG_COMMAND="ffmpeg -stats -i  /home/crumbles/ffmpeg/bin/Buster.Keaton.The.Three.Ages.ogv -loop 0 -final_delay 500 -c:v gif -f gif -ss 00:49:42 -t 5 -"
#ffmpeg -stats -i  /home/crumbles/ffmpeg/bin/Buster.Keaton.The.Three.Ages.ogv -loop 0 -final_delay 500 -c:v gif -f gif -ss 00:49:42 -t 5 
#log "FFMPEG_COMMAND: [$FFMPEG_COMMAND]"
#$FFMPEG_COMMAND > $CALLER_ID.trow_ball.gif


cd /home/crumbles/ffmpeg/bin/

rm -fr *.mpg
rm -fr *.avi

ffmpeg  -threads 0 -i 1.mp4 -qscale:v 1 intermediate1.mpg </dev/null > /dev/null 2>&1
ffmpeg  -threads 0 -i 2.mp4 -qscale:v 1 intermediate2.mpg </dev/null > /dev/null 2>&1
ffmpeg  -threads 0 -i 3.mp4 -qscale:v 1 intermediate3.mpg </dev/null > /dev/null 2>&1
ffmpeg  -threads 0 -i 4.mp4 -qscale:v 1 intermediate4.mpg </dev/null > /dev/null 2>&1
ffmpeg  -threads 0 -i 5.mp4 -qscale:v 1 intermediate5.mpg </dev/null > /dev/null 2>&1
ffmpeg  -threads 0 -i 6.mp4 -qscale:v 1 intermediate6.mpg </dev/null > /dev/null 2>&1
ffmpeg  -threads 0 -i 7.mp4 -qscale:v 1 intermediate7.mpg </dev/null > /dev/null 2>&1
ffmpeg  -threads 0 -i 8.mp4 -qscale:v 1 intermediate8.mpg </dev/null > /dev/null 2>&1
ffmpeg  -threads 0 -i 9.mp4 -qscale:v 1 intermediate9.mpg </dev/null > /dev/null 2>&1
ffmpeg  -threads 0 -i 10.mp4 -qscale:v 1 intermediate10.mpg </dev/null > /dev/null 2>&1
ffmpeg  -threads 0 -i concat:"intermediate1.mpg|intermediate2.mpg|intermediate3.mpg|intermediate4.mpg|intermediate5.mpg|intermediate6.mpg|intermediate7.mpg|intermediate8.mpg|intermediate9.mpg|intermediate10.mpg" -c copy intermediate_all.mpg </dev/null > /dev/null 2>&1
ffmpeg  -threads 0 -i intermediate_all.mpg -qscale:v 2 output.avi </dev/null > /dev/null 2>&1


rm -fr *.mpg

# -threads 0


END=$(date +%s);
#ELAPSED_TIME=`echo $((END-START)) | awk '{print int($1/60)":"int($1%60)}'`
ELAPSED_TIME=$(($END-$START))

echo "$CALLER_ID,FINISH,$(date '+%H:%M:%S')"
echo "$CALLER_ID,ELAPSED_TIME,$ELAPSED_TIME"
#log "ELAPSED_TIME: [$ELAPSED_TIME]"



#log "$0 ALL DONE"


# ****************************************************************
# Notes
# docker run -it -v /Users/madpole/data/dev/aws/andrew.szymanski.jobs/crumbles/code/PoCs/ffmpeg_shell:/home/crumbles/host_dir madpole/pocs /home/crumbles/host_dir/ffmpeg_docker_run.sh
# 
# 
# 
# 
# ****************************************************************
