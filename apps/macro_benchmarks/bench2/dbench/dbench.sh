#!/bin/bash

# 1st run on dedicated vCPU

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
/usr/bin/taskset -c 1 /usr/bin/dbench -c /usr/share/dbench/client.txt -D /home/kvm1/sda3/ -t 30 $1
rm -rf /home/kvm1/sda3/clients

# 2nd run on dedicated vCPU
./umount.sh
./mount.sh
./flush


/usr/bin/taskset -c 1 /usr/bin/dbench -c /usr/share/dbench/client.txt -D /home/kvm1/sda3/ -t 30 $1
rm -rf /home/kvm1/sda3/clients

#start_ts=$(($(date +%s%N)/1000))
#/usr/bin/taskset -c 1 /bin/cp /home/kvm1/sda2/testA /home/kvm1/sda3
#end_ts=$(($(date +%s%N)/1000))
#let diff_ts=$end_ts-$start_ts
#echo "It needs $diff_ts microseconds"
#rm /home/kvm1/sda3/testA

./umount.sh
./mount.sh
./flush


/usr/bin/taskset -c 6 /usr/bin/dbench -c /usr/share/dbench/client.txt -D /home/kvm1/sda3/ -t 30 $1
rm -rf /home/kvm1/sda3/clients

./umount.sh
./mount.sh
./flush


/usr/bin/taskset -c 6 /usr/bin/dbench -c /usr/share/dbench/client.txt -D /home/kvm1/sda3/ -t 30 $1
rm -rf /home/kvm1/sda3/clients
