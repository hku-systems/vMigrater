#!/bin/bash

if [ "$1" = "1" ]
then
	# 1st run on shared vCPU
	echo "This is TCP STREAM Test"
	#cd /home/kvm1/vMigrater/macro_benchmarks/bench3/sysbench
	#./umount.sh
	#./mount.sh
	
	#cd /home/kvm1/sda3
	#/usr/bin/sysbench --test=fileio --file-total-size=10G prepare
	#sysbench --test=oltp --oltp-table-size=1000000 --mysql-db=test --mysql-user=root --mysql-password=123 prepare
	#./flush
	echo "============> siege start to run===============>"
	#/usr/bin/taskset -c 6 /usr/bin/sysbench --test=fileio --max-time=30 --max-requests=0 --file-total-size=8GB --num-threads=$2 --file-test-mode=rndrw run
	#/usr/bin/taskset -c $1 /usr/bin/sysbench --test=oltp --oltp-table-size=1000000 --mysql-db=test --mysql-user=root --mysql-password=123 --max-time=60 --oltp-read-only=on --max-requests=0 --num-threads=$2 run
	#client 1000 users and each send a total of 
	/usr/bin/taskset -c 7 /usr/bin/netperf -t TCP_STREAM -H 192.168.122.95 -p 12865 -l $2
	echo "============> siege end===============>"
	#sysbench --test=oltp --mysql-db=test --mysql-user=root --mysql-password=123 cleanup
	#/usr/bin/sysbench --test=fileio --file-total-size=10G cleanup
	#/usr/bin/taskset -c 6 /usr/bin/dbench -c /usr/share/dbench/client.txt -D /home/kvm1/sda3/ -t 30 $2
	#start_ts=$(($(date +%s%N)/1000))
	#/usr/bin/taskset -c 6 /bin/cp /home/kvm1/sda2/testA /home/kvm1/sda3
	#end_ts=$(($(date +%s%N)/1000))
	#let diff_ts=$end_ts-$start_ts
	#echo "1st: It needs $diff_ts microseconds with vMigrater"
	#cd /home/kvm1/vMigrater/macro_benchmarks/bench3/sysbench
else
	# 1st run on shared vCPU
	echo "this is UDP STREAM"
	/usr/bin/taskset -c 7 /usr/bin/netperf -t UDP_STREAM -H 192.168.122.95 -p 12865 -l $2
	#start_ts=$(($(date +%s%N)/1000))
	#/usr/bin/taskset -c 6 /bin/cp /home/kvm1/sda2/testA /home/kvm1/sda3
	#end_ts=$(($(date +%s%N)/1000))
	#let diff_ts=$end_ts-$start_ts
	#echo "1st: It needs $diff_ts microseconds with vMigrater"
fi
