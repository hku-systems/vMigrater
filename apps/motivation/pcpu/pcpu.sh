#!/bin/bash

#sequential read
./bin/flush
./bin/seq_read
./bin/flush
./bin/seq_read
./bin/flush
./bin/seq_read

#random read
./bin/flush
./bin/ran_read
./bin/flush
./bin/ran_read
./bin/flush
./bin/ran_read
