#!/bin/bash

# 1st run on dedicated vCPU

#cd /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb
#./umount.sh
#./mount.sh
#./flush

#/usr/bin/taskset -c 1 /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb/leveldb-1.20/out-static/db_bench --db=/home/kvm1/sda3/leveldb --num=10000000000 --cache_size=0 --threads=1 --value_size=1 --compression_ratio=0.0 --write_buffer_size=0  --benchmarks=fillsync

rm /home/kvm1/sda3/leveldb/* -f
cd /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb
./umount.sh
./mount.sh
./flush

/usr/bin/taskset -c 1 /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb/leveldb-1.20/out-static/db_bench --db=/home/kvm1/sda3/leveldb --num=50000000 --cache_size=0 --threads=$1 --value_size=100 --compression_ratio=0.0 --write_buffer_size=0  --benchmarks=fillsync,readrandom
#/usr/bin/taskset -c 1 /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb/leveldb-1.20/out-static/db_bench --db=/home/kvm1/sda3/leveldb --num=100000000000 --cache_size=0 --threads=10 --value_size=1 --compression_ratio=0.0 --write_buffer_size=0  --benchmarks=readrandom --use_existing_db=1
rm /home/kvm1/sda3/leveldb/* -f

cd /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb
./umount.sh
./mount.sh
./flush

/usr/bin/taskset -c 6 /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb/leveldb-1.20/out-static/db_bench --db=/home/kvm1/sda3/leveldb --num=200000000 --cache_size=0 --threads=$1 --value_size=100 --compression_ratio=0.0 --write_buffer_size=0  --benchmarks=fillsync,readseq
rm /home/kvm1/sda3/leveldb/* -f
#/usr/bin/taskset -c 6 /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb/leveldb-1.20/out-static/db_bench --db=/home/kvm1/sda3/leveldb --num=100000000000 --cache_size=0 --threads=$1 --value_size=10 --compression_ratio=0.0 --write_buffer_size=0  --benchmarks=readseq --use_existing_db=1
#/usr/bin/taskset -c 6 /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb/leveldb-1.20/out-static/db_bench --db=/home/kvm1/sda3/leveldb --num=100000000000 --cache_size=0 --threads=10 --value_size=1 --compression_ratio=0.0 --write_buffer_size=0  --benchmarks=readrandom --use_existing_db=1

#rm /home/kvm1/sda3/leveldb/* -f

#start_ts=$(($(date +%s%N)/1000))
#/usr/bin/taskset -c 1 /bin/cp /home/kvm1/sda2/testA /home/kvm1/sda3
#end_ts=$(($(date +%s%N)/1000))
#let diff_ts=$end_ts-$start_ts
#echo "It needs $diff_ts microseconds"
#rm /home/kvm1/sda3/testA
#/usr/bin/taskset -c 1 /usr/bin/dbench -s -c /usr/share/dbench/client.txt -D /home/kvm1/sda3/ -t 30 $1
#cd /home/kvm1/sda3
#/usr/bin/sysbench --test=fileio --file-total-size=10G prepare
#/usr/bin/sysbench --test=fileio --file-total-size=10G cleanup
#cd /home/kvm1/vMigrater/macro_benchmarks/bench3/sysbench

# 2nd run on dedicated vCPU
#./umount.sh
#./mount.sh
#./flush


#cd /home/kvm1/sda3
#/usr/bin/sysbench --test=fileio --file-total-size=10G prepare
#/usr/bin/taskset -c 1 /usr/bin/sysbench --test=fileio --num-threads=$1 --file-test-mode=seqrd --file-total-size=8GB run
#/usr/bin/sysbench --test=fileio --file-total-size=10G cleanup
#cd /home/kvm1/vMigrater/macro_benchmarks/bench3/sysbench

#start_ts=$(($(date +%s%N)/1000))
#/usr/bin/taskset -c 1 /bin/cp /home/kvm1/sda2/testA /home/kvm1/sda3
#end_ts=$(($(date +%s%N)/1000))
#let diff_ts=$end_ts-$start_ts
#echo "It needs $diff_ts microseconds"
#rm /home/kvm1/sda3/testA

