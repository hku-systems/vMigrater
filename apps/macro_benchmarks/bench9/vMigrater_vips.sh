#!/bin/bash

VIPS_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench9

while true; do
	process_id=`/bin/ps -aux | grep "parsec-3.0/pkgs/apps/vips/inst/amd64-linux.gcc/bin/vips" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "vips pid is $process_id"
		processes=`ls /proc/$process_id/task/`
		$VIPS_DIR/main $processes
	else
		echo "vips is not running!"
	fi
done

