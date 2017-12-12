/*
 * sol/sol1.c
 *
 * Weiwei Jia <wj47@njit.edu> (C) 2016
 *
 * Solution 1 implementation for I/O project.
 *
 * TODO: Find why detected time slice is bigger than (shced_latecy_ns /
 * vCPU_num).
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
#include "../debug.h"
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

#define SLEEP_TIME		(300UL)
//#define DIFF_USEC		(750UL)
#define DIFF_USEC		(3000UL)
#define DEVIATION		(55UL)
#define SIZE			(1<<20)

#define IO_DEBUG		"D_IO"
#define CPU_DEBUG0		"D_CPU_0"
#define CPU_DEBUG1		"D_CPU_1"
#define CPU_DEBUG2		"D_CPU_2"
#define CPU_DEBUG3		"D_CPU_3"
#define CPU_DEBUG4		"D_CPU_4"
#define FNA				"/home/kvm1/sda2/testA"
#define FNB				"/home/kvm1/sda3/testB"
//#define F_SIZE			(1ULL<<30ULL)
#define F_SIZE			(1ULL<<27ULL)
#define EACH_SIZE		(1ULL<<12ULL)
#define MAX_NUM_IO		(1000ULL)

#define NUM_IO_THREADS		(8ULL)

#define handle_error_en(en, msg) \
	do { errno = en; perror(msg); exit(EXIT_FAILURE); } while (0)

#define handle_error(msg) \
	do { perror(msg); exit(EXIT_FAILURE); } while (0)

uint64_t start_vcpu = 2ULL;
uint64_t end_vcpu = 11ULL;
int fd1;
int fd2;

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
	int num;

	uint64_t vcpu;
	int fd;
	uint64_t offset;
	uint64_t len;
	//char buf[EACH_SIZE];
};

struct register_task {
	pthread_t tid;
	pid_t pid;

	int fd;
	uint64_t flag;
	char proc_path[1024];
};

struct io {
	uint64_t pid;
	uint64_t is_movable;
	uint64_t is_finished;
	uint64_t index;

	int64_t prev_left_time;
	int64_t curr_left_time;
	uint64_t prev_ts;
};

struct shared_mem {
	int counter;
	int cpu_flag;
	int flag;
	uint64_t total_bytes;
	struct io io_thread[MAX_NUM_IO];
};

static struct vcpu *vcpu;
static struct _vcpu *_vcpu;
static uint64_t _vcpu_num;
static uint64_t __vcpu_num;
static pthread_t *p;
static pthread_t *_p;
static pthread_t *worker;
static uint64_t *worker_vcpu;
struct worker_job *wj;
static struct tio tio;
static pthread_t pio;
static struct register_task rt;
static uint64_t cpu_sleep_counter = 0;

key_t key = 99996;                                                      
int shmid;                                                              
char *shm;                                                              
struct shared_mem *sm;
//pid_t pid;

sem_t sem_main;
sem_t sem_worker;

pthread_cond_t worker_cond  = PTHREAD_COND_INITIALIZER;
pthread_cond_t main_cond  = PTHREAD_COND_INITIALIZER;
pthread_mutex_t worker_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t main_mutex = PTHREAD_MUTEX_INITIALIZER;

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

void *do_iofunc(void *arg) {
	struct worker_job *_wj = (struct worker_job *) arg;
	char buf[EACH_SIZE + 1];
	uint64_t i = 0;
	if (_wj->num == 0) {
		i = 0;
	} else if (_wj->num == 1) {
		i = F_SIZE;
	} else if (_wj->num == 2) {
		i = F_SIZE * 2;
	} else if (_wj->num == 3) {
		i = F_SIZE * 3;
	} else if (_wj->num == 4) {
		i = F_SIZE * 4;
	} else if (_wj->num == 5) {
		i = F_SIZE * 5;
	} else if (_wj->num == 6) {
		i = F_SIZE * 6;
	} else if (_wj->num == 7) {
		i = F_SIZE * 7;
	}
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
	struct ts ts;
	uint64_t flag = 0;
	uint64_t bursty = 0;
	uint64_t s;
	int pid;


	uint64_t _start;
	uint64_t _diff;
	int64_t think_time = 0;
	uint64_t index;
	pid = syscall(SYS_gettid);

	//set_nice_priority(-20, rt.pid);
	printf("I/O process ID number is %d\n", pid);
	pthread_mutex_lock(&worker_mutex);
	index = sm->counter;
	(sm->io_thread[index]).pid = pid;
	(sm->io_thread[index]).is_finished = 0;
	printf("index is %lu, pid is %lu, counter is %d, flag is %d\n",
			index, (sm->io_thread[sm->counter]).pid, sm->counter, sm->flag);
	sm->counter += 1;
	pthread_mutex_unlock(&worker_mutex);

	//XXX Must set since the I/O thread would be pinned to that vCPU.
	//j = 0;
	//set_priority();
	set_pid_affinity(_wj->vcpu, pid);
	j = 2;
	io_vn = 0;
	uint64_t _i = 0;
	int change = 0;

	memset(buf, '\0', EACH_SIZE + 1);
	io_vn = get_pid_affinity(pid);
	printf("I/O thread %d on vCPU %lu\n", _wj->num, io_vn);
	vn = io_vn;
	uint64_t mcounter = 0;
	uint64_t _mcounter = 0;
	start = debug_time_monotonic_usec();
	//i = F_SIZE - EACH_SIZE;
	while (_i != F_SIZE) {
	//while (i > 0) {
		//_start = debug_time_monotonic_usec();
		//set_affinity(j);
		//j = j + 1;
		//if (j == 11) j = 2;
		if (change == 0) {
			if (EACH_SIZE != (_wj->len = pread(fd1, buf, EACH_SIZE, i))) {
				fprintf(stderr, "This read, %lu,  failed!\n", (uint64_t) EACH_SIZE);
				exit(EXIT_SUCCESS);
			}
			change = 1;
		} else {
			if (EACH_SIZE != (_wj->len = pread(fd2, buf, EACH_SIZE, i))) {
				fprintf(stderr, "This read, %lu,  failed!\n", (uint64_t) EACH_SIZE);
				exit(EXIT_SUCCESS);
			}
			change = 0;
		}

		//_diff = debug_time_monotonic_usec() - _start;
		//printf("_diff is %lu\n", _diff);

		//if (_diff > 1000) {
		//	counter += _diff;
		//}

#if 1
		pthread_mutex_lock(&worker_mutex);
		sm->total_bytes += EACH_SIZE;
		pthread_mutex_unlock(&worker_mutex);

		if (bursty == 100 * EACH_SIZE) {
			while (think_time != 8000000) {
				think_time += 1;
			}
			think_time = 0;
			bursty = 0;
		}
#endif

		//i = i - EACH_SIZE;
		i = i + EACH_SIZE;
		_i = _i + EACH_SIZE;
		bursty += EACH_SIZE;
		memset(buf, '\0', EACH_SIZE + 1);
	}
	diff = debug_time_monotonic_usec() - start;
	pthread_mutex_lock(&worker_mutex);
	(sm->io_thread[index]).is_finished = 1;
	sm->counter -= 1;
	pthread_mutex_unlock(&worker_mutex);
	printf("diff is %lu\n", diff);
	printf("counter is %lu\n", counter);
	printf("mcounter is %lu, _mounter is %lu\n", mcounter, _mcounter);
	printf("cpu_sleep_counter is %lu\n", cpu_sleep_counter);
#if defined TEST_TIO_MIGRATION
	printf("With migration, I/O throughput is %lf MB/s.\n", ((double) F_SIZE / (double) (1024.0 * 1024.0) )  / ((double) diff / (double) 1000000.0));
#else
	printf("Without migration, I/O throughput is %lf MB/s.\n", ((double) F_SIZE / (double) (1024.0 * 1024.0) )  / ((double) diff / (double) 1000000.0));
#endif
}

void init_io_thread(void) {
	int ret = 0;
	uint64_t i = 0;

	fd1 = open(FNA, O_RDONLY, 00777);
	if (fd1 < 0) handle_error("Open fileA error!\n");
	fd2 = open(FNB, O_RDONLY, 00777);
	if (fd2 < 0) handle_error("Open fileB error!\n");
	wj = (struct worker_job *) malloc(sizeof(struct worker_job) * NUM_IO_THREADS);
	if (wj == NULL) handle_error("Malloc error!\n");

	p = (pthread_t *) malloc(sizeof(pthread_t) * NUM_IO_THREADS);
	if (p == NULL) handle_error("malloc error!");
	for (i = 0; i < NUM_IO_THREADS; i++) {
		wj[i].vcpu = start_vcpu + i;
		wj[i].len = 0;
		wj[i].offset = 0;
		wj[i].num = i;

#if 0
		if ((i % 2) == 0) {
			printf("Open file A ...\n");
			wj[i].fd = fd1;
		} else {
			printf("Open file B ...\n");
			wj[i].fd = fd2;
		}
#endif
		ret = pthread_create(&(p[i]), NULL, do_iofunc, &(wj[i]));
		if (ret != 0) handle_error("pthread create error!\n");
	}
}

void init_shared_mem(void) {
	if ((shmid = shmget(key, sizeof(struct shared_mem), 0666)) < 0) {
		handle_error("shmget error!\n");
	}

	if ((shm = shmat(shmid, NULL, 0)) == (void *) -1) {
		handle_error("shmget error!\n");
	}

	sm = (struct shared_mem *) shm;

	sm->flag = 1;
}

int main(int argc, char **argv) {
	//pid = getpid();
	uint64_t vcpu_num = get_vcpu_count();
	__vcpu_num = vcpu_num;
	vcpu_num = 4;
	_vcpu_num = vcpu_num;
	uint64_t i = 0;

	printf("vCPU number is %lu\n", _vcpu_num);
//	printf("Process ID number is %d\n", pid);
	init_shared_mem();
	init_io_thread();


	for (i = 0; i < NUM_IO_THREADS; i++) {
		pthread_join(p[i], NULL);
	}
	if(shmdt(shm) == -1) {
		handle_error("Share memory detach error!\n");
	}
	return 0;
}
