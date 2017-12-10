#!/bin/bash

process_id=`/bin/ps -aux | grep "postmark" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`

echo "postmark's pid is $process_id"

#cd /proc/$process_id/task/
#search_dir=/proc/$process_id/task
#files=(*)

#files=*
#echo *

/home/kvm1/vMigrater/macro_benchmarks/bench10/main $process_id

#./main $process_id


