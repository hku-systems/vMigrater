#!/bin/bash

echo ">>>>>>>>>>>>>>>>>>>Sequential read, dedicated"

../../scripts/umount.sh
../../scripts/mount.sh
./2io_seq 1 1

../../scripts/umount.sh
../../scripts/mount.sh
./2io_seq 1 1


echo ">>>>>>>>>>>>>>>>>>>>Sequential read, shared"

../../scripts/umount.sh
../../scripts/mount.sh
./2io_seq 5 5

../../scripts/umount.sh
../../scripts/mount.sh
./2io_seq 5 5

echo ">>>>>>>>>>>>>>>>>>>Random read, dedicated"

../../scripts/umount.sh
../../scripts/mount.sh
./2io_ran 1 1

../../scripts/umount.sh
../../scripts/mount.sh
./2io_ran 1 1


echo ">>>>>>>>>>>>>>>>>>>>Random read, shared"

../../scripts/umount.sh
../../scripts/mount.sh
./2io_ran 5 5

../../scripts/umount.sh
../../scripts/mount.sh
./2io_ran 5 5


echo ">>>>>>>>>>>>>>>>>>>>Sequential bursty read, dedicated"

../../scripts/umount.sh
../../scripts/mount.sh
./2io_seq_bursty 1 1

../../scripts/umount.sh
../../scripts/mount.sh
./2io_seq_bursty 1 1


echo ">>>>>>>>>>>>>>>>>>>>>Sequential bursty read, shared"

../../scripts/umount.sh
../../scripts/mount.sh
./2io_seq_bursty 5 5

../../scripts/umount.sh
../../scripts/mount.sh
./2io_seq_bursty 5 5

echo ">>>>>>>>>>>>>>>>>>>>>Random bursty read, dedicated"

../../scripts/umount.sh
../../scripts/mount.sh
./2io_ran_bursty 1 1

../../scripts/umount.sh
../../scripts/mount.sh
./2io_ran_bursty 1 1


echo ">>>>>>>>>>>>>>>>>>>>>Random bursty read, shared"

../../scripts/umount.sh
../../scripts/mount.sh
./2io_ran_bursty 5 5

../../scripts/umount.sh
../../scripts/mount.sh
./2io_ran_bursty 5 5

