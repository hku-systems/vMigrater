#!/bin/bash

process_id=`/bin/ps -aux | grep "/usr/bin/diff" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
echo $process_id
./main $process_id

