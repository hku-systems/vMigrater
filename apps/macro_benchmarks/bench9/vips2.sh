#!/bin/bash

VIPS=/home/kvm1/parsec-3.0/pkgs/apps/vips/inst/amd64-linux.gcc/bin/vips
VIPS_INPUT=/home/kvm1/parsec-3.0/pkgs/apps/vips/inputs/orion_18000x18000.v
VIPS_OUTPUT=/home/kvm1/parsec-3.0/pkgs/apps/vips/inputs/output.v

echo "parsec vips, it is on vCPU $1"

echo "============> vips start to run===============>"

#1st: shared
#IM_CONCURRENCY=1
rm ${VIPS_OUTPUT}
#./flush
start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c $1 ${VIPS} im_benchmark ${VIPS_INPUT} ${VIPS_OUTPUT}
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "parsec vips, it needs $diff_ts microseconds on vCPU $1"
echo "============> vips end===============>"
