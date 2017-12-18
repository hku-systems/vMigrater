#!/bin/bash
#FIXME: Currently, vMigrater has to be placed under $HOME dir
HOME_PATH=~
VMIGRATER_PATH=$HOME_PATH/vMigrater
APPS_PATH=$VMIGRATER_PATH/apps
#LOG_PATH=/home/hkucs/qemu_output/
OUT_PATH=$VMIGRATER_PATH/results
MICROBENCH_PATH=$APPS_PATH/micro_benchmarks
MACROBENCH_PATH=$APPS_PATH/macro_benchmarks
SCRIPTS=$VMIGRATER_PATH/scripts

#microbenchmarks
SIO=$MICROBENCH_PATH/sio/run.sh
TIO=$MICROBENCH_PATH/2io/run.sh
FIO=$MICROBENCH_PATH/4io/run.sh
EIO=$MICROBENCH_PATH/8io/run.sh

#macrobenchmarks
MACRO1=$MACROBENCH_PATH/bench1/run.sh


function usage() {
    echo "usage:"
	echo -e "\trun.sh 0 or 1 or 2 or 3..."
	echo -e "\t0: microbenchmarks"
	echo -e "\t1: macrobenchmark 1"
	echo -e "\t2: macrobenchmark 2"
	echo -e "\t3: macrobenchmark 3"
	echo -e "\t4: macrobenchmark 4"
	echo -e "\t5: macrobenchmark 5"
	echo -e "\t6: macrobenchmark 6"
	echo -e "\t7: macrobenchmark 7"
	echo -e "\t8: macrobenchmark 8"
	echo -e "\t9: macrobenchmark 9"
	echo -e "\t10: macrobenchmark 10"
	echo -e "\t11: macrobenchmark 11"
	echo -e "\t12: macrobenchmark 12"
}

function init_test() {
    echo "Home path: $HOME_PATH"
	if [ ! -d $VMIGRATER_PATH ]; then
		echo "please download and place vMigrater "
	fi
	echo "vMigrater path: $VMIGRATER_PATH"
	echo "Evaluation results path: $OUT_PATH"
	echo "Microbenchmarks path: $MICROBENCH_PATH"
	echo "vMigrater scripts path: $SCRIPTS"
}

function microbench() {
	echo "This is Microbenchmarks........................."
	microbench_dir=$OUT_PATH/microbench
	if [ ! -d $microbench_dir ]; then
		mkdir $microbench_dir
	fi
	sio_file=$microbench_dir/sio
	if [ ! -f $sio_file ]; then
		touch $sio_file
	fi
	$SIO $SCRIPTS $sio_file
	tio_file=$microbench_dir/2io
	if [ ! -f $tio_file ]; then
		touch $tio_file
	fi
	$TIO $SCRIPTS $tio_file
	fio_file=$microbench_dir/4io
	if [ ! -f $fio_file ]; then
		touch $fio_file
	fi
	$FIO $SCRIPTS $fio_file
	eio_file=$microbench_dir/8io
	if [ ! -f $eio_file ]; then
		touch $eio_file
	fi
	$EIO $SCRIPTS $eio_file
}

function macrobench1() {
    echo "This is macrobenchmark 1.........................."
	macrobench_dir=$OUT_PATH/macrobench
	if [ ! -d $macrobench_dir ]; then
		mkdir $macrobench_dir
	fi
	bench1_file=$macrobench_dir/bench1
	if [ ! -f $bench1_file ]; then
		touch $bench1_file
	fi
	$MACRO1 $SCRIPTS $bench1_file
}

#init and check all pre-settings for vMigrater evaluation framework
init_test

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
		macrobench1
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
