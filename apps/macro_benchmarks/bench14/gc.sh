#!/bin/bash

GC_DIR=~/PowerGraph

/usr/bin/taskset $1 mpiexec -n 2 -hostfile ~/machines ~/PowerGraph/release/toolkits/graph_analytics/pagerank --powerlaw=10000000
