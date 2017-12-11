/*
 * io/eval/cpu.c
 *
 * CPU intensive workload
 *
 * Weiwei Jia <wj47@njit.edu> (C) 2016
 */
#define _GNU_SOURCE
//#define FLUSH_DEBUG

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "debug.h"
#include <assert.h>
#include <sys/sysinfo.h>


int main(int argc, char **argv) {
	int64_t i = 0;

	uint64_t start = debug_time_monotonic_usec();
	while (i != 10000000000) {
		i = i + 1;
	}
	uint64_t diff = debug_time_monotonic_usec() - start;

	printf("thinktime is %lu\n", diff);
	
	return 0;
}
