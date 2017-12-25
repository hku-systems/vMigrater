#!/bin/bash

CAFFE_DIR=~/caffe
cd $CAFFE_DIR

/usr/bin/taskset $1 $CAFFE_DIR/build/tools/caffe train --solver=$CAFFE_DIR/examples/mnist/lenet_solver.prototxt
