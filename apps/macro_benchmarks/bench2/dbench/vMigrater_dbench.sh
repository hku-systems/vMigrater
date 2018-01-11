#!/bin/bash

DBENCH_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench2/dbench

while true; do
	process_id=`/bin/ps -aux | grep "/usr/bin/dbench" | grep -v "grep" | grep -v "bash" | awk '{print $2}' | awk 'NR==2'`
	if [[ ! -z $process_id ]]; then
		echo "dbench pid is $process_id"
		#processes=`ls /proc/$process_id/task/`
		$DBENCH_DIR/main $process_id
	else
		echo "dbench is not running!"
	fi
done

