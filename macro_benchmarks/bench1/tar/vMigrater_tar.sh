#!/bin/bash

process_id=`/bin/ps -aux | grep "/bin/tar" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
echo $process_id
./main $process_id

