#!/bin/bash

POSTMARK_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench10

while true; do
	process_id=`/bin/ps -aux | grep "postmark /home/kvm1/vMigrater/apps/macro_benchmarks/bench10/config4postmark" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "postmark pid is $process_id"
		#processes=`ls /proc/$process_id/task/`
		$POSTMARK_DIR/main $process_id
	else
		echo "postmark is not running!"
	fi
done

