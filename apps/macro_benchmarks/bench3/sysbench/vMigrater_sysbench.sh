#!/bin/bash

SYSBENCH_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench3/sysbench

while true; do
	process_id=`/bin/ps -aux | grep "/usr/bin/sysbench" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "sysbench pid is $process_id"
		processes=`ls /proc/$process_id/task/`
		$SYSBENCH_DIR/main $processes
	else
		echo "sysbench is not running!"
	fi
done

