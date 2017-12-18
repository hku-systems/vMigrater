#!/bin/bash

#we need to check/migrate "/bin/cp" until it appears

while true; do
	process_id=`/bin/ps -aux | grep "/bin/cp" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
	if [[ ! -z $process_id ]]; then
		echo "copy pid is $process_id"
		./main $process_id
	else
		echo "copy is not running!"
	fi
done

