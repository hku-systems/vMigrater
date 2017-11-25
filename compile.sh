#!/bin/bash

#create build dir
mkdir build

#core part
gcc main.c debug.c -o ./build/main -lpthread -lglib-2.0
gcc backstage.c debug.c -o ./build/backstage -lpthread -lglib-2.0


#tools
gcc ./tools/flush.c debug.c -o ./build/flush -lpthread -lglib-2.0
