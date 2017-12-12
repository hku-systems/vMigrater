#!/bin/bash

cd /home/kvm1/vMigrater/macro_benchmarks/bench7
./flush
echo "Dedicated, 1st: bt.S.1.mpi_io_full======================================>"
/usr/bin/taskset -c 1 mpiexec -np 1 /home/kvm1/vMigrater/macro_benchmarks/bench7/NPB3.3.1/NPB3.3-MPI/bin/bt.S.1.mpi_io_full

cd /home/kvm1/vMigrater/macro_benchmarks/bench7
./flush
echo "Dedicated, 2nd: bt.S.1.mpi_io_full======================================>"
/usr/bin/taskset -c 1 mpiexec -np 1 /home/kvm1/vMigrater/macro_benchmarks/bench7/NPB3.3.1/NPB3.3-MPI/bin/bt.S.1.mpi_io_full


cd /home/kvm1/vMigrater/macro_benchmarks/bench7
./flush
echo "Shared, 1st: bt.S.1.mpi_io_full==========================================>"
/usr/bin/taskset -c 5 mpiexec -np 1 /home/kvm1/vMigrater/macro_benchmarks/bench7/NPB3.3.1/NPB3.3-MPI/bin/bt.S.1.mpi_io_full

cd /home/kvm1/vMigrater/macro_benchmarks/bench7
./flush
echo "Shared, 2nd: bt.S.1.mpi_io_full==========================================>"
/usr/bin/taskset -c 5 mpiexec -np 1 /home/kvm1/vMigrater/macro_benchmarks/bench7/NPB3.3.1/NPB3.3-MPI/bin/bt.S.1.mpi_io_full



cd /home/kvm1/vMigrater/macro_benchmarks/bench7
./flush
echo "Dedicated, 1st: bt.S.1.mpi_io_simple======================================>"
/usr/bin/taskset -c 1 mpiexec -np 1 /home/kvm1/vMigrater/macro_benchmarks/bench7/NPB3.3.1/NPB3.3-MPI/bin/bt.S.1.mpi_io_simple

cd /home/kvm1/vMigrater/macro_benchmarks/bench7
./flush
echo "Dedicated, 2nd: bt.S.1.mpi_io_simple======================================>"
/usr/bin/taskset -c 1 mpiexec -np 1 /home/kvm1/vMigrater/macro_benchmarks/bench7/NPB3.3.1/NPB3.3-MPI/bin/bt.S.1.mpi_io_simple


cd /home/kvm1/vMigrater/macro_benchmarks/bench7
./flush
echo "Shared, 1st: bt.S.1.mpi_io_simple==========================================>"
/usr/bin/taskset -c 5 mpiexec -np 1 /home/kvm1/vMigrater/macro_benchmarks/bench7/NPB3.3.1/NPB3.3-MPI/bin/bt.S.1.mpi_io_simple

cd /home/kvm1/vMigrater/macro_benchmarks/bench7
./flush
echo "Shared, 2nd: bt.S.1.mpi_io_simple==========================================>"
/usr/bin/taskset -c 5 mpiexec -np 1 /home/kvm1/vMigrater/macro_benchmarks/bench7/NPB3.3.1/NPB3.3-MPI/bin/bt.S.1.mpi_io_simple
