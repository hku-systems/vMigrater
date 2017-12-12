#!/bin/bash

if [ "$1" = "1" ]
then
	# 1st run on shared vCPU
	echo "this is the 1st"
	./umount.sh
	./mount.sh
	./flush
	
	start_ts=$(($(date +%s%N)/1000))
	/usr/bin/taskset -c 6 /bin/myg "JI" /home/kvm1/sda3/test3
	end_ts=$(($(date +%s%N)/1000))
	let diff_ts=$end_ts-$start_ts
	echo "1st: It needs $diff_ts microseconds with vMigrater"
else
	# 2nd run on shared vCPU
	./umount.sh
	./mount.sh
	./flush

	start_ts=$(($(date +%s%N)/1000))
	/usr/bin/taskset -c 6 /bin/myg "JI" /home/kvm1/sda3/test3
	end_ts=$(($(date +%s%N)/1000))
	let diff_ts=$end_ts-$start_ts
	echo "2nd: It needs $diff_ts microseconds"
fi
