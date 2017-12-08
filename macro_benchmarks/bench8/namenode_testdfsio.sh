#!/bin/bash

#for our specific testing, setting and system environment, we have to copy
#this file to /usr/local/hadoop directory and run this script.
#XXX: we also have to run this script with hduser account

./bin/hadoop jar hadoop-test-1.2.1.jar TestDFSIO -read -fileSize 16000

