#!/bin/bash

VIPS=/home/kvm1/parsec-3.0/pkgs/apps/vips/inst/amd64-linux.gcc/bin/vips
VIPS_INPUT=/home/kvm1/parsec-3.0/pkgs/apps/vips/inputs/orion_18000x18000.v
VIPS_OUTPUT=/home/kvm1/parsec-3.0/pkgs/apps/vips/inputs/output.v

echo "vCPU number: $1, Threads number: $2"

echo "============> vips start to run===============>"
#1st: dedicated
#EXPORT = IM_CONCURRENCY=%(PARSEC_NTHREADS)s
./flush
start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 1 ${VIPS} im_benchmark ${VIPS_INPUT} ${VIPS_OUTPUT}
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "1st dedicated: It needs $diff_ts microseconds"
#2nd: dedicated
./flush
start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 1 ${VIPS} im_benchmark ${VIPS_INPUT} ${VIPS_OUTPUT}
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "2nd dedicated: It needs $diff_ts microseconds"

#1st: shared
#EXPORT = IM_CONCURRENCY=%(PARSEC_NTHREADS)s
./flush
start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 5 ${VIPS} im_benchmark ${VIPS_INPUT} ${VIPS_OUTPUT}
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "1st shared: It needs $diff_ts microseconds"
#2nd: shared
./flush
start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 5 ${VIPS} im_benchmark ${VIPS_INPUT} ${VIPS_OUTPUT}
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "2nd shared: It needs $diff_ts microseconds"
echo "============> vips end===============>"
