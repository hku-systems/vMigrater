#!/bin/bash

#while true; do
	#process_id=`/bin/ps -aux | grep "/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	echo "hdfs main thread id: $1"
	
	cd /proc/$2/task
	#search_dir=/proc/$process_id/task
	
	for entry in *
	do
		sudo taskset -pc $1 $entry
	done
#done
