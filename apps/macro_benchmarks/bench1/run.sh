#!/bin/bash

BENCH1_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench1
TESTA=/home/kvm1/sda2/testA
TESTB=/home/kvm1/sda3/testB

echo "This is macrobenchmark 1: $BENCH1_DIR"
echo "vMigrater script dir is $1"
echo "vMigrater results for macrobench 1 dir is $2"
echo "vMigrater tools dir is $3"

#do some init works
if mount | grep /dev/vda3 > /dev/null; then
	echo "INFO: no need to mount vda3"
else
	$1/mount.sh
fi
if [ -f $TESTB ]; then
	mv /home/kvm1/sda3/testB /home/kvm1/
fi

#we need to cleanup last time's results in the beginning
echo ">>>>>>>>>>>>>>>>>>>Copy, dedicated" > $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/copy/cp2.sh 1 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/copy/cp2.sh 1 >> $2


echo ">>>>>>>>>>>>>>>>>>>Copy, shared" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/copy/cp2.sh 5 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/copy/cp2.sh 5 >> $2


echo ">>>>>>>>>>>>>>>>>>>Copy, shared with vMigrater" >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/copy/vMigrater_cp.sh &
$BENCH1_DIR/copy/cp2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_cp.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/copy/vMigrater_cp.sh &
$BENCH1_DIR/copy/cp2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_cp.sh

#recovery
if mount | grep /dev/vda3 > /dev/null; then
	echo "INFO: no need to mount vda3"
else
	$1/mount.sh
fi
if [ ! -f $TESTB ]; then
	mv /home/kvm1/testB /home/kvm1/sda3
fi
$1/umount.sh
