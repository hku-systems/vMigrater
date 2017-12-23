#!/bin/bash

echo 1 | sudo tee /proc/sys/kernel/cpuidle_busy_loop
