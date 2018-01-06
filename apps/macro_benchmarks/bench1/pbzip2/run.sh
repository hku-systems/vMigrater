#!/bin/bash

/home/kvm1/vMigrater/scripts/umount.sh

/home/kvm1/vMigrater/tools/flush
/home/kvm1/vMigrater/scripts/mount.sh

taskset -c 5 /usr/bin/pbzip2 -1 -p2 -m10 -b1 -rkvf /home/kvm1/ptest
