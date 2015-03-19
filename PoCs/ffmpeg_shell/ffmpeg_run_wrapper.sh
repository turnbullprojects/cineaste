#!/bin/bash

# run multiple ffmpegs locally or in docker
# dirs need to be changed accordingly, or parameterized

CMD_DOCKER="docker run madpole/pocs /home/crumbles/code/ffmpeg_shell/ffmpeg_docker_run.sh"
CMD_LOCAL="/home/ec2-user/cineaste/code/PoCs/ffmpeg_run.sh"


# ****************************************************************
# ****  log with datetime stamp
# ****************************************************************
#usage: log 'Hello World'
function log {
   timestamp=$(date "+%Y-%m-%d %H:%M:%S")
   echo "$timestamp $@"
}

MAX_CLIENTS=5

#$CMD="$CMD_LOCAL"
CMD="$CMD_DOCKER"

# sequential
for (( i=1; i <= $MAX_CLIENTS; i++ ))
do
	CALLER_ID="CALLER_$i"
	$CMD $CALLER_ID > sequential.$CALLER_ID.log 
done

# parallel
for (( i=1; i <= $MAX_CLIENTS; i++ ))
do
	CALLER_ID="CALLER_$i"
	$CMD $CALLER_ID > parallel.$CALLER_ID.log &
done



log "$0 ALL DONE"
