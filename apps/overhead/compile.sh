#!/bin/bash

gcc cpu.c debug.c -o cpu -lpthread -lglib-2.0
gcc get_vcpu_ts.c debug.c -o get_vcpu_ts -lpthread -lglib-2.0
gcc io_original.c debug.c -o io_original -lpthread -lglib-2.0
gcc io_original_nothinktime.c debug.c -o io_original_nothinktime -lpthread -lglib-2.0
gcc io_original_daemon.c debug.c -o io_original_daemon -lpthread -lglib-2.0
