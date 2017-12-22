#!/bin/bash

X264=/home/kvm1/parsec-3.0/pkgs/apps/x264/inst/amd64-linux.gcc/bin/x264
X264_INPUT=/home/kvm1/parsec-3.0/pkgs/apps/x264/inputs/eledream_1920x1080_512.y4m
X264_OUTPUT=/home/kvm1/parsec-3.0/pkgs/apps/x264/inputs/eledream.264

echo "x264 is on vCPU $1"

echo "============> X264 start to run===============>"
#1st: dedicated
#EXPORT = IM_CONCURRENCY=%(PARSEC_NTHREADS)s
#1st: shared
#EXPORT = IM_CONCURRENCY=%(PARSEC_NTHREADS)s
#./flush
start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c $1 ${X264} --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid --weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 --threads 1 -o ${X264_OUTPUT} ${X264_INPUT}
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
rm ${X264_OUTPUT}
echo "x264, it needs $diff_ts microseconds on vCPU $1"
echo "============> X264 end===============>"
