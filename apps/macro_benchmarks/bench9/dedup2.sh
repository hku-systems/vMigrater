#!/bin/bash

DEDUP=/home/kvm1/parsec-3.0/pkgs/kernels/dedup/inst/amd64-linux.gcc/bin/dedup
DEDUP_INPUT=/home/kvm1/parsec-3.0/pkgs/kernels/dedup/inputs/FC-6-x86_64-disc1.iso
DEDUP_OUTPUT=/home/kvm1/parsec-3.0/pkgs/kernels/dedup/inputs/output.dat.ddp

echo "parsec dedup, it is on vCPU $1"

echo "============> dedup start to run===============>"

#1st: shared
#IM_CONCURRENCY=1
#./flush
start_ts=$(($(date +%s%N)/1000))
#/usr/bin/taskset -c $1 ${DEDUP} -c -p -t 1 -i ${DEDUP_INPUT} -o ${DEDUP_OUTPUT}
/usr/bin/taskset -c $1 ${DEDUP} -c -t 1 -i ${DEDUP_INPUT} -o ${DEDUP_OUTPUT}
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "parsec dedup, it needs $diff_ts microseconds on vCPU $1"
rm ${DEDUP_OUTPUT}
echo "============> dedup end===============>"
