#!/bin/bash

process_id=`/bin/ps -aux | grep "/usr/bin/sysbench" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`

if [ "$1" == "1" ]
then
	#echo "sysbench main process id is $process_id1"
	#echo "sysbench I/O process id is $process_id"
	let process_id1=($process_id + 2)
	./main $process_id1
elif [ "$1" == "2" ]
then
	let process_id1=($process_id + 2)
	let process_id2=($process_id1 + 1)
	./main $process_id1 $process_id2
elif [ "$1" == "4" ]
then
	let process_id1=($process_id + 1)
	let process_id2=($process_id1 + 1)
	let process_id3=($process_id2 + 1)
	let process_id4=($process_id3 + 1)
	./main $process_id1 $process_id2 $process_id3 $process_id4
elif [ "$1" == "8" ]
then
	let process_id1=($process_id + 1)
	let process_id2=($process_id1 + 1)
	let process_id3=($process_id2 + 1)
	let process_id4=($process_id3 + 1)
	let process_id5=($process_id4 + 1)
	let process_id6=($process_id5 + 1)
	let process_id7=($process_id6 + 1)
	let process_id8=($process_id7 + 1)
	./main $process_id1 $process_id2 $process_id3 $process_id4 $process_id5 $process_id6 $process_id7 $process_id8
fi
#process_id1=`echo $process_id | awk -F' ' '{print $1}'`
#process_id2=`echo $process_id | awk -F' ' '{print $2}'`

#echo $process_id1
#echo $process_id2


