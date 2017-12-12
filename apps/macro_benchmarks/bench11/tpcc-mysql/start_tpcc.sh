#!/bin/bash
#please run following commands under /home/kvm1/vMigrater/macro_benchmarks/bench11/tpcc-mysql


./tpcc_start -h127.0.0.1 -P3306 -dtpcc1000 -uroot -p123 -w10 -c32 -r10 -l150
