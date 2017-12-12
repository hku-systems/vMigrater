#!/bin/bash

gcc seq_read.c debug.c -o seq_read -lpthread -lglib-2.0
gcc random_read.c debug.c -o ran_read -lpthread -lglib-2.0
gcc main_backstage.c debug.c -o main_backstage -lpthread -lglib-2.0
