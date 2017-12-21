#!/bin/bash

BENCH6_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench6

echo "This is macrobenchmark 6: $BENCH6_DIR"
echo "vMigrater script dir is $1"
echo "vMigrater results for macrobench 6 dir is $2"
echo "vMigrater tools dir is $3"

echo ">>>>>>>>>>>>>>>>>>>sockperf, dedicated" > $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH6_DIR/net_perf/sockperf2.sh 1 >> $2


$1/umount.sh
$1/mount.sh
$3/flush
$BENCH6_DIR/net_perf/sockperf2.sh 1 >> $2

echo ">>>>>>>>>>>>>>>>>>>sockperf, shared" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH6_DIR/net_perf/sockperf2.sh 5 >> $2


$1/umount.sh
$1/mount.sh
$3/flush
$BENCH6_DIR/net_perf/sockperf2.sh 5 >> $2

echo ">>>>>>>>>>>>>>>>>>>nginx, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH6_DIR/net_perf/vMigrater_sockperf.sh &
$BENCH6_DIR/net_perf/sockperf2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_sockperf.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH6_DIR/net_perf/vMigrater_sockperf.sh &
$BENCH6_DIR/net_perf/sockperf2.sh 5 >> $2
killall -9 main
