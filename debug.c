/*
 * debug.c
 *
 * Weiwei Jia <harryxiyou@gmail.com> (C) 2016
 */

#define _GNU_SOURCE
#define _LARGEFILE64_SOURCE

#include <sys/time.h>
#include <stdio.h>
#include <execinfo.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include <time.h>

#define MIN(a, b) ({                            \
		__typeof__(a) __a = (a);                \
		__typeof__(b) __b = (b);                \
		(__a < __b) ? __a : __b;                \
		})

#define MAX(a, b) ({                            \
		__typeof__(a) __a = (a);                \
		__typeof__(b) __b = (b);                \
		(__a > __b) ? __a : __b;                \
		})

#define SWAP(a, b) ({                           \
		__typeof__(a) __a = (a);                \
		(a) = (b);                              \
		(b) = __a;                              \
		})

uint64_t debug_time_usec(void) {
  struct timeval tv;
  gettimeofday(&tv, NULL);
  return (uint64_t) tv.tv_sec * 1000000lu + tv.tv_usec;
}

uint64_t debug_time_monotonic_usec(void) {
	struct timespec ts;
	clock_gettime(CLOCK_MONOTONIC, &ts);
	return (uint64_t) ((uint64_t) ts.tv_sec * 1000000lu + (uint64_t) ((double) ts.tv_nsec / 1000.0));
}

double debug_time_sec(void) {
  const uint64_t usec = debug_time_usec();
  return ((double)usec) / 1000000.0;
}

uint64_t debug_diff_usec(const uint64_t last) {
  return debug_time_usec() - last;
}

double debug_diff_sec(const double last) {
  return debug_time_sec() - last;
}

uint64_t debug_tv_diff(const struct timeval * const t0, const struct timeval * const t1) {
  return UINT64_C(1000000) * (t1->tv_sec - t0->tv_sec) + (t1->tv_usec - t0->tv_usec);
}

void debug_print_tv_diff(char * tag, const struct timeval t0, const struct timeval t1) {
  printf("%s: %" PRIu64 " us\n", tag, debug_tv_diff(&t0, &t1));
}

void my_sleep(uint64_t microseconds) {
	struct timespec ts;

	clock_gettime(CLOCK_MONOTONIC, &ts);
	ts.tv_nsec += microseconds * 1000;

	if (ts.tv_nsec >= 1000000000) {
		ts.tv_nsec -= 1000000000;
		ts.tv_sec += 1;
	}
	clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL);
}

#if 0
void debug_trace (void) {
  void *array[100];
  char **strings;

  const int size = backtrace(array, 100);
  strings = backtrace_symbols(array, size);

  printf("Obtained %d stack frames.\n", size);

  int i;
  for (i = 0; i < size; i++)
    printf ("%d -> %s\n", i, strings[i]);

  free (strings);
}
#endif
