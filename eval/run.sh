#!/bin/bash

#Evaluation framework for vMigrater research project
#
#
# Weiwei Jia <harryxiyou@gmail.com> 2017

#FIXME: Currently, vMigrater has to be placed under $HOME dir
HOME_PATH=~
VMIGRATER_PATH=$HOME_PATH/vMigrater
APPS_PATH=$VMIGRATER_PATH/apps
#LOG_PATH=/home/hkucs/qemu_output/
OUT_PATH=$VMIGRATER_PATH/results
MICROBENCH_PATH=$APPS_PATH/micro_benchmarks
MACROBENCH_PATH=$APPS_PATH/macro_benchmarks
SCRIPTS=$VMIGRATER_PATH/scripts
TOOLS=$VMIGRATER_PATH/tools

#microbenchmarks
SIO=$MICROBENCH_PATH/sio/run.sh
TIO=$MICROBENCH_PATH/2io/run.sh
FIO=$MICROBENCH_PATH/4io/run.sh
EIO=$MICROBENCH_PATH/8io/run.sh

#macrobenchmarks
MACRO1=$MACROBENCH_PATH/bench1/run.sh
MACRO2=$MACROBENCH_PATH/bench2/run.sh
MACRO3=$MACROBENCH_PATH/bench3/run.sh
MACRO4=$MACROBENCH_PATH/bench4/run.sh
MACRO5=$MACROBENCH_PATH/bench5/run.sh
MACRO6=$MACROBENCH_PATH/bench6/run.sh
MACRO9=$MACROBENCH_PATH/bench9/run.sh
MACRO10=$MACROBENCH_PATH/bench10/run.sh
MACRO11=$MACROBENCH_PATH/bench11/run.sh
MACRO13=$MACROBENCH_PATH/bench13/run.sh


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
    #echo "This is macrobenchmark 1.........................."
	macrobench_dir=$OUT_PATH/macrobench
	if [ ! -d $macrobench_dir ]; then
		mkdir $macrobench_dir
	fi
	bench1_file=$macrobench_dir/bench1
	if [ ! -f $bench1_file ]; then
		touch $bench1_file
	fi
	$MACRO1 $SCRIPTS $bench1_file $TOOLS
}

function macrobench2() {
    #echo "This is macrobenchmark 2.........................."
	macrobench_dir=$OUT_PATH/macrobench
	if [ ! -d $macrobench_dir ]; then
		mkdir $macrobench_dir
	fi
	bench2_file=$macrobench_dir/bench2
	if [ ! -f $bench2_file ]; then
		touch $bench2_file
	fi
	$MACRO2 $SCRIPTS $bench2_file $TOOLS
}

function macrobench3() {
    #echo "This is macrobenchmark 3.........................."
	macrobench_dir=$OUT_PATH/macrobench
	if [ ! -d $macrobench_dir ]; then
		mkdir $macrobench_dir
	fi
	bench3_file=$macrobench_dir/bench3
	if [ ! -f $bench3_file ]; then
		touch $bench3_file
	fi
	$MACRO3 $SCRIPTS $bench3_file $TOOLS
}

function macrobench4() {
    #echo "This is macrobenchmark 4.........................."
	macrobench_dir=$OUT_PATH/macrobench
	if [ ! -d $macrobench_dir ]; then
		mkdir $macrobench_dir
	fi
	bench4_file=$macrobench_dir/bench4
	if [ ! -f $bench4_file ]; then
		touch $bench4_file
	fi
	$MACRO4 $SCRIPTS $bench4_file $TOOLS
}

function macrobench5() {
    #echo "This is macrobenchmark 5.........................."
	macrobench_dir=$OUT_PATH/macrobench
	if [ ! -d $macrobench_dir ]; then
		mkdir $macrobench_dir
	fi
	bench5_file=$macrobench_dir/bench5
	if [ ! -f $bench5_file ]; then
		touch $bench5_file
	fi
	$MACRO5 $SCRIPTS $bench5_file $TOOLS
}

function macrobench6() {
	macrobench_dir=$OUT_PATH/macrobench
	if [ ! -d $macrobench_dir ]; then
		mkdir $macrobench_dir
	fi
	bench6_file=$macrobench_dir/bench6
	if [ ! -f $bench6_file ]; then
		touch $bench6_file
	fi
	$MACRO6 $SCRIPTS $bench6_file $TOOLS
}

function macrobench9() {
	macrobench_dir=$OUT_PATH/macrobench
	if [ ! -d $macrobench_dir ]; then
		mkdir $macrobench_dir
	fi
	bench9_file=$macrobench_dir/bench9
	if [ ! -f $bench9_file ]; then
		touch $bench9_file
	fi
	$MACRO9 $SCRIPTS $bench9_file $TOOLS
}

function macrobench10() {
	macrobench_dir=$OUT_PATH/macrobench
	if [ ! -d $macrobench_dir ]; then
		mkdir $macrobench_dir
	fi
	bench10_file=$macrobench_dir/bench10
	if [ ! -f $bench10_file ]; then
		touch $bench10_file
	fi
	$MACRO10 $SCRIPTS $bench10_file $TOOLS
}

function macrobench11() {
	macrobench_dir=$OUT_PATH/macrobench
	if [ ! -d $macrobench_dir ]; then
		mkdir $macrobench_dir
	fi
	bench11_file=$macrobench_dir/bench11
	if [ ! -f $bench11_file ]; then
		touch $bench11_file
	fi
	$MACRO11 $SCRIPTS $bench11_file $TOOLS
}

function macrobench13() {
	macrobench_dir=$OUT_PATH/macrobench
	if [ ! -d $macrobench_dir ]; then
		mkdir $macrobench_dir
	fi
	bench13_file=$macrobench_dir/bench13
	if [ ! -f $bench13_file ]; then
		touch $bench13_file
	fi
	$MACRO13 $SCRIPTS $bench13_file $TOOLS
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
		macrobench2
	elif [ "$1" == "3" ]; then
		macrobench3
	elif [ "$1" == "4" ]; then
		macrobench4
	elif [ "$1" == "5" ]; then
		macrobench5
	elif [ "$1" == "6" ]; then
		macrobench6
	elif [ "$1" == "7" ]; then
		echo "TBD"
	elif [ "$1" == "8" ]; then
		echo "TBD"
	elif [ "$1" == "9" ]; then
		macrobench9
	elif [ "$1" == "10" ]; then
		macrobench10
	elif [ "$1" == "11" ]; then
		macrobench11
	elif [ "$1" == "12" ]; then
		echo "TBD"
	elif [ "$1" == "13" ]; then
		macrobench13
	else
		usage
	fi
fi
