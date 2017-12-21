#!/bin/bash

echo "Sockperf, it is on vCPU $1"

SOCKPERF_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench6/net_perf/sockperf/sockperf-3.1
IP_ADDR_SERVER=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`
IP_ADDR_CLIENT="192.168.122.130"

#server side
/usr/bin/taskset -c $1 $SOCKPERF_DIR/sockperf server --tcp -i $IP_ADDR_SERVER -p 12345 &

#client side
ssh kvm1@$IP_ADDR_CLIENT /usr/bin/taskset -c $1 ./sockperf pp --tcp -i $IP_ADDR_SERVER -p 12345 -t 30

killall -9 sockperf

