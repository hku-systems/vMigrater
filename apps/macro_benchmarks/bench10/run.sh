#!/bin/bash

BENCH10_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench10

echo "This is macrobenchmark 10: $BENCH10_DIR"
echo "vMigrater script dir is $1"
echo "vMigrater results for macrobench 10 dir is $2"
echo "vMigrater tools dir is $3"

echo ">>>>>>>>>>>>>>>>>>>postmark, dedicated" > $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH10_DIR/postmark2.sh 1 >> $2


$1/umount.sh
$1/mount.sh
$3/flush
$BENCH10_DIR/postmark2.sh 1 >> $2

echo ">>>>>>>>>>>>>>>>>>>postmark, shared" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH10_DIR/postmark2.sh 5 >> $2


$1/umount.sh
$1/mount.sh
$3/flush
$BENCH10_DIR/postmark2.sh 5 >> $2

echo ">>>>>>>>>>>>>>>>>>>postmark, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH10_DIR/vMigrater_postmark.sh &
$BENCH10_DIR/postmark2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_postmark.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH10_DIR/vMigrater_postmark.sh &
$BENCH10_DIR/postmark2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_postmark.sh
