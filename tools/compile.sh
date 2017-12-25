#!/bin/bash

gcc flush.c debug.c -o flush -lpthread -lglib-2.0
gcc get_vcpu_ts.c debug.c -o get_vcpu_ts -lpthread -lglib-2.0
