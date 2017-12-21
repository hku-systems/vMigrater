#!/bin/bash

SOCKPERF_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench6/net_perf

while true; do
	process_id=`/bin/ps -aux | grep "sockperf server" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "sockperf pid is $process_id"
		#processes=`ls /proc/$process_id/task/`
		$SOCKPERF_DIR/main $process_id
	else
		echo "sockperf is not running!"
	fi
done

