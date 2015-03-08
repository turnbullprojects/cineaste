#!/bin/bash

# run multiple ffmpegs locally or in docker
# dirs need to be changed accordingly, or parameterized


# ****************************************************************
# ****  log with datetime stamp
# ****************************************************************
#usage: log 'Hello World'
function log {
   timestamp=$(date "+%Y-%m-%d %H:%M:%S")
   echo "$timestamp $@"
}

N=0



N=$(($N + 1))
echo "starting caller $N"
docker run madpole/pocs /home/crumbles/code/ffmpeg_shell/ffmpeg_docker_run.sh CALLER_$N > CALLER_$N.log 
#
N=$(($N + 1))
echo "starting caller $N"
docker run madpole/pocs /home/crumbles/code/ffmpeg_shell/ffmpeg_docker_run.sh CALLER_$N > CALLER_$N.log 
#
N=$(($N + 1))
echo "starting caller $N"
docker run madpole/pocs /home/crumbles/code/ffmpeg_shell/ffmpeg_docker_run.sh CALLER_$N > CALLER_$N.log 
#
N=$(($N + 1))
echo "starting caller $N"
docker run madpole/pocs /home/crumbles/code/ffmpeg_shell/ffmpeg_docker_run.sh CALLER_$N > CALLER_$N.log 
#
N=$(($N + 1))
echo "starting caller $N"
docker run madpole/pocs /home/crumbles/code/ffmpeg_shell/ffmpeg_docker_run.sh CALLER_$N > CALLER_$N.log 




log "$0 ALL DONE"
