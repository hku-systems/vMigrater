#!/bin/bash

echo "move macrobench on $1"

if [ "$2" = "1" ]
then
	start_ts=$(($(date +%s%N)/1000))
	/usr/bin/taskset -c $1 /bin/mv /home/kvm1/sda2/testA /home/kvm1/sda3
	end_ts=$(($(date +%s%N)/1000))
	let diff_ts=$end_ts-$start_ts
else
	start_ts=$(($(date +%s%N)/1000))
	/usr/bin/taskset -c $1 /bin/mv /home/kvm1/sda3/testA /home/kvm1/sda2
	end_ts=$(($(date +%s%N)/1000))
	let diff_ts=$end_ts-$start_ts
fi
echo "Move, it needs $diff_ts microseconds on vCPU $1"
