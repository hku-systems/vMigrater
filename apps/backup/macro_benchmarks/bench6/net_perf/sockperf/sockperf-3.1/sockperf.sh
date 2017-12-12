

#Server side
# Shared vCPU
/usr/bin/taskset -c 5 ./sockperf server --tcp -i 192.168.122.95 -p 12345
# Dedicated vCPU
/usr/bin/taskset -c 1 ./sockperf server --tcp -i 192.168.122.95 -p 12345


# Client Side
/usr/bin/taskset -c 1 ./sockperf pp --tcp -i 192.168.122.95 -p 12345 -t 30
