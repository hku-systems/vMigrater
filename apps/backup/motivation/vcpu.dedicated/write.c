/*
 * io/eval/write.c
 *
 * Weiwei Jia <wj47@njit.edu> (C) 2016
 */
#define _GNU_SOURCE
//#define EXP1_DEBUG

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "debug.h"
//#include <glib.h>
#include <assert.h>
#include <sys/mman.h>

//#define FN		"/home/wwjia/tmp/testA"
#define FN		"/var/testB"
#define CHAR	"B##$$B"
#define SIZE	(1ULL<<33ULL)

int main(int argc, char **argv) {
	int fd = open(FN, O_CREAT | O_RDWR, 00777);
	if (fd < 0) {
		fprintf(stderr, "open or create file error!\n");
		return -1;
	}
	
	uint64_t i = 0;
	uint64_t len = strlen(CHAR);
	while(i <= SIZE) {
		if (len != pwrite(fd, CHAR, len, i)) {
			fprintf(stderr, "This write failed!\n");
			goto out;
		}
		i = i + len;
	}
out:
	close(fd);
	return 0;
}
