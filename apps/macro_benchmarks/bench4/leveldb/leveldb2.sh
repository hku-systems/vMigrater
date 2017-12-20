#!/bin/bash

#if [ "$1" = "1" ]
#then
	# 1st run on shared vCPU
echo "leveldb, this is on vCPU $1 with $2 threads"
if mount | grep /dev/vda3 > /dev/null; then
	echo "No need to mount /dev/vda3"
else
	mount /dev/vda3 /home/kvm1/sda3
fi
rm /home/kvm1/sda3/leveldb/* -f
#echo "vCPU number: $1, thread number: $2"
#cd /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb
#./umount.sh
#./mount.sh
#./flush

	#/usr/bin/taskset -c $1 /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb/leveldb-1.20/out-static/db_bench --db=/home/kvm1/sda3/leveldb --num=100000000 --cache_size=0 --threads=$2 --value_size=100 --compression_ratio=0.0 --write_buffer_size=0  --benchmarks=fillsync
#/usr/bin/taskset -c $1 /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb/leveldb-1.20/out-static/db_bench --db=/home/kvm1/sda3/leveldb --num=5000000 --cache_size=0 --threads=$2 --value_size=100 --compression_ratio=0.0 --write_buffer_size=0  --benchmarks=fillsync,readrandom
#rm /home/kvm1/sda3/leveldb/* -f
	#cd /home/kvm1/sda3
	#/usr/bin/sysbench --test=fileio --file-total-size=10G prepare
	#echo "============> sysbench start to run===============>"
	#/usr/bin/taskset -c 6 /usr/bin/sysbench --test=fileio --max-time=30 --max-requests=0 --file-total-size=8GB --num-threads=$2 --file-test-mode=rndrw run
	#echo "============> sysbench end===============>"
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
	#echo "this is the 2nd"
	#start_ts=$(($(date +%s%N)/1000))
	#/usr/bin/taskset -c 6 /bin/cp /home/kvm1/sda2/testA /home/kvm1/sda3
	#end_ts=$(($(date +%s%N)/1000))
	#let diff_ts=$end_ts-$start_ts
	#echo "1st: It needs $diff_ts microseconds with vMigrater"
#fi
#!/bin/bash

#XXX: We test leveldb's write records in sync mode and also test leveldb's table scan

#echo "This is 1st dedicated vCPU===============================>"
#rm /home/kvm1/sda3/leveldb/* -f
#cd /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb
#./umount.sh
#./mount.sh
#./flush

/usr/bin/taskset -c $1 /home/kvm1/vMigrater/apps/macro_benchmarks/bench4/leveldb/leveldb-1.20/out-static/db_bench --db=/home/kvm1/sda3/leveldb --num=5000000 --cache_size=0 --threads=$2 --value_size=100 --compression_ratio=0.0 --write_buffer_size=0  --benchmarks=fillsync,readrandom
#/usr/bin/taskset -c 1 /home/kvm1/vMigrater/macro_benchmarks/bench4/leveldb/leveldb-1.20/out-static/db_bench --db=/home/kvm1/sda3/leveldb --num=100000000000 --cache_size=0 --threads=10 --value_size=1 --compression_ratio=0.0 --write_buffer_size=0  --benchmarks=readrandom --use_existing_db=1
rm /home/kvm1/sda3/leveldb/* -f

