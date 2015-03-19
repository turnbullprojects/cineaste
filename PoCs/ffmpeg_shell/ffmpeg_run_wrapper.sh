#!/bin/bash

# run multiple ffmpegs locally or in docker
# dirs need to be changed accordingly, or parameterized
# currently only set for running commands in docker
# and we are running 2 tests, one after another
#
# CMD_LOCAL="/home/ec2-user/cineaste/code/PoCs/ffmpeg_run.sh"


CMD_TEST_1="ffmpeg_run_test_01.sh"
CMD_TEST_2="ffmpeg_run_test_02.sh"

CMD_BASE="docker run madpole/pocs /home/crumbles/code/ffmpeg_shell"



# ****************************************************************
# ****  log with datetime stamp
# ****************************************************************
#usage: log 'Hello World'
function log {
   timestamp=$(date "+%Y-%m-%d %H:%M:%S")
   echo "$timestamp $@"
}

MAX_CLIENTS=20

# ****************************************************************
# ****  test 1
# ****************************************************************
CMD="$CMD_BASE/$CMD_TEST_1"

# sequential - just to establish sequential run, we don't have to run 100 times
for (( i=1; i <= 3; i++ ))
do
	CALLER_ID="CALLER_$i"
	$CMD $CALLER_ID > $CMD_TEST_1.sequential.$CALLER_ID.log 
done

# parallel
for (( i=1; i <= $MAX_CLIENTS; i++ ))
do
	CALLER_ID="CALLER_$i"
	$CMD $CALLER_ID > $CMD_TEST_1.parallel.$CALLER_ID.log &
done

# ****************************************************************
# ****  test 2
# ****************************************************************
CMD="$CMD_BASE/$CMD_TEST_2"

# sequential - just to establish sequential run, we don't have to run 100 times
for (( i=1; i <= 3; i++ ))
do
	CALLER_ID="CALLER_$i"
	$CMD $CALLER_ID > $CMD_TEST_2.sequential.$CALLER_ID.log 
done

# parallel
for (( i=1; i <= $MAX_CLIENTS; i++ ))
do
	CALLER_ID="CALLER_$i"
	$CMD $CALLER_ID > $CMD_TEST_2.parallel.$CALLER_ID.log &
done






log "$0 ALL DONE"
