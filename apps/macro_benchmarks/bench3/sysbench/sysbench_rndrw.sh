#!/bin/bash

# 1st run on dedicated vCPU


echo "This are $1 Threads test ==========================================================>"

cd /home/kvm1/vMigrater/macro_benchmarks/bench3/sysbench
./umount.sh
./mount.sh
./flush

#start_ts=$(($(date +%s%N)/1000))
#/usr/bin/taskset -c 1 /bin/cp /home/kvm1/sda2/testA /home/kvm1/sda3
#end_ts=$(($(date +%s%N)/1000))
#let diff_ts=$end_ts-$start_ts
#echo "It needs $diff_ts microseconds"
#rm /home/kvm1/sda3/testA
#/usr/bin/taskset -c 1 /usr/bin/dbench -s -c /usr/share/dbench/client.txt -D /home/kvm1/sda3/ -t 30 $1
cd /home/kvm1/sda3
/usr/bin/sysbench --test=fileio --file-total-size=10G prepare
/usr/bin/taskset -c 1 /usr/bin/sysbench --test=fileio --max-time=30 --max-requests=0 --num-threads=$1 --file-test-mode=rndrw --file-total-size=8GB run
/usr/bin/sysbench --test=fileio --file-total-size=10G cleanup
cd /home/kvm1/vMigrater/macro_benchmarks/bench3/sysbench

# 2nd run on dedicated vCPU
./umount.sh
./mount.sh
./flush


cd /home/kvm1/sda3
/usr/bin/sysbench --test=fileio --file-total-size=10G prepare
/usr/bin/taskset -c 1 /usr/bin/sysbench --test=fileio --max-time=30 --max-requests=0 --num-threads=$1 --file-test-mode=rndrw --file-total-size=8GB run
/usr/bin/sysbench --test=fileio --file-total-size=10G cleanup
cd /home/kvm1/vMigrater/macro_benchmarks/bench3/sysbench

#start_ts=$(($(date +%s%N)/1000))
#/usr/bin/taskset -c 1 /bin/cp /home/kvm1/sda2/testA /home/kvm1/sda3
#end_ts=$(($(date +%s%N)/1000))
#let diff_ts=$end_ts-$start_ts
#echo "It needs $diff_ts microseconds"
#rm /home/kvm1/sda3/testA

./umount.sh
./mount.sh
./flush


cd /home/kvm1/sda3
/usr/bin/sysbench --test=fileio --file-total-size=10G prepare
/usr/bin/taskset -c 6 /usr/bin/sysbench --test=fileio --max-time=30 --max-requests=0 --num-threads=$1 --file-test-mode=rndrw --file-total-size=8GB run
/usr/bin/sysbench --test=fileio --file-total-size=10G cleanup
cd /home/kvm1/vMigrater/macro_benchmarks/bench3/sysbench

./umount.sh
./mount.sh
./flush


cd /home/kvm1/sda3
/usr/bin/sysbench --test=fileio --file-total-size=10G prepare
/usr/bin/taskset -c 6 /usr/bin/sysbench --test=fileio --max-time=30 --max-requests=0 --num-threads=$1 --file-test-mode=rndrw --file-total-size=8GB run
/usr/bin/sysbench --test=fileio --file-total-size=10G cleanup
cd /home/kvm1/vMigrater/macro_benchmarks/bench3/sysbench
