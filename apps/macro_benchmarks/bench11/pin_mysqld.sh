#!/bin/bash

process_id=`/bin/ps -aux | grep "/usr/sbin/mysqld" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`

echo "mysqld's main task pid is $process_id"

cd /proc/$process_id/task/
#search_dir=/proc/$process_id/task
#files=(*)

#files=*
#echo *

for entry in *
do
	echo "$entry"
	sudo taskset -pc 1 $entry
done

#/home/kvm1/vMigrater/macro_benchmarks/bench9/main *

#./main $process_id


