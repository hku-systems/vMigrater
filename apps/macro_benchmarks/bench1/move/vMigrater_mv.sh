#!/bin/bash

process_id=`/bin/ps -aux | grep "mv" | grep -v "grep" | grep -v "bash" | awk '{print $2}'`
./main $process_id

