#!/bin/bash

process_id=`/bin/ps -aux | grep "tpcc_start" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`

echo "tpcc_start's main task pid is $process_id"

tpcc_processes=`ls /proc/$process_id/task/`
#search_dir=/proc/$process_id/task
#files=(*)

#files=*
#echo *

for entry in $tpcc_processes
do
	echo "$entry"
	sudo taskset -pc $1 $entry
done

#/home/kvm1/vMigrater/macro_benchmarks/bench9/main *

#./main $process_id


