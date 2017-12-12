#!/bin/bash

#gcc main.c debug.c -o main -lpthread -lglib-2.0
#gcc io.c debug.c -o io -lpthread -lglib-2.0
#gcc io_bursty.c debug.c -o io_bursty -lpthread -lglib-2.0
#gcc io_random.c debug.c -o io_random -lpthread -lglib-2.0
#gcc io_random_bursty.c debug.c -o io_random_bursty -lpthread -lglib-2.0
#gcc io_reverse.c debug.c -o io_reverse -lpthread -lglib-2.0
#gcc io_original_reverse.c debug.c -o io_original_reverse -lpthread -lglib-2.0
#gcc main_backstage.c debug.c -o main_backstage -lpthread -lglib-2.0
gcc io_original_mul.c debug.c -o 4io_seq -lpthread -lglib-2.0
gcc io_original_mul_bursty.c debug.c -o 4io_seq_bursty -lpthread -lglib-2.0
gcc io_original_random_mul.c debug.c -o 4io_ran -lpthread -lglib-2.0
gcc io_original_random_mul_bursty.c debug.c -o 4io_ran_bursty -lpthread -lglib-2.0
