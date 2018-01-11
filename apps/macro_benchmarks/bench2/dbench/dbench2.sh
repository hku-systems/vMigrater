#!/bin/bash

#if [ "$1" = "1" ]
#then
	# 1st run on shared vCPU
echo ""
echo "dbench, macrobench2 is on vCPU $1"
./umount.sh
./mount.sh
./flush
	
/usr/bin/taskset -c $1 /usr/bin/dbench -c /usr/share/dbench/client.txt -D /home/kvm1/sda3/ -t 30 $2
	#start_ts=$(($(date +%s%N)/1000))
	#/usr/bin/taskset -c 6 /bin/cp /home/kvm1/sda2/testA /home/kvm1/sda3
	#end_ts=$(($(date +%s%N)/1000))
	#let diff_ts=$end_ts-$start_ts
	#echo "1st: It needs $diff_ts microseconds with vMigrater"
rm /home/kvm1/sda3/clients -rf
#else
#	# 1st run on shared vCPU
#	echo "this is the 2nd"
#	./umount.sh
#	./mount.sh
#	./flush
	
#	/usr/bin/taskset -c 6 /usr/bin/dbench -c /usr/share/dbench/client.txt -D /home/kvm1/sda3/ -t 30 $2
	#start_ts=$(($(date +%s%N)/1000))
	#/usr/bin/taskset -c 6 /bin/cp /home/kvm1/sda2/testA /home/kvm1/sda3
	#end_ts=$(($(date +%s%N)/1000))
	#let diff_ts=$end_ts-$start_ts
	#echo "1st: It needs $diff_ts microseconds with vMigrater"
#	rm /home/kvm1/sda3/clients -rf
#fi
