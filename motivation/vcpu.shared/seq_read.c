#define _GNU_SOURCE
#define MY_DEBUG_CPU_
#include <sys/signalfd.h>
#include <signal.h>
#include <errno.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <sys/types.h>
#include <sched.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "debug.h"
#include "glib-2.0/glib.h"
#include <pthread.h>
#include <assert.h>
#include <sys/mman.h>
#include <sys/sysinfo.h>
#include <sys/time.h>
#include <sys/stat.h>
#include <sys/resource.h>
#include <sys/syscall.h>
#include <sys/mman.h>
#include <semaphore.h>
#include <signal.h>
#include <sys/ipc.h> 
#include <sys/shm.h>

#define FNA				"/home/kvm1/sda2/testA"
#define FNB				"/home/kvm1/sda3/testB"
#define EACH_SIZE		(1ULL<<12ULL)
#define F_SIZE			(1ULL<<33ULL)

#define handle_error_en(en, msg) \
	do { errno = en; perror(msg); exit(EXIT_FAILURE); } while (0)

#define handle_error(msg) \
	do { perror(msg); exit(EXIT_FAILURE); } while (0)

struct io_job {
	int flag;
	int fd;
	uint64_t offset;
	uint64_t len;
	char buf[EACH_SIZE];
};

struct io_job ij;
int pid;

int get_vcpu_count(void) {
	return get_nprocs();
}

uint64_t get_affinity(void) {
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);

	int s = pthread_getaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset);
	if (s != 0) handle_error_en(s, "pthread_getaffinity_np");
	uint64_t j = 0;
	uint64_t _j = 0;
	for (j = 0; j < CPU_SETSIZE; j++)
		if (CPU_ISSET(j, &cpuset)) {
			_j = j;
		}
	return _j;
}

uint64_t get_pid_affinity(int pid) {
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);

	int s = sched_getaffinity(pid, sizeof(cpu_set_t), &cpuset);
	if (s != 0) handle_error_en(s, "pthread_getaffinity_np");
	uint64_t j = 0;
	uint64_t _j = 0;
	for (j = 0; j < CPU_SETSIZE; j++)
		if (CPU_ISSET(j, &cpuset)) {
			_j = j;
		}
	return _j;
}

uint64_t get_affinity_out(pthread_t tid) {
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);

	int s = pthread_getaffinity_np(tid, sizeof(cpu_set_t), &cpuset);
	if (s != 0) handle_error_en(s, "pthread_getaffinity_np");
	uint64_t j = 0;
	uint64_t _j = 0;
	for (j = 0; j < CPU_SETSIZE; j++)
		if (CPU_ISSET(j, &cpuset)) {
			_j = j;
		}
	return _j;
}

void set_affinity(uint64_t vcpu_num) {
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);
	CPU_SET(vcpu_num, &cpuset);

	if (pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset) < 0) {
		fprintf(stderr, "Set thread to VCPU error!\n");
	}
}

void set_pid_affinity(uint64_t vcpu_num, int pid) {
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);
	CPU_SET(vcpu_num, &cpuset);

	if (sched_setaffinity(pid, sizeof(cpu_set_t), &cpuset) < 0) {
		fprintf(stderr, "Set thread to VCPU error!\n");
	}
}

void set_affinity_out(uint64_t vcpu_num, pthread_t tid) {
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);
	CPU_SET(vcpu_num, &cpuset);

	if (pthread_setaffinity_np(tid, sizeof(cpu_set_t), &cpuset) < 0) {
		fprintf(stderr, "Set thread to VCPU error!\n");
	}
}

void set_priority(void) {
	struct sched_param param;
	int priority = sched_get_priority_max(SCHED_RR);
	param.sched_priority = priority;
	int s = pthread_setschedparam(pthread_self(), SCHED_RR, &param);
	if (s != 0) handle_error("Pthread_setschedparam error!\n");
}

void set_nice_priority(int priority, int pid) {
	int which = PRIO_PROCESS;
	int ret = setpriority(which, pid, priority);
}  

void do_iofunc(void) {
	char buf[EACH_SIZE + 1];
	uint64_t i = 0;
	uint64_t j = 0;
	uint64_t start;
	uint64_t start1;
	uint64_t diff;
	uint64_t diff1;
	uint64_t len = 0;
	uint64_t io_vn = 0;
	uint64_t _io_vn = 0;
	uint64_t vn;
	uint64_t counter = 0;
	uint64_t flag = 0;
	uint64_t s;


	uint64_t _start;
	uint64_t _diff;
	int64_t think_time = 0;
	//_pid = syscall(SYS_gettid);

	//set_nice_priority(-20, pid);
	printf("I/O process ID number is %d\n", pid);

	//XXX Must set since the I/O thread would be pinned to that vCPU.
	//j = 0;
	//set_priority();
	set_pid_affinity(5, pid);
	j = 2;
	io_vn = 0;
	uint64_t _i = 0;

	memset(buf, '\0', EACH_SIZE + 1);
	io_vn = get_pid_affinity(pid);
	printf("I/O thread on VCPU %lu\n", io_vn);
	vn = io_vn;
	//start = debug_time_monotonic_usec();
	start = debug_time_usec();
	while (i < (uint64_t) F_SIZE) {
		if (EACH_SIZE != (ij.len = pread(ij.fd, buf, EACH_SIZE, i))) {
			fprintf(stderr, "This read, %lu,  failed!\n", (uint64_t) EACH_SIZE);
			exit(EXIT_SUCCESS);
		}

#if 0
		while (think_time != 4000) {
			think_time += 1;
		}
		think_time = 0;
#endif
		i = i + (uint64_t) EACH_SIZE;
		memset(buf, '\0', EACH_SIZE + 1);
	}
	diff = debug_time_usec() - start;
	printf("Sequential reading %lf GB needs %lu microseconds.\n", ((double) F_SIZE / (double) (1024.0 * 1024.0 * 1024.0)), diff);
//	printf("With migration, I/O throughput is %lf MB/s.\n", ((double) F_SIZE / (double) (1024.0 * 1024.0) )  / ((double) diff / (double) 1000000.0));
	printf("Sequential read %lf GB, I/O throughput is %lf MB/s.\n", ((double) F_SIZE / (double) (1024.0 * 1024.0 * 1024.0)), (((double) F_SIZE / (double) (1024.0 * 1024.0))  / ((double) diff / (double) 1000000.0)));
}

void init_io_process(void) {
	int ret = 0;

	ij.flag = 0;
	ij.len = 0;
	ij.offset = 0;
	memset(ij.buf, '\0', EACH_SIZE);
	ij.fd = open(FNA, O_RDONLY, 00777);
	if (ij.fd < 0) {
		printf("Open file error!\n");
		exit(EXIT_SUCCESS);
	}

	do_iofunc();

	return;
}

int main(int argc, char **argv) {
	pid = getpid();
	uint64_t vcpu_num = get_vcpu_count();
	int i = 0;

	printf("CPU number is %lu\n", vcpu_num);
	printf("Process ID number is %d\n", pid);
	init_io_process();

	return 0;
}
