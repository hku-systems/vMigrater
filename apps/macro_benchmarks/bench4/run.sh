#!/bin/bash

BENCH4_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench4

echo "This is macrobenchmark 4: $BENCH4_DIR"
echo "vMigrater script dir is $1"
echo "vMigrater results for macrobench 4 dir is $2"
echo "vMigrater tools dir is $3"

#1 thread
echo ">>>>>>>>>>>>>>>>>>>leveldb 1 thread, dedicated" > $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH4_DIR/leveldb/leveldb2.sh 1 1 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH4_DIR/leveldb/leveldb2.sh 1 1 >> $2

echo ">>>>>>>>>>>>>>>>>>>leveldb 1 thread, shared" > $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH4_DIR/leveldb/leveldb2.sh 5 1 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH4_DIR/leveldb/leveldb2.sh 5 1 >> $2

echo ">>>>>>>>>>>>>>>>>>>leveldb 1 thread, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH4_DIR/leveldb/vMigrater_leveldb.sh &
$BENCH4_DIR/leveldb/leveldb2.sh 5 1 >> $2
killall -9 main
killall -9 vMigrater_leveldb.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH4_DIR/leveldb/vMigrater_leveldb.sh &
$BENCH4_DIR/leveldb/leveldb2.sh 5 1 >> $2
killall -9 main
killall -9 vMigrater_leveldb.sh

