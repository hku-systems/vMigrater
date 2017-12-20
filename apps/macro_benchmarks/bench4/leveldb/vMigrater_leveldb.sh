#!/bin/bash

LEVELDB_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench4/leveldb

while true; do
	process_id=`/bin/ps -aux | grep "leveldb/leveldb-1.20/out-static/db_bench" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "leveldb pid is $process_id"
		processes=`ls /proc/$process_id/task/`
		$LEVELDB_DIR/main $processes
	else
		echo "leveldb is not running!"
	fi
done

