#!/bin/bash

BIN_DIR=/home/kvm1/vMigrater/apps/micro_benchmarks/sio



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