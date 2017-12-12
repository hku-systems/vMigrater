#!/bin/bash

#XXX: We test leveldb's write records in sync mode and also test leveldb's table scan

echo "This is 1st dedicated vCPU===============================>"
rm /home/kvm1/sda3/leveldb/* -f
cd /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb
./umount.sh
./mount.sh
./flush

/usr/bin/taskset -c 1 /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb/leveldb-1.20/out-static/db_bench --db=/home/kvm1/sda3/leveldb --num=50000000 --cache_size=0 --threads=$1 --value_size=100 --compression_ratio=0.0 --write_buffer_size=0  --benchmarks=fillsync
#/usr/bin/taskset -c 1 /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb/leveldb-1.20/out-static/db_bench --db=/home/kvm1/sda3/leveldb --num=100000000000 --cache_size=0 --threads=10 --value_size=1 --compression_ratio=0.0 --write_buffer_size=0  --benchmarks=readrandom --use_existing_db=1
rm /home/kvm1/sda3/leveldb/* -f

echo "This is 2nd dedicated vCPU===============================>"
cd /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb
./umount.sh
./mount.sh
./flush

/usr/bin/taskset -c 1 /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb/leveldb-1.20/out-static/db_bench --db=/home/kvm1/sda3/leveldb --num=50000000 --cache_size=0 --threads=$1 --value_size=100 --compression_ratio=0.0 --write_buffer_size=0  --benchmarks=fillsync
rm /home/kvm1/sda3/leveldb/* -f

echo "This is 1st shared vCPU===============================>"
rm /home/kvm1/sda3/leveldb/* -f
cd /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb
./umount.sh
./mount.sh
./flush

/usr/bin/taskset -c 5 /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb/leveldb-1.20/out-static/db_bench --db=/home/kvm1/sda3/leveldb --num=50000000 --cache_size=0 --threads=$1 --value_size=100 --compression_ratio=0.0 --write_buffer_size=0  --benchmarks=fillsync
#/usr/bin/taskset -c 1 /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb/leveldb-1.20/out-static/db_bench --db=/home/kvm1/sda3/leveldb --num=100000000000 --cache_size=0 --threads=10 --value_size=1 --compression_ratio=0.0 --write_buffer_size=0  --benchmarks=readrandom --use_existing_db=1
rm /home/kvm1/sda3/leveldb/* -f

echo "This is 2nd shared vCPU===============================>"
cd /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb
./umount.sh
./mount.sh
./flush

/usr/bin/taskset -c 5 /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb/leveldb-1.20/out-static/db_bench --db=/home/kvm1/sda3/leveldb --num=50000000 --cache_size=0 --threads=$1 --value_size=100 --compression_ratio=0.0 --write_buffer_size=0  --benchmarks=fillsync
rm /home/kvm1/sda3/leveldb/* -f
