#!/bin/bash

# 1st run on dedicated vCPU

./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 1 /usr/bin/zip -r linux_kernel.zip linux-4.14.3
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"
rm linux_kernel.zip

# 2nd run on dedicated vCPU
./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 1 /usr/bin/zip -r linux_kernel.zip linux-4.14.3
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"
rm linux_kernel.zip

# 1st run on shared vCPU
./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 6 /usr/bin/zip -r linux_kernel.zip linux-4.14.3
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"
rm linux_kernel.zip

# 2nd run on shared vCPU
./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 6 /usr/bin/zip -r linux_kernel.zip linux-4.14.3
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"
rm linux_kernel.zip
