/*
 * main_backstage.c
 *
 * Weiwei Jia <wj47@njit.edu> (C) 2016
 *
 * Make every CPU running.
 *
 */
#define _GNU_SOURCE
#define TEST_TIO_MIGRATION
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
#include <sys/shm.h>
#include <sys/ipc.h>

#define SLEEP_TIME		(300UL)
//#define DIFF_USEC		(750UL)
#define DIFF_USEC		(3000UL)
#define DEVIATION		(55UL)
#define SIZE			(1<<20)

#define F_SIZE			(1ULL<<33ULL)
#define EACH_SIZE		(1ULL<<12ULL)

#define handle_error_en(en, msg) \
	do { errno = en; perror(msg); exit(EXIT_FAILURE); } while (0)

#define handle_error(msg) \
	do { perror(msg); exit(EXIT_FAILURE); } while (0)

struct buf {
	uint64_t vcpu_num;
	uint64_t start;
	uint64_t end;
	uint64_t diff;
};

struct lt {
	int64_t left_time1;
	int64_t left_time2;
	int64_t left_time3;
	int64_t left_time4;
};

struct ts {
	uint64_t vn;
	uint64_t flag;
	uint64_t time;
	uint64_t counter;
	int64_t lt;
	uint64_t ct;
	//struct lt lt;
};

struct vcpu {
	uint64_t vcpu_num;
	uint64_t counter;
	uint64_t start_time;
	uint64_t end_time;
	uint64_t timeslice;
	int64_t left_time;
	uint64_t io_counter;
	uint64_t deschedule_ts;
	uint64_t dead_ts;
	
#if defined MY_DEBUG_CPU_
	int cpu_fd;
	uint64_t buf_counter;
	uint64_t buf_len;
	char *buf;
#endif
};

struct _vcpu {
	int64_t plus_one;
	uint64_t vcpu_num;
};

struct tio {
	int fd;
};

struct worker_job {
	int flag;

	int fd;
	uint64_t offset;
	uint64_t len;
	char buf[EACH_SIZE];
};

struct register_task {
	pthread_t tid;
	pid_t pid;

	int fd;
	uint64_t flag;
	char proc_path[1024];
};

struct shared_mem {
	int pid;
	int counter;
	int flag;
};

//FIXME: fix hardcoded
static int start_vcpu = 1;
static int end_vcpu = 0;

static struct vcpu *vcpu;
static struct _vcpu *_vcpu;
static uint64_t _vcpu_num;
static uint64_t __vcpu_num;
static pthread_t *p;
static pthread_t *_p;
static pthread_t *worker;
static uint64_t *worker_vcpu;
struct worker_job wj;
static struct tio tio;
static pthread_t pio;
static struct register_task rt;
static uint64_t cpu_sleep_counter = 0;

uint64_t counter_affi = 0;
uint64_t cost[10];
uint64_t start_affi = 0;
uint64_t diff_affi = 0;

pthread_cond_t worker_cond  = PTHREAD_COND_INITIALIZER;
pthread_cond_t main_cond  = PTHREAD_COND_INITIALIZER;
pthread_mutex_t worker_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t main_mutex = PTHREAD_MUTEX_INITIALIZER;

void sig_handler(int signo) {
	if (signo == SIGINT) {
		if (p != NULL)
			free(p);
		if(vcpu != NULL)
			free(vcpu);
		close(tio.fd);
	} else
		handle_error("Signal Error!\n");

		exit(EXIT_SUCCESS);
}

int get_vcpu_count(void) {
	return get_nprocs();
}

uint64_t get_pid_affinity(int pid) {
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);

	int s = sched_getaffinity(pid, sizeof(cpu_set_t), &cpuset);
	if (s != 0) return -1;
	uint64_t j = 0;
	uint64_t _j = 0;
	for (j = 0; j < CPU_SETSIZE; j++)
		if (CPU_ISSET(j, &cpuset)) {
			_j = j;
		}
	return _j;
}


uint64_t get_affinity(void) {
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);

	int s = pthread_getaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset);
	if (s != 0) return -1;
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
	if (s != 0) return -1;
	uint64_t j = 0;
	uint64_t _j = 0;
	for (j = 0; j < CPU_SETSIZE; j++)
		if (CPU_ISSET(j, &cpuset)) {
			_j = j;
		}
	return _j;
}

void set_pid_affinity(uint64_t vcpu_num, int pid) {
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);
	CPU_SET(vcpu_num, &cpuset);

	if (sched_setaffinity(pid, sizeof(cpu_set_t), &cpuset) < 0) {
		fprintf(stderr, "Set thread to VCPU error!\n");
	}
}


void set_affinity(uint64_t vcpu_num) {
	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);
	CPU_SET(vcpu_num, &cpuset);

	if (pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset) < 0) {
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

void set_idle_priority(void) {
	struct sched_param param;
	param.sched_priority = 0;
	int s = pthread_setschedparam(pthread_self(), SCHED_IDLE, &param);
	if (s != 0) handle_error("Pthread_setschedparam error!\n");
}

void set_nice_priority(int priority, int pid) {
	int which = PRIO_PROCESS;

	int ret = setpriority(which, pid, priority);
}

void *_thread_func(void *arg) {
	uint64_t vn = *((uint64_t *) arg);
	set_affinity(11);

	vn = get_affinity();
	printf("CPU daemon worker is on %lu\n", vn);
	int pid = syscall(SYS_gettid);
	printf("CPU daemon worker thread PID number is %d\n", pid);
	set_idle_priority();
	set_nice_priority(20, pid);

	while(1) {
		_vcpu[vn].plus_one += 1;
	}
}

void init_probe_thread(void) {
	int ret = 0;
	uint64_t i;

	_p = (pthread_t *) malloc(sizeof(pthread_t) * __vcpu_num);
	if (_p == NULL)
		handle_error("malloc error!");
	_vcpu = (struct _vcpu *) malloc(sizeof(struct _vcpu) * __vcpu_num);
	if (_vcpu == NULL)
		handle_error("malloc error!");

	for (i = start_vcpu - 1; i < end_vcpu + 1; i++) {
	//XXX vCPU 0 is dedicated to handle all the interrupts
		_vcpu[i].vcpu_num = i;
		_vcpu[i].plus_one = 0;
		ret = pthread_create(&(_p[i]), NULL, _thread_func, &(_vcpu[i].vcpu_num));
		if (ret != 0) {
			printf("Pthread create error!\n");
			exit(EXIT_SUCCESS);
		}
		//FIXME: make each thread running on its appointed VCPU
		sleep(2);
	}
}

int main(int argc, char **argv) {
	pid_t pid = getpid();
	uint64_t vcpu_num = get_vcpu_count();
	__vcpu_num = vcpu_num;
	_vcpu_num = vcpu_num;
	int i = 0;

	printf("vCPU number is %lu\n", _vcpu_num);
	printf("Process ID number is %d\n", pid);

	init_probe_thread();


	for (i = start_vcpu - 1; i < end_vcpu + 1; i++) {
		pthread_join(_p[i], NULL);
	}

	return 0;
}
