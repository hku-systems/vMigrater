#!/bin/bash

ZIP_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench1/zip

while true; do
	process_id=`/bin/ps -aux | grep "/usr/bin/zip" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "zip pid is $process_id"
		$ZIP_DIR/main $process_id
	else
		echo "zip is not running!"
	fi
done

