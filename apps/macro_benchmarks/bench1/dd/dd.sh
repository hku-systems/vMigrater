#!/bin/bash

# 1st run on dedicated vCPU

./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 1 /bin/dd if=/home/kvm1/sda2/testA of=/home/kvm1/sda3/testA bs=4096 count=1000000 oflag=direct
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"
rm /home/kvm1/sda3/testA

# 2nd run on dedicated vCPU
./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 1 /bin/dd if=/home/kvm1/sda2/testA of=/home/kvm1/sda3/testA bs=4096 count=1000000 oflag=direct
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"
rm /home/kvm1/sda3/testA

# 1st run on shared vCPU
./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 6 /bin/dd if=/home/kvm1/sda2/testA of=/home/kvm1/sda3/testA bs=4096 count=1000000 oflag=direct
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"
rm /home/kvm1/sda3/testA

# 2nd run on shared vCPU
./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c 6 /bin/dd if=/home/kvm1/sda2/testA of=/home/kvm1/sda3/testA bs=4096 count=1000000 oflag=direct
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "It needs $diff_ts microseconds"
rm /home/kvm1/sda3/testA
