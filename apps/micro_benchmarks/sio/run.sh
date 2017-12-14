#!/bin/bash

BIN_DIR=/home/kvm1/vMigrater/apps/micro_benchmarks/sio
BIN_MIGRATER=/home/kvm1/vMigrater/apps/micro_benchmarks/sio/with_migrater

echo "This is microbenchmark single io.............."
echo "vMigrater script dir is $1"
echo "vMigrater for single io dir is $2"
echo "Single IO BIN dir is $BIN_DIR"
echo "Single IO vMigrater BIN dir is $BIN_MIGRATER"


echo ">>>>>>>>>>>>>>>>>>>Sequential read, dedicated" >> $2
$1/umount.sh
$1/mount.sh
$BIN_DIR/sio_seq 1 >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/sio_seq 1 >> $2



echo ">>>>>>>>>>>>>>>>>>>>Sequential read, shared" >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/sio_seq 5 >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/sio_seq 5 >> $2

echo ">>>>>>>>>>>>>>>>>>>>Sequential read, shared with vMigrater" >> $2

$1/umount.sh
$1/mount.sh
$BIN_MIGRATER/main &
$BIN_MIGRATER/io >> $2
killall -9 main

$1/umount.sh
$1/mount.sh
$BIN_MIGRATER/main &
$BIN_MIGRATER/io >> $2
killall -9 main


echo ">>>>>>>>>>>>>>>>>>>Random read, dedicated" >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/sio_ran 1 >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/sio_ran 1 >> $2

echo ">>>>>>>>>>>>>>>>>>>>Random read, shared" >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/sio_ran 5 >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/sio_ran 5 >> $2

echo ">>>>>>>>>>>>>>>>>>>>Random read, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$BIN_MIGRATER/main &
$BIN_MIGRATER/io_ran >> $2
killall -9 main

$1/umount.sh
$1/mount.sh
$BIN_MIGRATER/main &
$BIN_MIGRATER/io_ran >> $2
killall -9 main

echo ">>>>>>>>>>>>>>>>>>>>Sequential bursty read, dedicated" >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/sio_seq_bursty 1 >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/sio_seq_bursty 1 >> $2


echo ">>>>>>>>>>>>>>>>>>>>>Sequential bursty read, shared" >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/sio_seq_bursty 5 >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/sio_seq_bursty 5 >> $2

echo ">>>>>>>>>>>>>>>>>>>>>Sequential bursty read, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$BIN_MIGRATER/main &
$BIN_MIGRATER/io_bursty >> $2
killall -9 main

$1/umount.sh
$1/mount.sh
$BIN_MIGRATER/main &
$BIN_MIGRATER/io_bursty >> $2
killall -9 main



echo ">>>>>>>>>>>>>>>>>>>>>Random bursty read, dedicated" >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/sio_ran_bursty 1 >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/sio_ran_bursty 1 >> $2


echo ">>>>>>>>>>>>>>>>>>>>>>Random bursty read, shared" >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/sio_ran_bursty 5 >> $2

$1/umount.sh
$1/mount.sh
$BIN_DIR/sio_ran_bursty 5 >> $2

echo ">>>>>>>>>>>>>>>>>>>>>>Random bursty read, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$BIN_MIGRATER/main &
$BIN_MIGRATER/io_ran_bursty >> $2
killall -9 main

$1/umount.sh
$1/mount.sh
$BIN_MIGRATER/main &
$BIN_MIGRATER/io_ran_bursty >> $2
killall -9 main
