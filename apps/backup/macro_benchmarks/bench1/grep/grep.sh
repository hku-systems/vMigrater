#!/bin/bash

# 1st run on dedicated vCPU

./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 1 /bin/grep "JI" /home/kvm1/sda3/test3
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"

# 2nd run on dedicated vCPU
./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 1 /bin/grep "JI" /home/kvm1/sda3/test3
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"

# 1st run on shared vCPU
./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 6 /bin/grep "JI" /home/kvm1/sda3/test3
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"

# 2nd run on shared vCPU
./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 6 /bin/grep "JI" /home/kvm1/sda3/test3
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"
