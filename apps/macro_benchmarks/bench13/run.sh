#!/bin/bash

BENCH13_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench13
CAFFE_DIR=/home/kvm1/caffe


echo "This is macrobenchmark 13: $BENCH13_DIR"
echo "Make sure Caffe is installed in $CAFFE_DIR"
echo "vMigrater script dir is $1"
echo "vMigrater results for macrobench 13 dir is $2"
echo "vMigrater tools dir is $3"

cd $CAFFE_DIR
echo ">>>>>>>>>>>>>>>>>>>caffe, dedicated" > $2
$3/flush
$BENCH13_DIR/pin_caffe.sh 1 &
start_ts=$(($(date +%s%N)/1000))
$BENCH13_DIR/caffe.sh 1 > /dev/null
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "Caffe, it needs $diff_ts microseconds" >> $2


$3/flush
$BENCH13_DIR/pin_caffe.sh 1 &
start_ts=$(($(date +%s%N)/1000))
$BENCH13_DIR/caffe.sh 1 > /dev/null
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "Caffe, it needs $diff_ts microseconds" >> $2

echo ">>>>>>>>>>>>>>>>>>>caffe, shared" >> $2
$3/flush
$BENCH13_DIR/pin_caffe.sh 5 &
start_ts=$(($(date +%s%N)/1000))
$BENCH13_DIR/caffe.sh 5 > /dev/null
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "Caffe, it needs $diff_ts microseconds" >> $2


$3/flush
$BENCH13_DIR/pin_caffe.sh 5 &
start_ts=$(($(date +%s%N)/1000))
$BENCH13_DIR/caffe.sh 5 > /dev/null
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "Caffe, it needs $diff_ts microseconds" >> $2

echo ">>>>>>>>>>>>>>>>>>>caffe, shared with vMigrater" >> $2
$3/flush
$BENCH13_DIR/vMigrater_caffe.sh &
start_ts=$(($(date +%s%N)/1000))
$BENCH13_DIR/caffe.sh 5 > /dev/null
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "Caffe, it needs $diff_ts microseconds"
killall -9 main
killall -9 vMigrater_caffe.sh

$3/flush
$BENCH13_DIR/vMigrater_caffe.sh &
start_ts=$(($(date +%s%N)/1000))
$BENCH13_DIR/caffe.sh 5 > /dev/null
end_ts=$(($(date +%s%N)/1000))
let diff_ts=$end_ts-$start_ts
echo "Caffe, it needs $diff_ts microseconds"
killall -9 main
killall -9 vMigrater_caffe.sh
