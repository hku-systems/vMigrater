#!/bin/bash
#please run following commands under /home/kvm1/vMigrater/macro_benchmarks/bench11/tpcc-mysql

process_id=`/bin/ps -aux | grep "/usr/sbin/mysqld" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
echo "mysqld's main task pid is $process_id"
cd /proc/$process_id/task/
for entry in *
do
	echo "$entry"
	sudo taskset -pc 1 $entry
done
cd /home/kvm1/vMigrater/macro_benchmarks/bench11/tpcc-mysql 
mysqladmin -uroot -p123 drop tpcc1000
mysqladmin -uroot -p123 create tpcc1000
mysql -uroot -p123 tpcc1000 < create_table.sql
mysql -uroot -p123 tpcc1000 < add_fkey_idx.sql
./tpcc_load -h127.0.0.1 -dtpcc1000 -uroot -p123 -w 10

