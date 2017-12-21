#!/bin/bash

while true; do
	process_id=`/bin/ps -aux | grep "tpcc_start" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "tpcc_start pid is $process_id"
		tpcc_processes=`ls /proc/$process_id/task/`
		for entry in $tpcc_processes
		do
			#echo "$entry"
			sudo taskset -pc $1 $entry > /dev/null
		done
	else
		echo "tpcc_start is not running!"
	fi
done

