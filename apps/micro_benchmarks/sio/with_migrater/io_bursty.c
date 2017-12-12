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
#define F_SIZE			(1ULL<<30ULL)
//#define F_SIZE			(1ULL<<27ULL)
#define EACH_SIZE		(1ULL<<12ULL)
#define MAX_NUM_IO		(10ULL)

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
struct worker_job wj;
static struct tio tio;
static pthread_t pio;
static struct register_task rt;
static uint64_t cpu_sleep_counter = 0;

key_t key = 99996;                                                      
int shmid;                                                              
char *shm;                                                              
struct shared_mem *sm;
pid_t pid;

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
	int64_t counter = 0;
	struct ts ts;
	uint64_t flag = 0;
	uint64_t s;


	uint64_t _start;
	uint64_t _diff;
	int64_t think_time = 0;
	//rt.pid = syscall(SYS_gettid);

	//set_nice_priority(-20, rt.pid);
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
	printf("I/O thread on vCPU %lu\n", io_vn);
	vn = io_vn;
	uint64_t mcounter = 0;
	uint64_t _mcounter = 0;
	start = debug_time_monotonic_usec();
	uint64_t bursty = 0;
	//i = F_SIZE - EACH_SIZE;
	while (i != F_SIZE) {
	//while (i > 0) {
		//_start = debug_time_monotonic_usec();
		//set_affinity(j);
		//j = j + 1;
		//if (j == 11) j = 2;
		if (EACH_SIZE != (wj.len = pread(wj.fd, buf, EACH_SIZE, i))) {
			fprintf(stderr, "This read, %lu,  failed!\n", (uint64_t) EACH_SIZE);
			exit(EXIT_SUCCESS);
		}

		//_diff = debug_time_monotonic_usec() - _start;
		//printf("_diff is %lu\n", _diff);

		//if (_diff > 1000) {
		//	counter += _diff;
		//}

#if 1
		sm->total_bytes += EACH_SIZE;

		//if (sm->cpu_flag == 1) {
		if (bursty == 100 * EACH_SIZE) {
			while (think_time != 8000000) {
				think_time += 1;
			}
			think_time = 0;
			bursty = 0;
		}
			//counter += 4000;
		//}
		//if ((sm->cpu_flag == 2) && (flag == 0)) {
		//	printf("I/O thread counter is %ld\n", counter);
		//	flag = 1;
		//}
#endif

		//i = i - EACH_SIZE;
		i = i + EACH_SIZE;
		bursty += EACH_SIZE;
		memset(buf, '\0', EACH_SIZE + 1);
	}
	diff = debug_time_monotonic_usec() - start;
	printf("diff is %lu\n", diff);
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

	wj.flag = 0;
	wj.len = 0;
	wj.offset = 0;
	memset(wj.buf, '\0', EACH_SIZE);
	wj.fd = open(FNA, O_RDONLY, 00777);
	if (wj.fd < 0) {
		printf("Open file error!\n");
		exit(EXIT_SUCCESS);
	}

	do_iofunc();
}

void init_shared_mem(void) {
	if ((shmid = shmget(key, sizeof(struct shared_mem), 0666)) < 0) {
		handle_error("shmget error!\n");
	}

	if ((shm = shmat(shmid, NULL, 0)) == (void *) -1) {
		handle_error("shmget error!\n");
	}

	sm = (struct shared_mem *) shm;

	(sm->io_thread[sm->counter]).index = sm->counter;
	(sm->io_thread[sm->counter]).pid = pid;
	sm->flag = 1;
	printf("index is %lu, pid is %lu, counter is %d, flag is %d\n",
			(sm->io_thread[sm->counter]).index,
			(sm->io_thread[sm->counter]).pid,
			sm->counter, sm->flag);
	sm->counter += 1;
}

int main(int argc, char **argv) {
	pid = getpid();
	uint64_t vcpu_num = get_vcpu_count();
	__vcpu_num = vcpu_num;
	vcpu_num = 4;
	_vcpu_num = vcpu_num;
	int i = 0;

	printf("vCPU number is %lu\n", _vcpu_num);
	printf("Process ID number is %d\n", pid);
	init_shared_mem();
	init_io_thread();

	(sm->io_thread[(sm->io_thread[sm->counter]).index]).is_finished = 1;
	sm->counter -= 1;
	if(shmdt(shm) == -1) {
		handle_error("Share memory detach error!\n");
	}

	//pthread_join(pio, NULL);

	return 0;
}
