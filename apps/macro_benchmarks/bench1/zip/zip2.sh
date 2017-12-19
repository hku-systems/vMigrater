#!/bin/bash

#if [ "$1" = "1" ]
#then
	# 1st run on shared vCPU
echo "zip, macrobench is on vCPU $1"
#	./umount.sh
#	./mount.sh
#	./flush
	
start_ts=$(($(date +%s%N)/1000))
/usr/bin/taskset -c $1 /usr/bin/zip -r linux_kernel.zip linux-4.14.3 > /dev/null
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "zip, it needs $diff_ts microseconds on vCPU $1"
rm linux_kernel.zip
#else
	# 2nd run on shared vCPU
#	./umount.sh
#	./mount.sh
#	./flush

#	start_ts=$(($(date +%s%N)/1000))
#	/usr/bin/taskset -c 6 /usr/bin/zip -r linux_kernel.zip linux-4.14.3
#	end_ts=$(($(date +%s%N)/1000))
#	let diff_ts=$end_ts-$start_ts
#	echo "2nd: It needs $diff_ts microseconds"
#	rm linux_kernel.zip
#fi
