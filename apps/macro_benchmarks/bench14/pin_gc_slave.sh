#!/bin/bash


process_id=`/bin/ps -aux | grep "/home/kvm1/PowerGraph/release/toolkits/graph_analytics/pagerank" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
#process=`echo $process_id | awk '{print $2}'`
echo $process
#if [[ ! -z $process_id ]]; then
#	echo "caffe pid is $process_id"
#		#FIXME: hardcode waiting for caffe starting completely
#		sleep 1
processes=`ls /proc/$process_id/task/`
for entry in $processes
do
	taskset -pc $1 $entry
done
#		break
#	fi
#done


