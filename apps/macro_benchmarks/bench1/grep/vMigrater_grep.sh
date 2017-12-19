#!/bin/bash

GREP_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench1/grep

while true; do
	process_id=`/bin/ps -aux | grep "/bin/myg" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "grep pid is $process_id"
		$GREP_DIR/main $process_id
	else
		echo "grep is not running!"
	fi
done

