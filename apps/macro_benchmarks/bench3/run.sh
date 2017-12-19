#!/bin/bash

BENCH3_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench3

echo "This is macrobenchmark 3: $BENCH3_DIR"
echo "vMigrater script dir is $1"
echo "vMigrater results for macrobench 3 dir is $2"
echo "vMigrater tools dir is $3"

#1 thread
echo ">>>>>>>>>>>>>>>>>>>sysbench 1 thread, dedicated" > $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/sysbench2.sh 1 1 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/sysbench2.sh 1 1 >> $2

echo ">>>>>>>>>>>>>>>>>>>sysbench 1 thread, shared" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/sysbench2.sh 5 1 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/sysbench2.sh 5 1 >> $2


echo ">>>>>>>>>>>>>>>>>>>sysbench 1 thread, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/vMigrater_sysbench.sh &
$BENCH3_DIR/sysbench/sysbench2.sh 5 1 >> $2
killall -9 main
killall -9 vMigrater_sysbench.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/vMigrater_sysbench.sh &
$BENCH3_DIR/sysbench/sysbench2.sh 5 1 >> $2
killall -9 main
killall -9 vMigrater_sysbench.sh


#2 threads
echo ">>>>>>>>>>>>>>>>>>>sysbench 2 threads, dedicated" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/sysbench2.sh 1 2 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/sysbench2.sh 1 2 >> $2

echo ">>>>>>>>>>>>>>>>>>>sysbench 2 threads, shared" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/sysbench2.sh 5 2 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/sysbench2.sh 5 2 >> $2


echo ">>>>>>>>>>>>>>>>>>>sysbench 2 threads, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/vMigrater_sysbench.sh &
$BENCH3_DIR/sysbench/sysbench2.sh 5 2 >> $2
killall -9 main
killall -9 vMigrater_sysbench.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/vMigrater_sysbench.sh &
$BENCH3_DIR/sysbench/sysbench2.sh 5 2 >> $2
killall -9 main
killall -9 vMigrater_sysbench.sh

#4 threads
echo ">>>>>>>>>>>>>>>>>>>sysbench 4 threads, dedicated" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/sysbench2.sh 1 4 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/sysbench2.sh 1 4 >> $2

echo ">>>>>>>>>>>>>>>>>>>sysbench 4 threads, shared" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/sysbench2.sh 5 4 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/sysbench2.sh 5 4 >> $2


echo ">>>>>>>>>>>>>>>>>>>sysbench 4 thread, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/vMigrater_sysbench.sh &
$BENCH3_DIR/sysbench/sysbench2.sh 5 4 >> $2
killall -9 main
killall -9 vMigrater_sysbench.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/vMigrater_sysbench.sh &
$BENCH3_DIR/sysbench/sysbench2.sh 5 4 >> $2
killall -9 main
killall -9 vMigrater_sysbench.sh

#8 threads
echo ">>>>>>>>>>>>>>>>>>>sysbench 8 threads, dedicated" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/sysbench2.sh 1 8 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/sysbench2.sh 1 8 >> $2

echo ">>>>>>>>>>>>>>>>>>>sysbench 8 threads, shared" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/sysbench2.sh 5 8 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/sysbench2.sh 5 8 >> $2


echo ">>>>>>>>>>>>>>>>>>>sysbench 8 threads, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/vMigrater_sysbench.sh &
$BENCH3_DIR/sysbench/sysbench2.sh 5 8 >> $2
killall -9 main
killall -9 vMigrater_sysbench.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH3_DIR/sysbench/vMigrater_sysbench.sh &
$BENCH3_DIR/sysbench/sysbench2.sh 5 8 >> $2
killall -9 main
killall -9 vMigrater_sysbench.sh
