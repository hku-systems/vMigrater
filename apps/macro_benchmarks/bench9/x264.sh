#!/bin/bash

X264=/home/kvm1/parsec-3.0/pkgs/apps/x264/inst/amd64-linux.gcc/bin/x264
X264_INPUT=/home/kvm1/parsec-3.0/pkgs/apps/x264/inputs/eledream_1920x1080_512.y4m
X264_OUTPUT=/home/kvm1/parsec-3.0/pkgs/apps/x264/inputs/eledream.264

echo "vCPU number: $1, Threads number: $2"

echo "============> X264 start to run===============>"
#1st: dedicated
#EXPORT = IM_CONCURRENCY=%(PARSEC_NTHREADS)s
./flush
start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 1 ${X264} --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid --weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 --threads 1 -o ${X264_OUTPUT} ${X264_INPUT}
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
rm ${X264_OUTPUT}
echo "1st dedicated: It needs $diff_ts microseconds"
#2nd: dedicated
./flush
start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 1 ${X264} --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid --weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 --threads 1 -o ${X264_OUTPUT} ${X264_INPUT}
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
rm ${X264_OUTPUT}
echo "2nd dedicated: It needs $diff_ts microseconds"

#1st: shared
#EXPORT = IM_CONCURRENCY=%(PARSEC_NTHREADS)s
./flush
start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 5 ${X264} --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid --weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 --threads 1 -o ${X264_OUTPUT} ${X264_INPUT}
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
rm ${X264_OUTPUT}
echo "1st shared: It needs $diff_ts microseconds"
#2nd: shared
./flush
start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 5 ${X264} --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid --weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 --threads 1 -o ${X264_OUTPUT} ${X264_INPUT}
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
rm ${X264_OUTPUT}
echo "2nd shared: It needs $diff_ts microseconds"
echo "============> X264 end===============>"
