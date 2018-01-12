#!/bin/bash

#if [ "$1" = "1" ]
#then
	# 1st run on shared vCPU

echo "nginx, this is on vCPU $1 with $2 clients/users"
#FIXME: IP should be not the server IP
#IP_ADDR_SERVER=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`
IP_ADDR_SERVER="192.168.122.103"
IP_ADDR_CLIENT="192.168.122.246"
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
taskset -c $1 siege --quiet --concurrent=$2 --time=60s --log=./siege.log $IP_ADDR_SERVER
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
#else
	# 1st run on shared vCPU
#	echo "this is the 2nd"
	#start_ts=$(($(date +%s%N)/1000))
	#/usr/bin/taskset -c 6 /bin/cp /home/kvm1/sda2/testA /home/kvm1/sda3
	#end_ts=$(($(date +%s%N)/1000))
	#let diff_ts=$end_ts-$start_ts
	#echo "1st: It needs $diff_ts microseconds with vMigrater"
#fi
