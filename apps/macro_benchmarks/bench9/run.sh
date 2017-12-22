#!/bin/bash

BENCH9_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench9

echo "This is macrobenchmark 9: $BENCH9_DIR"
echo "vMigrater script dir is $1"
echo "vMigrater results for macrobench 9 dir is $2"
echo "vMigrater tools dir is $3"

echo ">>>>>>>>>>>>>>>>>>>parsec vips, dedicated" > $2
$3/flush
$BENCH9_DIR/vips2.sh 1 >> $2


$3/flush
$BENCH9_DIR/vips2.sh 1 >> $2

echo ">>>>>>>>>>>>>>>>>>>parsec vips, shared" >> $2
$3/flush
$BENCH9_DIR/vips2.sh 5 >> $2


$3/flush
$BENCH9_DIR/vips2.sh 5 >> $2

echo ">>>>>>>>>>>>>>>>>>>parsec vips, shared with vMigrater" >> $2
$3/flush
$BENCH9_DIR/vMigrater_vips.sh &
$BENCH9_DIR/vips2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_vips.sh

$3/flush
$BENCH9_DIR/vMigrater_vips.sh &
$BENCH9_DIR/vips2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_vips.sh

echo ">>>>>>>>>>>>>>>>>>>parsec x264, dedicated" >> $2
$3/flush
$BENCH9_DIR/x264_2.sh 1 >> $2


$3/flush
$BENCH9_DIR/x264_2.sh 1 >> $2

echo ">>>>>>>>>>>>>>>>>>>parsec x264, shared" >> $2
$3/flush
$BENCH9_DIR/x264_2.sh 5 >> $2


$3/flush
$BENCH9_DIR/x264_2.sh 5 >> $2

echo ">>>>>>>>>>>>>>>>>>>parsec x264, shared with vMigrater" >> $2
$3/flush
$BENCH9_DIR/vMigrater_x264.sh &
$BENCH9_DIR/x264_2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_x264.sh

$3/flush
$BENCH9_DIR/vMigrater_x264.sh &
$BENCH9_DIR/x264_2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_x264.sh
