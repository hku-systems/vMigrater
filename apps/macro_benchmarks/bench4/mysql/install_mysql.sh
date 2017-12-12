#!/bin/bash

sudo apt-get install mysql-server
sudo apt-get install mysql-client

mysql -u root -p

#CREATE DATABASE sbtest;
#CREATE USER 'sbtest'@'localhost';
#GRANT ALL PRIVILEGES ON * . * TO 'sbtest'@'localhost';
#FLUSH PRIVILEGES;
#quit;



#XXX: reference, https://serverfault.com/questions/666159/sysbench-mysql-cannot-connect
