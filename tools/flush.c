/*
 * hotstorage/2016310/eval/flush.c
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

#define PAGE_SIZE (4096UL)
#define MEM_SIZE (80UL * 1024UL * 1024UL * 1024UL)
#define _COUNT (0x0000000000400000)

int main(int argc, char **argv) {
	uint64_t i = 0;
	struct sysinfo _sysinfo;

	
	int ret = sysinfo(&_sysinfo);
	if (ret != 0) {
		fprintf(stderr, "Get system memory size error!\n");
		return -1;
	}
	unsigned long mem_size = _sysinfo.totalram;
	unsigned long count = mem_size / PAGE_SIZE;
	printf("memsize is %lu\ncount is %lu\n", mem_size, count);
#if 1
	char **p;
	p = (char **) malloc(sizeof(uint64_t) * count);
	assert(p != NULL);

#if 1
	for (i = 0; i < count; i++) {
#ifdef FLUSH_DEBUG
	    printf("count is %ld\n", count);
		printf("i is %ld\n", i);
#endif
		p[i] = (char *) malloc(sizeof(char) * PAGE_SIZE);
		assert(p[i] != NULL);
		p[i][PAGE_SIZE - 1] = 'A';
	}
	for (i = 0; i < count; i++) {
		if (p[i] != NULL) free(p[i]);
	}
	if (p != NULL) free(p);
#endif
#endif
	return 0;
}
