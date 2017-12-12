#!/bin/bash

gcc seq_read.c debug.c -o ./bin/seq_read -lpthread -lglib-2.0
gcc random_read.c debug.c -o ./bin/ran_read -lpthread -lglib-2.0
gcc main_backstage.c debug.c -o ./bin/main_backstage -lpthread -lglib-2.0
