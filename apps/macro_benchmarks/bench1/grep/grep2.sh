#!/bin/bash

#if [ "$1" = "1" ]
#then
	# 1st run on shared vCPU
echo "grep, macrobench is on vCPU $1"
	./umount.sh
	./mount.sh
	./flush
	
start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c $1 /bin/myg "JI" /home/kvm1/testB
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "grep, it needs $diff_ts microseconds"
#else
	# 2nd run on shared vCPU
#	./umount.sh
#	./mount.sh
#	./flush
#
#	start_ts=$(($(date +%s%N)/1000))
#	/usr/bin/taskset -c 6 /bin/myg "JI" /home/kvm1/sda3/test3
#	end_ts=$(($(date +%s%N)/1000))
#	let diff_ts=$end_ts-$start_ts
#	echo "2nd: It needs $diff_ts microseconds"
#fi
