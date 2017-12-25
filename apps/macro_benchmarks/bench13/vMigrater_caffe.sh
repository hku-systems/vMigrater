#!/bin/bash

BENCH13_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench13

while true; do
	process_id=`/bin/ps -aux | grep "caffe train" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "caffe pid is $process_id"
		#FIXME: hardcode waiting for caffe starting completely
		sleep 1
		processes=`ls /proc/$process_id/task/`
		$BENCH13_DIR/main $processes
		#for entry in $processes
		#do
		#sudo taskset -pc $1 $entry > /dev/null
		#done
		#break
	else
		echo "caffe is not running"
	fi
done


