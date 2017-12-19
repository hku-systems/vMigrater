#!/bin/bash

TAR_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench1/tar

while true; do
	process_id=`/bin/ps -aux | grep "/bin/tar" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "tar pid is $process_id"
		$TAR_DIR/main $process_id
	else
		echo "tar is not running!"
	fi
done

