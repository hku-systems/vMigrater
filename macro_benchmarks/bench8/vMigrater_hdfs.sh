#!/bin/bash

#while true; do
process_id=`/bin/ps -aux | grep "/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
echo "hdfs main thread id: $process_id"
	
cd /proc/$process_id/task/
#search_dir=/proc/$process_id/task
#files=(*)

#files=*
echo *

./main *

#total=${#files[*]}

#echo "there are $total tasks under main thread"

#for (( i=0; i<=$(( $total -1 )); i++ ))
#do 
#	echo -n "${files[$i]} "
#done

#echo

#echo ${files[1]}
	
#for entry in *
#do
#	#sudo taskset -pc $1 $entry
#	$i=$entry
#	i=i+1
#done
#
#for (( i=0; i<=$(( $total -1 )); i++ ))
#done
