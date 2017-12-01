#!/bin/bash

# 1st run on dedicated vCPU

./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 1 /bin/tar -cvf linux_kernel.tar linux-4.14.3
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"
rm linux_kernel.tar

# 2nd run on dedicated vCPU
./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 1 /bin/tar -cvf linux_kernel.tar linux-4.14.3
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"
rm linux_kernel.tar

# 1st run on shared vCPU
./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 6 /bin/tar -cvf linux_kernel.tar linux-4.14.3
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"
rm linux_kernel.tar

# 2nd run on shared vCPU
./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 6 /bin/tar -cvf linux_kernel.tar linux-4.14.3
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"
rm linux_kernel.tar
