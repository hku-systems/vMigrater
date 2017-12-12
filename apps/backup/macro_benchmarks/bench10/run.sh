#!/bin/bash

echo "This is sysbench Rondom read ........................................"
./sysbench_rndrd.sh 1
./sysbench_rndrd.sh 2
./sysbench_rndrd.sh 4
./sysbench_rndrd.sh 8

echo "This is sysbench Rondom read write combine ........................................"
./sysbench_rndrw.sh 1
./sysbench_rndrw.sh 2
./sysbench_rndrw.sh 4
./sysbench_rndrw.sh 8
