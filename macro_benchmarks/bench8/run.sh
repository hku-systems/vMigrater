#!/bin/bash

#echo "This is leveldb fillsync benchmark for vMigrater ........................................"
#./leveldb_fillsync.sh 1
#./leveldb_fillsync.sh 2
#./leveldb_fillsync.sh 4
#./leveldb_fillsync.sh 8

echo "This is leveldb table scan for vMigrater ........................................"
./leveldb_table_scan.sh 1
./leveldb_table_scan.sh 2
./leveldb_table_scan.sh 4
./leveldb_table_scan.sh 8

