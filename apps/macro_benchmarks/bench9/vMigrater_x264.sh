#!/bin/bash

X264_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench9

while true; do
	process_id=`/bin/ps -aux | grep "parsec-3.0/pkgs/apps/x264/inst/amd64-linux.gcc/bin/x264" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "x264 pid is $process_id"
		processes=`ls /proc/$process_id/task/`
		$VIPS_DIR/main $processes
	else
		echo "x264 is not running!"
	fi
done

