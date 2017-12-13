#!/bin/bash

BIN_DIR=/home/kvm1/vMigrater/apps/micro_benchmarks/2io
BIN_MIGRATER=/home/kvm1/vMigrater/apps/micro_benchmarks/2io/with_migrater



echo ">>>>>>>>>>>>>>>>>>>Sequential read, dedicated" >> $2
$1/umount.sh
$1/mount.sh
$BIN_DIR/2io_seq 1 1 >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/2io_seq 1 1 >> $2



echo ">>>>>>>>>>>>>>>>>>>>Sequential read, shared" >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/2io_seq 5 5 >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/2io_seq 5 5 >> $2

echo ">>>>>>>>>>>>>>>>>>>>Sequential read, shared with vMigrater" >> $2

$1/umount.sh
$1/mount.sh
$BIN_MIGRATER/main &
$BIN_MIGRATER/2io >> $2
killall -9 main

$1/umount.sh
$1/mount.sh
$BIN_MIGRATER/main &
$BIN_MIGRATER/2io >> $2
killall -9 main


echo ">>>>>>>>>>>>>>>>>>>Random read, dedicated" >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/2io_ran 1 1 >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/2io_ran 1 1 >> $2

echo ">>>>>>>>>>>>>>>>>>>>Random read, shared" >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/2io_ran 5 5 >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/2io_ran 5 5 >> $2

echo ">>>>>>>>>>>>>>>>>>>>Random read, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$BIN_MIGRATER/main &
$BIN_MIGRATER/2io_ran >> $2
killall -9 main

$1/umount.sh
$1/mount.sh
$BIN_MIGRATER/main &
$BIN_MIGRATER/2io_ran >> $2
killall -9 main

echo ">>>>>>>>>>>>>>>>>>>>Sequential bursty read, dedicated" >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/2io_seq_bursty 1 1 >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/2io_seq_bursty 1 1 >> $2


echo ">>>>>>>>>>>>>>>>>>>>>Sequential bursty read, shared" >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/2io_seq_bursty 5 5 >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/2io_seq_bursty 5 5 >> $2

echo ">>>>>>>>>>>>>>>>>>>>>Sequential bursty read, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$BIN_MIGRATER/main &
$BIN_MIGRATER/2io_bursty >> $2
killall -9 main

$1/umount.sh
$1/mount.sh
$BIN_MIGRATER/main &
$BIN_MIGRATER/2io_bursty >> $2
killall -9 main



echo ">>>>>>>>>>>>>>>>>>>>>Random bursty read, dedicated" >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/2io_ran_bursty 1 1 >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/2io_ran_bursty 1 1 >> $2


echo ">>>>>>>>>>>>>>>>>>>>>>Random bursty read, shared" >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/2io_ran_bursty 5 5 >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/2io_ran_bursty 5 5 >> $2

echo ">>>>>>>>>>>>>>>>>>>>>>Random bursty read, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$BIN_MIGRATER/main &
$BIN_MIGRATER/2io_ran_bursty >> $2
killall -9 main

$1/umount.sh
$1/mount.sh
$BIN_MIGRATER/main &
$BIN_MIGRATER/2io_ran_bursty >> $2
killall -9 main
