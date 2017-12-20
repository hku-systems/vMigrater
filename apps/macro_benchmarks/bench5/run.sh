#!/bin/bash

BENCH5_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench5

echo "This is macrobenchmark 5: $BENCH5_DIR"
echo "vMigrater script dir is $1"
echo "vMigrater results for macrobench 5 dir is $2"
echo "vMigrater tools dir is $3"

process_id1=`/bin/ps -aux | grep "nginx:" | grep -v "grep" | grep -v "bash" | awk '{print $2}' | awk 'NR==1 {print; exit}'`
process_id2=`/bin/ps -aux | grep "nginx:" | grep -v "grep" | grep -v "bash" | awk '{print $2}' | awk 'NR==2 {print; exit}'`
process_id3=`/bin/ps -aux | grep "nginx:" | grep -v "grep" | grep -v "bash" | awk '{print $2}' | awk 'NR==3 {print; exit}'`
process_id4=`/bin/ps -aux | grep "nginx:" | grep -v "grep" | grep -v "bash" | awk '{print $2}' | awk 'NR==4 {print; exit}'`
process_id5=`/bin/ps -aux | grep "nginx:" | grep -v "grep" | grep -v "bash" | awk '{print $2}' | awk 'NR==5 {print; exit}'`

echo ">>>>>>>>>>>>>>>>>>>nginx, dedicated" > $2
#server side
sudo taskset -pc 1 $process_id1
sudo taskset -pc 1 $process_id2
sudo taskset -pc 1 $process_id3
sudo taskset -pc 1 $process_id4
sudo taskset -pc 1 $process_id5

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH5_DIR/web_server/nginx2.sh 1 500 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH5_DIR/web_server/nginx2.sh 1 500 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH5_DIR/web_server/nginx2.sh 1 1000 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH5_DIR/web_server/nginx2.sh 1 1000 >> $2

echo ">>>>>>>>>>>>>>>>>>>nginx, shared" >> $2
#FIXME: this should be done in server side
sudo taskset -pc 5 $process_id1
sudo taskset -pc 5 $process_id2
sudo taskset -pc 5 $process_id3
sudo taskset -pc 5 $process_id4
sudo taskset -pc 5 $process_id5

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH5_DIR/web_server/nginx2.sh 5 500 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH5_DIR/web_server/nginx2.sh 5 500 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH5_DIR/web_server/nginx2.sh 5 1000 >> $2

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH5_DIR/web_server/nginx2.sh 5 1000 >> $2

echo ">>>>>>>>>>>>>>>>>>>nginx, shared with vMigrater" >> $2
$1/umount.sh
$1/mount.sh
$3/flush
$BENCH5_DIR/web_server/vMigrater_nginx.sh &
$BENCH5_DIR/web_server/nginx2.sh 5 500 >> $2
killall -9 main
killall -9 vMigrater_nginx.sh


$1/umount.sh
$1/mount.sh
$3/flush
$BENCH5_DIR/web_server/vMigrater_nginx.sh &
$BENCH5_DIR/web_server/nginx2.sh 5 500 >> $2
killall -9 main
killall -9 vMigrater_nginx.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH5_DIR/web_server/vMigrater_nginx.sh &
$BENCH5_DIR/web_server/nginx2.sh 5 1000 >> $2
killall -9 main
killall -9 vMigrater_nginx.sh

$1/umount.sh
$1/mount.sh
$3/flush
$BENCH5_DIR/web_server/vMigrater_nginx.sh &
$BENCH5_DIR/web_server/nginx2.sh 5 1000 >> $2
killall -9 main
killall -9 vMigrater_nginx.sh
