#!/bin/bash
HOME_PATH=~
VMIGRATER_PATH=$HOME_PATH/vMigrater
APPS_PATH=$VMIGRATER_PATH/apps
#LOG_PATH=/home/hkucs/qemu_output/
OUT_PATH=$VMIGRATER/results
MICROBENCH_PATH=$APPS_PATH/micro_benchmarks
SCRIPTS=$VMIGRATER_PATH/scripts

#microbenchmarks
SIO=$MICROBENCH_PATH/sio/run.sh

usage() {
    echo "usage:"
	echo -e "\trun.sh 0 or 1 or 2 or 3..."
	echo -e "\t0: microbenchmarks"
	echo -e "\t1: macrobenchmark 1"
	echo -e "\t2: macrobenchmark 1"
	echo -e "\t3: macrobenchmark 1"
	echo -e "\t4: macrobenchmark 1"
	echo -e "\t5: macrobenchmark 1"
	echo -e "\t6: macrobenchmark 1"
	echo -e "\t7: macrobenchmark 1"
	echo -e "\t8: macrobenchmark 1"
	echo -e "\t9: macrobenchmark 1"
	echo -e "\t10: macrobenchmark 1"
	echo -e "\t11: macrobenchmark 1"
	echo -e "\t12: macrobenchmark 1"
}

microbench() {
	echo "This is Microbenchmarks........................."
	microbench_dir=$OUT_PATH/microbench
	if [ ! -d $microbench_dir ]; then
		mkdir $microbench_dir
	fi
	sio_file=$microbench_dir/sio
	if [ ! -f $sio_file ]; then
		touch $sio_file
	fi
	$SIO $BIN_DIR $SCRIPTS $sio_file

}

# check whether results dir exists
if [ ! -d $OUT_PATH ]; then
	mkdir $OUT_PATH
fi

if [ $# -eq 0 ]; then
	usage
else
	if [ "$1" == "0" ]; then
		microbench
	elif [ "$1" == "1" ]; then
		echo
	elif [ "$1" == "2" ]; then
		echo
	elif [ "$1" == "3" ]; then
		echo
	elif [ "$1" == "4" ]; then
		echo
	elif [ "$1" == "5" ]; then
		echo
	elif [ "$1" == "6" ]; then
		echo
	elif [ "$1" == "7" ]; then
		echo
	elif [ "$1" == "8" ]; then
		echo
	elif [ "$1" == "9" ]; then
		echo
	elif [ "$1" == "10" ]; then
		echo
	elif [ "$1" == "11" ]; then
		echo
	elif [ "$1" == "12" ]; then
		echo
	else
		echo
	fi
fi
