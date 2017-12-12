#!/bin/bash

#!/bin/bash

# Download and extract NPB
wget http://www.nas.nasa.gov/assets/npb/NPB3.3.1.tar.gz 2>&1
tar xf NPB3.3.1.tar.gz
cd NPB3.3.1
# Setup MPI
cd NPB3.3-MPI/config
cp suite.def.template suite.def
cp make.def.template make.def
sed -i -e 's/f77/mpif77/g' -e 's/cc/mpicc/g' -e 's/-O/-O3 -mcmodel=medium/g' make.def
cd ../..
# Setup OMP
cd NPB3.3-OMP/config
cp suite.def.template suite.def
cp NAS.samples/make.def.gcc_x86 make.def
cd ../..
# Setup Serial
cd NPB3.3-SER/config
cp suite.def.template suite.def
cp NAS.samples/make.def_gcc_x86 make.def
cd ~

# Download, extract and setup NPB-MZ
#wget http://www.nas.nasa.gov/assets/npb/NPB3.3.1-MZ.tar.gz 2>&1
#tar xf NPB3.3.1-MZ.tar.gz
#cp NPB3.3.1/NPB3.3-MPI/config/make.def NPB3.3.1-MZ/NPB3.3-MZ-MPI/config
#cp NPB3.3.1-MZ/NPB3.3-MZ-MPI/config/suite.def.template NPB3.3.1-MZ/NPB3.3-MZ-MPI/config/suite.def
#cp NPB3.3.1/NPB3.3-OMP/config/make.def NPB3.3.1-MZ/NPB3.3-MZ-OMP/config
#cp NPB3.3.1-MZ/NPB3.3-MZ-OMP/config/suite.def.template NPB3.3.1-MZ/NPB3.3-MZ-OMP/config/suite.def
#cp NPB3.3.1/NPB3.3-SER/config/make.def NPB3.3.1-MZ/NPB3.3-MZ-SER/config
#cp NPB3.3.1-MZ/NPB3.3-MZ-SER/config/suite.def.template NPB3.3.1-MZ/NPB3.3-MZ-SER/config/suite.def
