#!/bin/bash

#if [ "$1" = "1" ]
#then
	# 1st run on shared vCPU

echo "Copy macrobench on vCPU $1"
./umount.sh
./mount.sh
./flush

start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c $1 /bin/cp /home/kvm1/sda2/testA /home/kvm1/sda3
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "Copy, it needs $diff_ts microseconds on vCPU $1"
rm /home/kvm1/sda3/testA
#else
	# 2nd run on shared vCPU
#	./umount.sh
#	./mount.sh
#	./flush

#	start_ts=$(($(date +%s%N)/1000))
#	/usr/bin/taskset -c 6 /bin/cp /home/kvm1/sda2/testA /home/kvm1/sda3
#	end_ts=$(($(date +%s%N)/1000))
#	let diff_ts=$end_ts-$start_ts
#	echo "2nd: It needs $diff_ts microseconds"
#	rm /home/kvm1/sda3/testA
#fi
