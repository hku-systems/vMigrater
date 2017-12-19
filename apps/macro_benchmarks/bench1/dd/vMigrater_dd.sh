#!/bin/bash

#we need to check/migrate "/bin/cp" until it appears
DD_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench1/dd

while true; do
	process_id=`/bin/ps -aux | grep "/bin/dd" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "dd pid is $process_id"
		$DD_DIR/main $process_id
	else
		echo "dd is not running!"
	fi
done

