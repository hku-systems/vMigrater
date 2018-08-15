vMigrater
=========
Effectively Mitigating I/O Inactivity in vCPU Scheduling

## HOWTO

1. Install third part dependencies.
	* QEMU/KVM (VMM), please refer to https://www.qemu.org/download/#source and https://www.linux-kvm.org/page/HOWTO.
	* BCC (I/O tasks filter), please refer to https://github.com/iovisor/bcc
2. Build vMigrater.
	* cd vMIgrater/src
	* ./compile.sh
3. Run vMigrater.
	* Create several VMs.
	* Run computation intensive application (e.g., Spark) and I/O intensive application (e.g., HDFS) in each VM.
	* Start BCC to filter out I/O intensive tasks.
	* cd vMigrater/src; ./compile.sh; ./build/main <I/O_task_ID>
