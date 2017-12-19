#!/bin/bash

DIFF_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench1/diff

while true; do
	process_id=`/bin/ps -aux | grep "/usr/bin/diff" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "diff pid is $process_id"
		$DIFF_DIR/main $process_id
	else
		echo "diff is not running!"
	fi
done

