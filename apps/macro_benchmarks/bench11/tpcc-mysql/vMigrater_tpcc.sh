#!/bin/bash

process_id=`/bin/ps -aux | grep "/usr/sbin/mysqld" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`

echo "mysqld's main thread pid is $process_id"

cd /proc/$process_id/task/
#search_dir=/proc/$process_id/task
#files=(*)

#files=*
echo *

/home/kvm1/vMigrater/macro_benchmarks/bench11/main *

#./main $process_id


