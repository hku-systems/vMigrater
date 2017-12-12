/*
 * hotstorage/2016310/eval/debug.h
 *
 * Weiwei Jia <wj47@njit.edu> (C) 2016
 */
//#pragma once

#ifndef __DEBUG_EXP__
#define __DEBUG_EXP__

#include <sys/time.h>
#include <stdint.h>

uint64_t debug_time_usec(void);

double debug_time_sec(void);

uint64_t debug_diff_usec(const uint64_t last);

double debug_diff_sec(const double last);

uint64_t debug_tv_diff(const struct timeval * const t0, const struct timeval * const t1);

void debug_print_tv_diff(char *tag, const struct timeval t0, const struct timeval t1);

//void debug_trace(void);
#endif
