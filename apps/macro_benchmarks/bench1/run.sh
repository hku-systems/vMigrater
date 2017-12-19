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

#We need to cleanup last time's results in the beginning
#Copy macrobenchmark
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

#Move macrobenchmark
echo ">>>>>>>>>>>>>>>>>>>Move, dedicated" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/move/mv2.sh 1 1 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/move/mv2.sh 1 2 >> $2


echo ">>>>>>>>>>>>>>>>>>>Move, shared" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/move/mv2.sh 5 1 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/move/mv2.sh 5 2 >> $2


echo ">>>>>>>>>>>>>>>>>>>Move, shared with vMigrater" >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/move/vMigrater_mv.sh &
$BENCH1_DIR/move/mv2.sh 5 1 >> $2
killall -9 main
killall -9 vMigrater_mv.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/move/vMigrater_mv.sh &
$BENCH1_DIR/move/mv2.sh 5 2 >> $2
killall -9 main
killall -9 vMigrater_mv.sh

#dd macrobenchmark
echo ">>>>>>>>>>>>>>>>>>>dd, dedicated" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/dd/dd2.sh 1 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/dd/dd2.sh 1 >> $2


echo ">>>>>>>>>>>>>>>>>>>dd, shared" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/dd/dd2.sh 5 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/dd/dd2.sh 5 >> $2


echo ">>>>>>>>>>>>>>>>>>>dd, shared with vMigrater" >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/dd/vMigrater_dd.sh &
$BENCH1_DIR/dd/dd2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_dd.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/dd/vMigrater_dd.sh &
$BENCH1_DIR/dd/dd2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_dd.sh

#diff
echo ">>>>>>>>>>>>>>>>>>>diff, dedicated" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/diff/diff2.sh 1 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/diff/diff2.sh 1 >> $2


echo ">>>>>>>>>>>>>>>>>>>diff, shared" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/diff/diff2.sh 5 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/diff/diff2.sh 5 >> $2


echo ">>>>>>>>>>>>>>>>>>>diff, shared with vMigrater" >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/diff/vMigrater_diff.sh &
$BENCH1_DIR/diff/diff2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_diff.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/diff/vMigrater_diff.sh &
$BENCH1_DIR/diff/diff2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_diff.sh

#grep
echo ">>>>>>>>>>>>>>>>>>>grep, dedicated" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/grep/grep2.sh 1 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/grep/grep2.sh 1 >> $2

echo ">>>>>>>>>>>>>>>>>>>grep, shared" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/grep/grep2.sh 5 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/grep/grep2.sh 5 >> $2

echo ">>>>>>>>>>>>>>>>>>>grep, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/grep/vMigrater_grep.sh &
$BENCH1_DIR/grep/grep2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_grep.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH1_DIR/grep/vMigrater_grep.sh &
$BENCH1_DIR/grep/grep2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_grep.sh

#before tar and zip, we need to do some inits
wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.14.3.tar.xz
tar xvf linux-4.14.3.tar.xz

#tar
echo ">>>>>>>>>>>>>>>>>>>tar, dedicated" >> $2
$3/flush
$BENCH1_DIR/tar/tar2.sh 1 >> $2

$3/flush
$BENCH1_DIR/tar/tar2.sh 1 >> $2

echo ">>>>>>>>>>>>>>>>>>>tar, shared" >> $2
$3/flush
$BENCH1_DIR/tar/tar2.sh 5 >> $2

$3/flush
$BENCH1_DIR/tar/tar2.sh 5 >> $2

echo ">>>>>>>>>>>>>>>>>>>tar, shared with vMigrater" >> $2
$3/flush
$BENCH1_DIR/grep/vMigrater_tar.sh &
$BENCH1_DIR/tar/tar2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_tar.sh

$3/flush
$BENCH1_DIR/grep/vMigrater_tar.sh &
$BENCH1_DIR/tar/tar2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_tar.sh

#zip
echo ">>>>>>>>>>>>>>>>>>>zip, dedicated" >> $2
$3/flush
$BENCH1_DIR/zip/zip2.sh 1 >> $2

$3/flush
$BENCH1_DIR/zip/zip2.sh 1 >> $2

echo ">>>>>>>>>>>>>>>>>>>zip, shared" >> $2
$3/flush
$BENCH1_DIR/zip/zip2.sh 5 >> $2

$3/flush
$BENCH1_DIR/zip/zip2.sh 5 >> $2

echo ">>>>>>>>>>>>>>>>>>>zip, shared with vMigrater" >> $2
$3/flush
$BENCH1_DIR/grep/vMigrater_zip.sh &
$BENCH1_DIR/zip/zip2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_zip.sh

$3/flush
$BENCH1_DIR/grep/vMigrater_zip.sh &
$BENCH1_DIR/zip/zip2.sh 5 >> $2
killall -9 main
killall -9 vMigrater_zip.sh


#recovery
rm linux-4.14.3.tar.xz
rm -rf linux-4.14.3
if mount | grep /dev/vda3 > /dev/null; then
	echo "INFO: no need to mount vda3"
else
	$1/mount.sh
fi
if [ ! -f $TESTB ]; then
	mv /home/kvm1/testB /home/kvm1/sda3
fi
$1/umount.sh
