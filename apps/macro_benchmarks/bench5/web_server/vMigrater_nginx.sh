#!/bin/bash

NGINX_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench5/web_server

while true; do
	process_id=`/bin/ps -aux | grep "nginx:" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "nginx pid is $process_id"
		#processes=`ls /proc/$process_id/task/`
		$NGINX_DIR/main $process_id
	else
		echo "nginx is not running!"
	fi
done

