#!/bin/bash

#this script is used to install idle thread patch from source
#machine to destination machine.

#this sccript should be executed in source machine which has
#installed idle thread patch.
DES_IP="192.168.122.96"
#the kernel version among these machines should be based on Linux Kernel 4.7.4

KERN_DIR=/usr/src/linux-4.7.4
SYSCTL_HEADER_FILE=$KERN_DIR/include/linux/sched/sysctl.h
IDLE_FILE=$KERN_DIR/kernel/sched/idle.c
SYSCTL_FILE=$KERN_DIR/kernel/sysctl.c


sudo scp $SYSCTL_HEADER_FILE root@$DES_IP:$SYSCTL_HEADER_FILE
sudo scp $SYSCTL_FILE root@$DES_IP:$SYSCTL_FILE
sudo scp $IDLE_FILE root@$DES_IP:$IDLE_FILE
