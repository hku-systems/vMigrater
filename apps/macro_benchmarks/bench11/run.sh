#!/bin/bash

BENCH11_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench11
TPCC_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench11/tpcc-mysql

echo "This is macrobenchmark 11: $BENCH11_DIR"
echo "vMigrater script dir is $1"
echo "vMigrater results for macrobench 11 dir is $2"
echo "vMigrater tools dir is $3"

#load tpcc data
$TPCC_DIR/pre_set_tpcc.sh

echo ">>>>>>>>>>>>>>>>>>>tpcc, dedicated" > $2
$1/umount.sh
$1/mount.sh
$3/flush
$TPCC_DIR/start_tpcc.sh 1

$1/umount.sh
$1/mount.sh
$3/flush
$TPCC_DIR/start_tpcc.sh 1

echo ">>>>>>>>>>>>>>>>>>>tpcc, shared" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$TPCC_DIR/start_tpcc.sh 5

$1/umount.sh
$1/mount.sh
$3/flush
$TPCC_DIR/start_tpcc.sh 5

echo ">>>>>>>>>>>>>>>>>>>tpcc, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH11_DIR/vMigrater_tpcc.sh &
$TPCC_DIR/start_tpcc.sh 5
killall -9 main
killall -9 vMigrater_tpcc.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH11_DIR/vMigrater_tpcc.sh &
$TPCC_DIR/start_tpcc.sh 5
killall -9 main
killall -9 vMigrater_tpcc.sh
