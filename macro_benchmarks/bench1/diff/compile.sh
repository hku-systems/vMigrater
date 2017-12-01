#!/bin/bash

gcc main.c debug.c -o main -lpthread -lglib-2.0
#gcc io_mul.c ../debug.c -o 8io -lpthread -lglib-2.0
#gcc io_random_mul.c ../debug.c -o 8io_ran -lpthread -lglib-2.0
#gcc io_bursty_mul.c ../debug.c -o 8io_bursty -lpthread -lglib-2.0
#gcc io_random_mul_bursty.c ../debug.c -o 8io_ran_bursty -lpthread -lglib-2.0
#gcc io_reverse.c debug.c -o io_reverse -lpthread -lglib-2.0
#gcc io_original_reverse.c debug.c -o io_original_reverse -lpthread -lglib-2.0
#gcc main_backstage.c debug.c -o main_backstage -lpthread -lglib-2.0
#gcc io_original.c debug.c -o sio_seq -lpthread -lglib-2.0
#gcc io_original_bursty.c debug.c -o sio_seq_bursty -lpthread -lglib-2.0
#gcc io_original_random.c debug.c -o sio_ran -lpthread -lglib-2.0
#gcc io_original_random_bursty.c debug.c -o sio_ran_bursty -lpthread -lglib-2.0
