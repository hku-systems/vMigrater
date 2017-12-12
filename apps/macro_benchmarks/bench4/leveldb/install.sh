#!/bin/bash

wget https://github.com/google/leveldb/archive/v1.20.tar.gz
tar xvf v1.20.tar.gz
cd leveldb-1.20
sudo apt-get install libsnappy-dev
make
