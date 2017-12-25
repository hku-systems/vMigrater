#!/bin/bash


while true; do
	process_id=`/bin/ps -aux | grep "caffe train" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "caffe pid is $process_id"
		#FIXME: hardcode waiting for caffe starting completely
		sleep 1
		processes=`ls /proc/$process_id/task/`
		for entry in $processes
		do
			taskset -pc $1 $entry
		done
		break
	fi
done


