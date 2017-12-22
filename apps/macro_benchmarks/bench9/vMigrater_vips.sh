#!/bin/bash

VIPS_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench9

while true; do
	process_id=`/bin/ps -aux | grep "parsec-3.0/pkgs/apps/vips/inst/amd64-linux.gcc/bin/vips" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "vips pid is $process_id"
		processes=`ls /proc/$process_id/task/`
		process_nums=`echo "$processes" | wc -w`
		echo "process number is $process_nums"
		if [ "$process_nums" -gt "1" ]; then
			$VIPS_DIR/main $processes
		fi
	else
		echo "vips is not running!"
	fi
done

