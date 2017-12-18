#!/bin/bash

BENCH1_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench1

echo "This is macrobenchmark 1: $BENCH1_DIR"
echo "vMigrater script dir is $1"
echo "vMigrater results for macrobench 1 dir is $2"

#do some init works
$1/mount.sh
mv /home/kvm1/sda3/testB /home/kvm1/


echo ">>>>>>>>>>>>>>>>>>>Copy, dedicated" >> $2
$1/umount.sh
$1/mount.sh
$BENCH1_DIR/copy/cp2.sh 1 >> $2

$1/umount.sh
$1/mount.sh
$BENCH1_DIR/copy/cp2.sh 1 >> $2


echo ">>>>>>>>>>>>>>>>>>>Copy, shared" >> $2
$1/umount.sh
$1/mount.sh
$BENCH1_DIR/copy/cp2.sh 5 >> $2

$1/umount.sh
$1/mount.sh
$BENCH1_DIR/copy/cp2.sh 5 >> $2


echo ">>>>>>>>>>>>>>>>>>>Copy, shared with vMigrater" >> $2

$1/umount.sh
$1/mount.sh
$BENCH1_DIR/copy/vMigrater_cp.sh &
$BENCH1_DIR/copy/cp2.sh 5 >> $2
killall -9 main

$1/umount.sh
$1/mount.sh
$BENCH1_DIR/copy/vMigrater_cp.sh &
$BENCH1_DIR/copy/cp2.sh 5 >> $2
killall -9 main

#recovery
$1/mount.sh
mv /home/kvm1/testB /home/kvm1/sda3
$1/umount.sh
