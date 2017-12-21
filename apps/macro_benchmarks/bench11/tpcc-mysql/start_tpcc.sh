#!/bin/bash
#please run following commands under /home/kvm1/vMigrater/macro_benchmarks/bench11/tpcc-mysql

TPCC_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench11/tpcc-mysql

$TPCC_DIR/pin_mysqld.sh $1
#$TPCC_DIR/pre_set_tpcc.sh
$TPCC_DIR/pin_tpcc.sh 1 &
$TPCC_DIR/tpcc_start -h127.0.0.1 -P3306 -dtpcc1000 -uroot -p123 -w10 -c32 -r10 -l150
