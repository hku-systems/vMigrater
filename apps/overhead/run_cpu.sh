#!/bin/bash

for (( i=0; i<=$1; i++))
do
	echo "Set vCPU $i"
	taskset -c $i ./cpu &
done
