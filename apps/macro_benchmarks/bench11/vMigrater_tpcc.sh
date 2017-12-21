#!/bin/bash

TPCC_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench11

while true; do
	process_id=`/bin/ps -aux | grep "/usr/sbin/mysqld" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "mysql pid is $process_id"
		processes=`ls /proc/$process_id/task/`
		$TPCC_DIR/main $processes
	else
		echo "mysql is not running!"
	fi
done

