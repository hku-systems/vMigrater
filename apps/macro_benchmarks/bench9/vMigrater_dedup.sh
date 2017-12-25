#!/bin/bash

DEDUP_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench9

while true; do
	process_id=`/bin/ps -aux | grep "inst/amd64-linux.gcc/bin/dedup" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "dedup pid is $process_id"
		processes=`ls /proc/$process_id/task/`
		process_nums=`echo "$processes" | wc -w`
		echo "process number is $process_nums"
		if [ "$process_nums" -gt "1" ]; then
			$DEDUP_DIR/main $processes
		fi
	else
		echo "dedup is not running!"
	fi
done

