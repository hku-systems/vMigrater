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

#define IO_DEBUG		"D_IO"
#define CPU_DEBUG0		"D_CPU_0"
#define CPU_DEBUG1		"D_CPU_1"
#define CPU_DEBUG2		"D_CPU_2"
#define CPU_DEBUG3		"D_CPU_3"
#define CPU_DEBUG4		"D_CPU_4"
#define FNA				"/home/kvm1/sda2/testA"
#define FNB				"/home/kvm1/sda3/testB"
//#define F_SIZE			(1ULL<<27ULL)
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

//TODO: fix hardcoded
static int start_vcpu = 2;
static int end_vcpu = 11;

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

uint64_t prev_ts = 0;
int64_t prev_left_time = 0;
int64_t curr_left_time = 0;

key_t key = 99999;
int shmid;
char *shm;
struct shared_mem *sm;

uint64_t counter_affi = 0;
uint64_t cost[10];
uint64_t start_affi = 0;
uint64_t diff_affi = 0;

sem_t sem_main;
sem_t sem_worker;

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

#if defined MY_DEBUG_CPU_
// 0 - timeslice thread
// 1 - I/O thread
// 2 - I/O thread is migrated to the vCPU
// 3 - I/O thread is migrated away from the vCPU
void CPU_WRITE(uint64_t vn) {
	uint64_t i;
	uint64_t j;
	char *buf;
	uint64_t src_len = 0;
	uint64_t dst_len = 0;
	struct ts *ts;

	buf = (char *) malloc(sizeof(char) * SIZE * 401);
	memset(buf, '\0', SIZE * 401);
    for (i = 0; i < 100000; i++) {
		ts = (struct ts *) (vcpu[vn].buf + src_len); 
		sprintf(buf + dst_len, "%lu  %lu  %lu  %lu  %ld  %lu\n", ts->flag, ts->vn, ts->time, ts->counter, ts->lt, ts->ct);
		//printf("%lu  %lu  %lu  %lu  %ld  %lu\n", ts->flag, ts->vn, ts->time, ts->counter, ts->lt, ts->ct);
		dst_len = strlen(buf);
		src_len += sizeof(struct ts);
	}
	int ret = pwrite(vcpu[vn].cpu_fd, buf, dst_len, 0);
	if (ret != dst_len)
		handle_error("Write IO debug file error!\n");

	free(buf);
}
#endif

#if defined MY_DEBUG_CPU_
void DEBUG_CPU_BUF(uint64_t flag, uint64_t vn, uint64_t time, uint64_t counter, int64_t lt, uint64_t ct) {
		struct ts ts;

//		if (vn == 0 || vn > 4) 
//			printf("How many vCPUs do you have?\n");
#if 1
		if (flag == 1 || flag == 2 || flag == 8 || flag == 9 || flag == 5 || flag == 6 || flag == 10 || flag > 10) {
			ts.flag = flag;
			ts.vn = vn;
			ts.time = time;
			ts.counter = counter;
			ts.lt = lt;
			ts.ct = ct;
			memcpy(vcpu[3].buf + vcpu[3].buf_len, &(ts), sizeof(struct ts));
			vcpu[3].buf_len += sizeof(struct ts);
			vcpu[3].buf_counter += 1;
		} else {
#endif
			ts.flag = flag;
			ts.vn = vn;
			ts.time = time;
			ts.counter = counter;
			ts.lt = lt;
			ts.ct = ct;
#if 1
			memcpy(vcpu[2].buf + vcpu[2].buf_len, &(ts), sizeof(struct ts));
			vcpu[2].buf_len += sizeof(struct ts);
			vcpu[2].buf_counter += 1;
#else
			memcpy(vcpu[vn].buf + vcpu[vn].buf_len, &(ts), sizeof(struct ts));
			vcpu[vn].buf_len += sizeof(struct ts);
			vcpu[vn].buf_counter += 1;
#endif
		}
}
#endif

#if defined MY_DEBUG_CPU_
void _DEBUG_CPU_BUF(uint64_t flag, uint64_t vn, uint64_t timeslice) {
		struct ts ts;

		if (vn == 0 || vn > 4) 
			printf("How many vCPUs do you have?\n");
		ts.flag = flag;
		ts.time = timeslice;
		memcpy(vcpu[vn].buf + vcpu[vn].buf_len, &(ts), sizeof(struct ts));
		vcpu[vn].buf_len += sizeof(struct ts);
		vcpu[vn].buf_counter += 1;
}
#endif

uint64_t  counter_migration(uint64_t vn) {
	uint64_t _vn = vn;
	uint64_t j;

	uint64_t counter = vcpu[vn].counter;
	for (j = 1; j < _vcpu_num; j++) {
		//printf("vCPU %lu's counter is %lu\n", j, vcpu[j].counter);
		if (j == vn)
			continue;
		else if (vcpu[j].counter < counter) {
			counter = vcpu[j].counter;
			_vn = j;
		} else
			continue;
	}
	if (_vn != vn) {
		//printf("Migrate to %lu and its counter is %lu\n", _vn, vcpu[_vn].counter);
#if defined MY_DEBUG_CPU_
		//DEBUG_CPU_BUF(3, vn);
#endif
		set_affinity_out(_vn, rt.tid);
#if defined MY_DEBUG_CPU_
		//DEBUG_CPU_BUF(4, _vn);
		//DEBUG_CPU_BUF(2, _vn);
#endif
		vn = _vn;
	}

	return vn;
}

uint64_t get_max_left_time(void) {
	uint64_t i = 0;
	int64_t left_time = vcpu[2].left_time;
	uint64_t vcpu_num = 2;

	i = 2;
	//DEBUG_CPU_BUF(3, i, vcpu[i].timeslice, vcpu[i].counter, vcpu[i].left_time, debug_time_monotonic_usec());
	for (i = start_vcpu + 1; i < end_vcpu; i++) {
		//DEBUG_CPU_BUF(3, i, vcpu[i].timeslice, vcpu[i].counter, vcpu[i].left_time, debug_time_monotonic_usec());
		if (vcpu[i].left_time > left_time) {
			left_time = vcpu[i].left_time;
			vcpu_num = i;
		}
	}
	//if (vn != vcpu_num)
	//	DEBUG_CPU_BUF(4, vcpu_num);
	//printf("Max left time is %ld\n", left_time);

	return vcpu_num;
}

uint64_t find_one_vcpu(uint64_t io_vn) {
	uint64_t i = 0;

	for (i = 1; i < _vcpu_num; i++) {
		if (vcpu[i].left_time >= 400) {
			return i;
		}
	}
	//if (vn != vcpu_num)
	//	DEBUG_CPU_BUF(4, vcpu_num);
	//printf("Max left time is %ld\n", left_time);

	return io_vn;
}

#if 0
uint64_t timeslice_migration(uint64_t vn) {
	int64_t tio_left_time = vcpu[vn].left_time;
	uint64_t vcpu_num;

	//if (tio_left_time < THRESHOLD) {
	vcpu_num = get_max_left_time(vn);
	if (vn != vcpu_num) {
#if defined MY_DEBUG_CPU_
		DEBUG_CPU_BUF(3, vn);
#endif
		set_affinity_out(vcpu_num, rt.tid);
#if defined MY_DEBUG_CPU_
		DEBUG_CPU_BUF(2, vcpu_num);
#endif
		vn = vcpu_num;
	}
	//}

	return vn;
}
#endif

uint64_t predict_one_vcpu(void) {
	uint64_t i;
	uint64_t _vn = 2;
	uint64_t dead_ts = vcpu[2].dead_ts;

	for (i = start_vcpu + 1; i < end_vcpu; i++) {
		if (dead_ts > vcpu[i].dead_ts) {
			dead_ts = vcpu[i].dead_ts;
			_vn = i;
		}
	}

	return _vn;
}

void do_debug_cpu_buf(uint64_t i) {
	DEBUG_CPU_BUF(1, i, vcpu[i].timeslice, vcpu[i].counter, vcpu[i].left_time, debug_time_monotonic_usec());
}

void *worker_thread(void *arg) {
	uint64_t vn = *((uint64_t *) arg);
	uint64_t s;
	uint64_t worker_vn;
	set_affinity(vn);
	//set_priority();
	
	worker_vn = get_affinity();
	printf("vn is %lu\n", vn);
	printf("Worker thread on vCPU %lu\n", worker_vn);
	
	while (1) {
		while ((s = sem_wait(&sem_worker)) == -1 && errno == EINTR)
			continue;

		//s = pthread_mutex_lock(&mutex);
		//cpu_sleep_counter -= 1;
		//printf("In I/O worker thread cpu_sleep_counter is %lu\n", cpu_sleep_counter);
		//printf("In I/O worker thread wj_offset is %lu\n", wj.offset);
		if (EACH_SIZE != (wj.len = pread(wj.fd, wj.buf, EACH_SIZE, wj.offset))) {
			fprintf(stderr, "This read, %lu,  failed!\n", wj.len);
			exit(EXIT_SUCCESS);
		}
		//s = pthread_mutex_unlock(&mutex);
		//s = pthread_cond_signal(&cond);
		if (sem_post(&sem_main) == -1) {
			fprintf(stderr, "sem_post() failed\n");
		}
	}
}

void *thread_iofunc(void *arg) {
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
	struct ts ts;
	uint64_t flag = 0;
	uint64_t s;


#if defined TEST_TIO_MIGRATION
	uint64_t tio_timeslice = 0;
	//XXX Left time may be negative value
	int64_t tio_left_time = 0;
	uint64_t vcpu_num = 0;
#endif

	uint64_t _start;
	uint64_t _diff;
	rt.pid = syscall(SYS_gettid);
	printf("I/O thread ID number is %d\n", rt.pid);
	//set_priority();
	//set_nice_priority(-10, rt.pid);

	//XXX Must set since the I/O thread would be pinned to that vCPU.
	//j = 0;
	set_affinity(2);
	io_vn = 0;
	int64_t lt = vcpu[2].left_time;
	uint64_t _i = 0;
	//io_vn = 0;
	//j = j + 1;

	memset(buf, '\0', EACH_SIZE + 1);
	io_vn = get_affinity();
	printf("I/O thread on vCPU %lu\n", io_vn);
	vn = io_vn;
	uint64_t mcounter = 0;
	uint64_t _mcounter = 0;
	int64_t think_time = 0;
	start = debug_time_monotonic_usec();
	//i = F_SIZE - EACH_SIZE;
	while (i != F_SIZE) {
	//while (i > 0) {
#if defined TEST_TIO_MIGRATION
#if 0
		if(vcpu[io_vn].left_time <= (int64_t) 3000) {
			_io_vn = get_max_left_time();
			if ((_io_vn != io_vn) && (vcpu[_io_vn].left_time >= (int64_t) 5000)) {
				io_vn = _io_vn;
				set_affinity(io_vn);
			}
			if (vcpu[io_vn].left_time <= (int64_t) 1000) {
				if (vcpu[_io_vn].left_time >= 2000) {
					io_vn = _io_vn;
					set_affinity(io_vn);
				} else {
					io_vn = predict_one_vcpu();
					set_affinity(io_vn);
				}
			}
		}
#endif
#endif
		//if (j == 6) j = 0;
		//set_affinity(j);
		//j = j + 1;
		//printf("%lu I/O %lu \n", debug_time_monotonic_usec(), get_affinity());
		//DEBUG_CPU_BUF(7, io_vn, vcpu[io_vn].left_time);
//		vn = find_one_vcpu(io_vn);
//		if (vn != io_vn) {
//			set_affinity(vn);
//			io_vn = vn;
//		}
//		if (lt != vcpu[io_vn].left_time) {
//			lt = vcpu[io_vn].left_time;
		//DEBUG_CPU_BUF(3, io_vn, vcpu[io_vn].timeslice, vcpu[io_vn].counter, vcpu[io_vn].left_time, debug_time_monotonic_usec());
//		}
#if 1
			//XXX: atomic worker job???
		//s = pthread_mutex_lock(&main_mutex);
		//wj.offset = i;
		//wj.len = EACH_SIZE;
		//_start = debug_time_monotonic_usec();
		if (EACH_SIZE != (wj.len = pread(wj.fd, buf, EACH_SIZE, i))) {
			fprintf(stderr, "This read, %lu,  failed!\n", (uint64_t) EACH_SIZE);
			exit(EXIT_SUCCESS);
		}
		//cpu_sleep_counter += 1;
		//printf("In I/O main thread wj_offset is %lu\n", wj.offset);
		//s = pthread_cond_wait(&cond, &main_mutex);
		//s = pthread_mutex_unlock(&mutex);
#if 0
		if (sem_post(&sem_worker) == -1) {
			fprintf(stderr, "sem_post() failed\n");
		}
		while ((s = sem_wait(&sem_main)) == -1 && errno == EINTR)
			continue;
#endif

		//TODO: pre-read
		//i = i + EACH_SIZE;
		//if (i == F_SIZE) break;
		//wj.flag = 1;
		//wj.offset = i;
		//wj.len = EACH_SIZE;
#if 1
		while (think_time != 4000) { //think time is around 20 microseconds
			think_time += 1;
		}
		think_time = 0;
#endif

#endif
		//_diff = debug_time_monotonic_usec() - _start;
		//printf("_diff is %lu\n", _diff);
		//vn = get_affinity();
		//DEBUG_CPU_BUF(_diff, vn, 0, 0, 0, debug_time_monotonic_usec());
		//DEBUG_CPU_BUF(_diff, vn, vcpu[vn].timeslice, vcpu[vn].counter, vcpu[vn].left_time, debug_time_monotonic_usec());
#if defined TEST_TIO_MIGRATION

		//if (_diff > 1000) {
		//	counter += _diff;
#if 0
			if (vcpu[io_vn].left_time < 500 && flag == 0) {
				_mcounter += 1;
				flag = 1;
			}
#endif
	//	}
#endif
		//i = i - EACH_SIZE;
		i = i + EACH_SIZE;
		memset(buf, '\0', EACH_SIZE + 1);
	}
	diff = debug_time_monotonic_usec() - start;
	printf("diff is %lu\n", diff);
	printf("counter_affi is %lu\n", counter_affi);
	//printf("mcounter is %lu, _mounter is %lu\n", mcounter, _mcounter);
	//set_affinity(2);
	//printf("cpu_sleep_counter is %lu\n", cpu_sleep_counter);
#if defined MY_DEBUG_CPU_
	//CPU_WRITE(1);
	//CPU_WRITE(2);
	//CPU_WRITE(3);
	//CPU_WRITE(4);
#endif
#if defined TEST_TIO_MIGRATION
	printf("With migration, I/O throughput is %lf MB/s.\n", ((double) F_SIZE / (double) (1024.0 * 1024.0) )  / ((double) diff / (double) 1000000.0));
#else
	printf("Without migration, I/O throughput is %lf MB/s.\n", ((double) F_SIZE / (double) (1024.0 * 1024.0) )  / ((double) diff / (double) 1000000.0));
#endif
}

int64_t get_lefttime(uint64_t vn) {
		//if (vcpu[vn].timeslice != 0) {
		vcpu[vn].left_time = vcpu[vn].timeslice - vcpu[vn].counter;
		//}

		return vcpu[vn].left_time;
}

void cal_timeslice(void) {
		//counter = counter + 1;
		//total_timeslice = total_timeslice + vcpu[vn].counter;
		//if (counter == 100) {
		//	counter = 0;
		//	vcpu[vn].timeslice = vcpu[vn].counter;
		//	total_timeslice = 0;
		//}
}

#if 0
void _do_migrate(uint64_t i) {
	uint64_t _vn = i;
	uint64_t j = 0;

		if (vcpu[i].counter <= 1000) {
#if defined MY_DEBUG_CPU_
			if ((vcpu[i].io_counter > j) && (_vn != i))
				DEBUG_CPU_BUF(1, i);
#endif
			continue;
		} else {
			_vn = i;
			//i = counter_migration(i);
			i = timeslice_migration(i);
			if (_vn != i)
				j = vcpu[i].io_counter; 
		}
}
#endif

uint64_t is_cpu_running(uint64_t vn) {
	int64_t plus_one = _vcpu[vn].plus_one;

	usleep(300);
	int64_t _plus_one = _vcpu[vn].plus_one;
	if (_plus_one != plus_one) {
		usleep(100);
		if (_plus_one != plus_one)
			return (uint64_t) 1;
	}
	
		return (uint64_t) 0;
}


uint64_t is_file_exist(void) {
	if (TRUE == g_file_test(rt.proc_path, G_FILE_TEST_EXISTS))
		return 1;
	else
		return 0;
}

uint64_t get_iothread_status(void) {
	char buf[1024];
	int ret = 0;

	memset(buf, '\0', 1024);
	struct stat fbuf;

	//fstat(rt.fd, &fbuf);
	//printf("Proc IO file size is %lu\n", fbuf.st_size);
	ret = pread(rt.fd, buf, 100, 0);
	if (ret != 100) handle_error("Read proc IO file error!\n");

	gchar **stat = g_strsplit(buf, " (", -1);
	//printf("%c\n", stat[1][0]);
	if (stat[1][0] == 'r')
		ret = 5; //running
	else if (stat[1][0] == 'd')
		ret = 6; //disk io
	else
		ret = 10;

	g_strfreev(stat);

	return ret;
}

void init_proc_iothread(void) {
	memset(rt.proc_path, '\0', 1024);
	sprintf(rt.proc_path, "/proc/%d/status", rt.pid);

	printf("Proc_path is %s\n", rt.proc_path);

	rt.fd = open(rt.proc_path, O_RDONLY);
	if (rt.fd < 0) handle_error("Open proc status file error!\n");
}

void *do_migrate(void *arg) {
	uint64_t vn = *((uint64_t *) arg);
	set_affinity(vn);
	set_priority();
	uint64_t i;
	uint64_t io_vn;
	uint64_t j = 0;
	int64_t check = 0;
	uint64_t _no = 0;
	uint64_t no = 0;
	uint64_t yes = 0;
	int64_t counter_y = 0;
	int64_t counter_n = 0;
	int64_t counter = 0;

	uint64_t timeslice = 0;
	uint64_t flag = 0;
	uint64_t counter_flag = 0;

	uint64_t diff = 0;
	uint64_t _diff = 0;
	uint64_t __diff = 0;
	uint64_t ___diff = 0;
	uint64_t start = 0;
	uint64_t end = 0;
	uint64_t _vn;
	uint64_t ret = 0;

	printf("do_migrate is upon vCPU %lu\n", vn);
	uint64_t _io_vn;

	//init_proc_iothread();

	start = debug_time_monotonic_usec();
	while (1) {
		if (0 == is_cpu_running(2lu) && flag == 0) {
			flag = 1;
			diff = debug_time_monotonic_usec() - start;
			//printf("diff is %lu\n", diff);
			DEBUG_CPU_BUF(0, 2, diff, 0, 0, debug_time_monotonic_usec());
		}
		if (1 == is_cpu_running(2lu) && flag == 1) {
			flag = 0;
			start = debug_time_monotonic_usec();
		}
		//if (vcpu[1].buf_counter == 10000) {
		//	CPU_WRITE(1);
		//}
	}
}

void *thread_func(void *arg) {
	uint64_t vn = *((uint64_t *) arg);
	set_affinity(vn);

	vn = get_affinity();
	printf("Timeslice worker is on %lu\n", vn);
	int pid = syscall(SYS_gettid);
	printf("Time slice thread PID number is %d\n", pid);
	//nice(-20);
	set_nice_priority(-20, pid);
	//set_priority();

	uint64_t io_vn = 0;
	uint64_t _io_vn = 0;
	uint64_t flag = 0;
	uint64_t ret;
	uint64_t start_time = 0;
	uint64_t end_time = 0;
	uint64_t diff_time = 0;
	uint64_t total_timeslice = 0;
	uint64_t end = 0;
	int len = 0;
	uint64_t deschedule = 0;
	int debug_flag = 0;

	start_time = debug_time_monotonic_usec();
	while(1) {
		//printf("vcpu %lu's timestamp is %lu\n", vn, debug_time_monotonic_usec());
#if 1
		if (flag == 0) {
			start_time = debug_time_monotonic_usec();
			vcpu[vn].start_time = debug_time_monotonic_usec();
			flag = 1;
		} else {
			start_time = debug_time_monotonic_usec();
			vcpu[vn].end_time = debug_time_monotonic_usec();
		}
		usleep(SLEEP_TIME);
		end_time = debug_time_monotonic_usec();
		diff_time = end_time - start_time;
		if (diff_time > DIFF_USEC) {
			vcpu[vn].deschedule_ts = diff_time;
			vcpu[vn].timeslice = vcpu[vn].end_time - vcpu[vn].start_time + (uint64_t) SLEEP_TIME;
			vcpu[vn].counter = 0;
			vcpu[vn].left_time = vcpu[vn].timeslice;
			vcpu[vn].start_time = debug_time_monotonic_usec();

			//io_vn = get_affinity_out(rt.tid);
			//io_vn = get_affinity(); //TODO: remove
			//if (vcpu[io_vn].left_time <= 4000) {
				/*XXX: avoid frequent set_affinity when IO thread has
				think time */
				//set_affinity_out(vn, rt.tid);
				//counter_affi += 1;
			//}
			if ((sm->flag == 1) && (-1 != (io_vn = get_pid_affinity(sm->pid)))) {
		//		if (debug_flag != 100) {
					//printf("shared pid is %d, io_vn is %lu, left time is %ld\n", sm->pid, io_vn, vcpu[io_vn].left_time);
		//			printf("vcpu: %lu, current time: %lu, io_vn: %lu, io_vn left time: %ld\n", vn, debug_time_monotonic_usec(), io_vn, vcpu[io_vn].left_time);
		//			debug_flag += 1;
		//		}
				curr_left_time = vcpu[io_vn].left_time;
				if (vcpu[io_vn].left_time < (int64_t) 6000 || ((prev_left_time == curr_left_time) && (debug_time_monotonic_usec() - prev_ts > (uint64_t) 300))) {
					set_pid_affinity(vn, sm->pid);
				}
                io_vn = get_pid_affinity(sm->pid);
				prev_left_time = vcpu[io_vn].left_time;
				prev_ts = debug_time_monotonic_usec();
			}
		} else {
			vcpu[vn].counter = vcpu[vn].end_time - vcpu[vn].start_time;
			vcpu[vn].left_time = vcpu[vn].timeslice - vcpu[vn].counter;
			//if (vcpu[vn].left_time < 500) {
				//vcpu[vn].left_time = 0;
			//}
		}
		vcpu[vn].dead_ts = debug_time_monotonic_usec();

#if 0
		if ((vn == 2) && (sm->flag == 1)) {
			DEBUG_CPU_BUF(0, vn, vcpu[vn].timeslice, vcpu[vn].counter, vcpu[vn].left_time, debug_time_monotonic_usec());
			if (vcpu[vn].buf_counter == 100000) {
				CPU_WRITE(2);
			}
		}
#endif
#if 1
		if (sm->flag == 1) {
			if (-1 != (_io_vn = get_pid_affinity(sm->pid))) {
				if(vcpu[_io_vn].left_time <= (int64_t) 2000) {
					io_vn = get_max_left_time();
					if (vcpu[io_vn].left_time >= (int64_t) 3000) {
						set_pid_affinity(io_vn, sm->pid);
					}
					if (vcpu[vn].left_time <= (int64_t) 600) {
						if (vcpu[io_vn].left_time >= 1000) {
							set_pid_affinity(io_vn, sm->pid);
						} else {
							io_vn = predict_one_vcpu();
							set_pid_affinity(io_vn, sm->pid);
						}
					}
				}
			} /*else {
				if (-1 != (_io_vn = get_pid_affinity(sm->pid))) {
					if (vcpu[_io_vn].left_time <= 600) {
						io_vn = get_max_left_time();
						if (vcpu[io_vn].left_time >= (int64_t) 1000) {
							set_pid_affinity(io_vn, sm->pid);
						} else {
							io_vn = predict_one_vcpu();
							set_pid_affinity(io_vn, sm->pid);
						}
					}
				}
			}*/
		}
#endif
	}
		//printf("vCPU %lu's counter is %lu\n", vn, vcpu[vn].counter);
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
		free(vcpu);
		free(p);
		exit(EXIT_SUCCESS);
	}
	// I/O thread
	ret = pthread_create(&pio, NULL, thread_iofunc, NULL);
	if (ret != 0) {
		printf("Pthread create error!\n");
		exit(EXIT_SUCCESS);
	}
	rt.tid = pio;
	rt.flag = 1;
}

#if defined MY_DEBUG_CPU_
void create_vcpu_debug_files(int i) {
	char debug_file_name[100];

	memset(debug_file_name, '\0', 100);

	sprintf(debug_file_name, "D_CPU_%d", i);
		
	vcpu[i].cpu_fd = open(debug_file_name, O_CREAT | O_RDWR, 00777);
	if (vcpu[i].cpu_fd < 0) {
		printf("Open/Create file error!\n");
		exit(EXIT_SUCCESS);
	}
}
#endif

void init_do_migrate_thread(void) {
	uint64_t ret = 0;
		
	vcpu[0].vcpu_num = 0;
	vcpu[0].counter = 0;
	vcpu[0].start_time = 0;
	vcpu[0].end_time = 0;
	vcpu[0].timeslice = 0;
	vcpu[0].left_time = 0;
#if defined MY_DEBUG_CPU_
	vcpu[0].buf = (char *) malloc(sizeof(char) * SIZE * 400);
	if (vcpu[0].buf == NULL)
		handle_error("Malloc error!");
	vcpu[0].buf_counter = 0;
	vcpu[0].buf_len = 0;
	vcpu[0].cpu_fd = open(CPU_DEBUG0, O_CREAT | O_RDWR, 00777);
	if (vcpu[0].cpu_fd < 0) {
		printf("Open/Create file error!\n");
		exit(EXIT_SUCCESS);
	}
#endif
	ret = pthread_create(&(p[0]), NULL, do_migrate, &(vcpu[0].vcpu_num));
	assert(ret == 0);
}


void init_worker_thread(void) {
	uint64_t i = 0;
	uint64_t j = 0;
	int ret = 0;

	worker = (pthread_t *) malloc(sizeof(pthread_t) * (__vcpu_num - _vcpu_num));
	if (worker == NULL)
		handle_error("malloc error!");
	worker_vcpu = (uint64_t *) malloc(sizeof(uint64_t) * (__vcpu_num - _vcpu_num));
	if (worker_vcpu == NULL)
		handle_error("malloc error!");
	printf("_vcpu_num is %lu, __vcpu_num is %lu\n", _vcpu_num, __vcpu_num);
	for (i = _vcpu_num; i < __vcpu_num; i++, j++) {
		worker_vcpu[j] = i;
		ret = pthread_create(&(worker[j]), NULL, worker_thread, &worker_vcpu[j]);
		if (ret != 0) {
			printf("Pthread create error!\n");
			exit(EXIT_SUCCESS);
		}
	}
}

void init_cpu_thread(void) {
	int ret = 0;
	uint64_t i;

	p = (pthread_t *) malloc(sizeof(pthread_t) * _vcpu_num);
	if (p == NULL)
		handle_error("malloc error!");
	vcpu = (struct vcpu *) malloc(sizeof(struct vcpu) * _vcpu_num);
	if (vcpu == NULL)
		handle_error("malloc error!");

	//init_io_thread();
	for (i = start_vcpu; i < end_vcpu; i++) {
	//XXX vCPU 0 is dedicated to handle all the interrupts
		vcpu[i].vcpu_num = i;
		vcpu[i].counter = 0;
		vcpu[i].start_time = 0;
		vcpu[i].end_time = 0;
		vcpu[i].timeslice = 0;
		vcpu[i].left_time = 0;
		vcpu[i].io_counter = 0;
		vcpu[i].deschedule_ts = 0;
		vcpu[i].dead_ts = 0;
#if defined MY_DEBUG_CPU_
		vcpu[i].buf = (char *) malloc(sizeof(char) * SIZE * 200);
		if (vcpu[i].buf == NULL)
			handle_error("Malloc error!");
		create_vcpu_debug_files(vcpu[i].vcpu_num);
		vcpu[i].buf_counter = 0;
		vcpu[i].buf_len = 0;
#endif
		ret = pthread_create(&(p[i]), NULL, thread_func, &(vcpu[i].vcpu_num));
		//ret = pthread_create(&(p[i]), NULL, thread_iofunc, &(vcpu[i].vcpu_num));
		if (ret != 0) {
			printf("Pthread create error!\n");
			exit(EXIT_SUCCESS);
		}
	}
	//sleep(5); //XXX: wait for timeslice thread to be ready.
	//init_io_thread();
	//init_worker_thread();
	//if (sem_post(&sem_main) == -1) {
	//	fprintf(stderr, "sem_post() failed\n");
	//}
	//usleep(100);
	//init_do_migrate_thread();
}

void *_thread_func(void *arg) {
	uint64_t vn = *((uint64_t *) arg);
	set_affinity(vn);
	set_idle_priority();

	vn = get_affinity();
	printf("CPU daemon worker is on %lu\n", vn);
	int pid = syscall(SYS_gettid);
	//set_nice_priority(20, pid);
	printf("CPU daemon worker thread PID number is %d\n", pid);

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

	for (i = start_vcpu; i < end_vcpu + 1; i++) {
	//XXX vCPU 0 is dedicated to handle all the interrupts
		_vcpu[i].vcpu_num = i;
		_vcpu[i].plus_one = 0;
		ret = pthread_create(&(_p[i]), NULL, _thread_func, &(_vcpu[i].vcpu_num));
		if (ret != 0) {
			printf("Pthread create error!\n");
			exit(EXIT_SUCCESS);
		}
	}
}

void init_register_task(void) {
	rt.flag = 0;
}

void init_sem(void) {
	if (sem_init(&sem_main, 0, 0) == -1)
		handle_error("sem1_init_error");
	if (sem_init(&sem_worker, 0, 0) == -1)
		handle_error("sem1_init_error");
}

void init_shared_mem(void) {
	if ((shmid = shmget(key, sizeof(struct shared_mem), IPC_CREAT | 0666)) < 0) {
		handle_error("shmget error!\n");
	}
	
	if ((shm = shmat(shmid, NULL, 0)) == (void *) -1) {
		handle_error("shmat error!\n");
	}

	sm = (struct shared_mem *) shm;
	sm->flag = 0;
	sm->counter = 0;
	sm->pid = 0;
}

int main(int argc, char **argv) {
	pid_t pid = getpid();
	uint64_t vcpu_num = get_vcpu_count();
	__vcpu_num = vcpu_num;
	//vcpu_num = 4;
	_vcpu_num = vcpu_num;
	int i = 0;

	printf("vCPU number is %lu\n", _vcpu_num);
	printf("Process ID number is %d\n", pid);
	//init_sem();
	//init_register_task();

	init_shared_mem();
	init_probe_thread();
	init_cpu_thread();


	//pthread_join(pio, NULL);
	for (i = start_vcpu; i < end_vcpu; i++) {
		pthread_join(_p[i], NULL);
	}
	for (i = start_vcpu; i < end_vcpu; i++) {
		pthread_join(p[i], NULL);
	}


	return 0;
}
