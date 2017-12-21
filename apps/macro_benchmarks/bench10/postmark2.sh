#!/bin/bash

POSTMARK_DIR=/home/kvm1/vMigrater/apps/macro_benchmarks/bench10

taskset -c $1 postmark $POSTMARK_DIR/config4postmark
