#!/bin/bash

echo ">>>>>>>>>>>>>>>>>>>Sequential read, dedicated"

../../scripts/umount.sh
../../scripts/mount.sh
./sio_seq 1

../../scripts/umount.sh
../../scripts/mount.sh
./sio_seq 1

../../scripts/umount.sh
../../scripts/mount.sh
./sio_seq 1


echo ">>>>>>>>>>>>>>>>>>>>Sequential read, shared"

../../scripts/umount.sh
../../scripts/mount.sh
./sio_seq 5

../../scripts/umount.sh
../../scripts/mount.sh
./sio_seq 5

../../scripts/umount.sh
../../scripts/mount.sh
./sio_seq 5


echo ">>>>>>>>>>>>>>>>>>>Random read, dedicated"

../../scripts/umount.sh
../../scripts/mount.sh
./sio_ran 1

../../scripts/umount.sh
../../scripts/mount.sh
./sio_ran 1

../../scripts/umount.sh
../../scripts/mount.sh
./sio_ran 1


echo ">>>>>>>>>>>>>>>>>>>>Random read, shared"

../../scripts/umount.sh
../../scripts/mount.sh
./sio_ran 5

../../scripts/umount.sh
../../scripts/mount.sh
./sio_ran 5

../../scripts/umount.sh
../../scripts/mount.sh
./sio_ran 5


echo ">>>>>>>>>>>>>>>>>>>>Sequential bursty read, dedicated"

../../scripts/umount.sh
../../scripts/mount.sh
./sio_seq_bursty 1

../../scripts/umount.sh
../../scripts/mount.sh
./sio_seq_bursty 1

../../scripts/umount.sh
../../scripts/mount.sh
./sio_seq_bursty 1


echo ">>>>>>>>>>>>>>>>>>>>>Sequential bursty read, shared"

../../scripts/umount.sh
../../scripts/mount.sh
./sio_seq_bursty 5

../../scripts/umount.sh
../../scripts/mount.sh
./sio_seq_bursty 5

../../scripts/umount.sh
../../scripts/mount.sh
./sio_seq_bursty 5


echo ">>>>>>>>>>>>>>>>>>>>>Random bursty read, dedicated"

../../scripts/umount.sh
../../scripts/mount.sh
./sio_ran_bursty 1

../../scripts/umount.sh
../../scripts/mount.sh
./sio_ran_bursty 1

../../scripts/umount.sh
../../scripts/mount.sh
./sio_ran_bursty 1


echo ">>>>>>>>>>>>>>>>>>>>>>Random bursty read, shared"

../../scripts/umount.sh
../../scripts/mount.sh
./sio_ran_bursty 5

../../scripts/umount.sh
../../scripts/mount.sh
./sio_ran_bursty 5

../../scripts/umount.sh
../../scripts/mount.sh
./sio_ran_bursty 5
