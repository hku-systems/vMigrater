#!/bin/bash

#if [ "$1" = "1" ]
#then
	# 1st run on shared vCPU
echo "diff, macrobench on vCPU $1"
#	./umount.sh
#	./mount.sh
#	./flush
	
start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c $1 /usr/bin/diff /home/kvm1/sda2/testA /home/kvm1/testB > 1
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "diff, it needs $diff_ts microseconds"
rm 1
#else
	# 2nd run on shared vCPU
#	./umount.sh
#	./mount.sh
#	./flush

#	start_ts=$(($(date +%s%N)/1000))
#	/usr/bin/taskset -c 6 /usr/bin/diff /home/kvm1/sda2/test1 /home/kvm1/sda3/test2 > 1
#	end_ts=$(($(date +%s%N)/1000))
#	let diff_ts=$end_ts-$start_ts
#	echo "2nd: It needs $diff_ts microseconds"
#	rm 1
#fi
