#!/bin/bash

process_id=`/bin/ps -aux | grep "parsec-3.0/pkgs/apps/x264/inst/amd64-linux.gcc/bin/x264" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`

echo "vips's pid is $process_id"

#cd /proc/$process_id/task/
#search_dir=/proc/$process_id/task
#files=(*)

#files=*
#echo *

/home/kvm1/vMigrater/macro_benchmarks/bench9/main $process_id

#./main $process_id


