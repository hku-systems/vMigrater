#!/bin/bash

# 1st run on dedicated vCPU

./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 1 /usr/bin/diff /home/kvm1/sda2/test1 /home/kvm1/sda3/test2 > 1
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"
rm 1

# 2nd run on dedicated vCPU
./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 1 /usr/bin/diff /home/kvm1/sda2/test1 /home/kvm1/sda3/test2 > 1
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"
rm 1

# 1st run on shared vCPU
./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 6 /usr/bin/diff /home/kvm1/sda2/test1 /home/kvm1/sda3/test2 > 1
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"
rm 1

# 2nd run on shared vCPU
./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 6 /usr/bin/diff /home/kvm1/sda2/test1 /home/kvm1/sda3/test2 > 1
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"
rm 1
