#!/bin/bash

BENCH2_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench2

echo "This is macrobenchmark 2: $BENCH2_DIR"
echo "vMigrater script dir is $1"
echo "vMigrater results for macrobench 2 dir is $2"
echo "vMigrater tools dir is $3"

#1 thread
echo ">>>>>>>>>>>>>>>>>>>dbench 1 thread, dedicated" > $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/dbench2.sh 1 1 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/dbench2.sh 1 1 >> $2

echo ">>>>>>>>>>>>>>>>>>>dbench 1 thread, shared" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/dbench2.sh 5 1 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/dbench2.sh 5 1 >> $2


echo ">>>>>>>>>>>>>>>>>>>dbench 1 thread, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/vMigrater_dbench.sh &
$BENCH2_DIR/dbench/dbench2.sh 5 1 >> $2
killall -9 main
killall -9 vMigrater_dbench.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/vMigrater_dbench.sh &
$BENCH2_DIR/dbench/dbench2.sh 5 1 >> $2
killall -9 main
killall -9 vMigrater_dbench.sh

# 2 threads
echo ">>>>>>>>>>>>>>>>>>>dbench 2 threads, dedicated" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/dbench2.sh 1 2 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/dbench2.sh 1 2 >> $2

echo ">>>>>>>>>>>>>>>>>>>dbench 2 threads, shared" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/dbench2.sh 5 2 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/dbench2.sh 5 2 >> $2


echo ">>>>>>>>>>>>>>>>>>>dbench 2 threads, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/vMigrater_dbench.sh &
$BENCH2_DIR/dbench/dbench2.sh 5 2 >> $2
killall -9 main
killall -9 vMigrater_dbench.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/vMigrater_dbench.sh &
$BENCH2_DIR/dbench/dbench2.sh 5 2 >> $2
killall -9 main
killall -9 vMigrater_dbench.sh

# 4 threads
echo ">>>>>>>>>>>>>>>>>>>dbench 4 threads, dedicated" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/dbench2.sh 1 4 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/dbench2.sh 1 4 >> $2

echo ">>>>>>>>>>>>>>>>>>>dbench 4 threads, shared" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/dbench2.sh 5 4 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/dbench2.sh 5 4 >> $2


echo ">>>>>>>>>>>>>>>>>>>dbench 4 threads, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/vMigrater_dbench.sh &
$BENCH2_DIR/dbench/dbench2.sh 5 4 >> $2
killall -9 main
killall -9 vMigrater_dbench.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/vMigrater_dbench.sh &
$BENCH2_DIR/dbench/dbench2.sh 5 4 >> $2
killall -9 main
killall -9 vMigrater_dbench.sh

# 8 threads
echo ">>>>>>>>>>>>>>>>>>>dbench 8 threads, dedicated" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/dbench2.sh 1 8 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/dbench2.sh 1 8 >> $2

echo ">>>>>>>>>>>>>>>>>>>dbench 8 threads, shared" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/dbench2.sh 5 8 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/dbench2.sh 5 8 >> $2


echo ">>>>>>>>>>>>>>>>>>>dbench 8 threads, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/vMigrater_dbench.sh &
$BENCH2_DIR/dbench/dbench2.sh 5 8 >> $2
killall -9 main
killall -9 vMigrater_dbench.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH2_DIR/dbench/vMigrater_dbench.sh &
$BENCH2_DIR/dbench/dbench2.sh 5 8 >> $2
killall -9 main
killall -9 vMigrater_dbench.sh

