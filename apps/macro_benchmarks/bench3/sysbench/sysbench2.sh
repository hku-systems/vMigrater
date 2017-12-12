#!/bin/bash

if [ "$1" = "1" ]
then
	# 1st run on shared vCPU
	echo "this is the 1st"
	cd /home/kvm1/vMigrater/macro_benchmarks/bench3/sysbench
	./umount.sh
	./mount.sh
	./flush
	
	cd /home/kvm1/sda3
	/usr/bin/sysbench --test=fileio --file-total-size=10G prepare
	echo "============> sysbench start to run===============>"
	/usr/bin/taskset -c 6 /usr/bin/sysbench --test=fileio --max-time=30 --max-requests=0 --file-total-size=8GB --num-threads=$2 --file-test-mode=rndrw run
	echo "============> sysbench end===============>"
	/usr/bin/sysbench --test=fileio --file-total-size=10G cleanup
	#/usr/bin/taskset -c 6 /usr/bin/dbench -c /usr/share/dbench/client.txt -D /home/kvm1/sda3/ -t 30 $2
	#start_ts=$(($(date +%s%N)/1000))
	#/usr/bin/taskset -c 6 /bin/cp /home/kvm1/sda2/testA /home/kvm1/sda3
	#end_ts=$(($(date +%s%N)/1000))
	#let diff_ts=$end_ts-$start_ts
	#echo "1st: It needs $diff_ts microseconds with vMigrater"
	cd /home/kvm1/vMigrater/macro_benchmarks/bench3/sysbench
else
	# 1st run on shared vCPU
	echo "this is the 2nd"
	#start_ts=$(($(date +%s%N)/1000))
	#/usr/bin/taskset -c 6 /bin/cp /home/kvm1/sda2/testA /home/kvm1/sda3
	#end_ts=$(($(date +%s%N)/1000))
	#let diff_ts=$end_ts-$start_ts
	#echo "1st: It needs $diff_ts microseconds with vMigrater"
fi
