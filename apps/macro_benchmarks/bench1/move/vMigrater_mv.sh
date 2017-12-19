#!/bin/bash

MOVE_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench1/move

while true; do
	process_id=`/bin/ps -aux | grep "mv" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "move pid is $process_id"
		$MOVE_DIR/main $process_id
	else
		echo "move is not running!"
	fi
done

