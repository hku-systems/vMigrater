#!/bin/bash

process_id=`/bin/ps -aux | grep "/usr/bin/dbench" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`

#process_id1=`echo $process_id | awk -F' ' '{print $1}'`
#process_id2=`echo $process_id | awk -F' ' '{print $2}'`

#echo $process_id1
#echo $process_id2

./main $process_id

