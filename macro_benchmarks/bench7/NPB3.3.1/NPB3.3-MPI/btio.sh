#!/bin/bash


#smallest size
make bt NPROCS=1 CLASS=S SUBTYPE=full
make bt NPROCS=1 CLASS=S SUBTYPE=simple
make bt NPROCS=1 CLASS=S SUBTYPE=fortran
make bt NPROCS=1 CLASS=S SUBTYPE=epio

make bt NPROCS=4 CLASS=S SUBTYPE=full
make bt NPROCS=4 CLASS=S SUBTYPE=simple
make bt NPROCS=4 CLASS=S SUBTYPE=fortran
make bt NPROCS=4 CLASS=S SUBTYPE=epio

#middle size
make bt NPROCS=1 CLASS=B SUBTYPE=full
make bt NPROCS=1 CLASS=B SUBTYPE=simple
make bt NPROCS=1 CLASS=B SUBTYPE=fortran
make bt NPROCS=1 CLASS=B SUBTYPE=epio

make bt NPROCS=4 CLASS=B SUBTYPE=full
make bt NPROCS=4 CLASS=B SUBTYPE=simple
make bt NPROCS=4 CLASS=B SUBTYPE=fortran
make bt NPROCS=4 CLASS=B SUBTYPE=epio

#biggest size
make bt NPROCS=1 CLASS=E SUBTYPE=full
make bt NPROCS=1 CLASS=E SUBTYPE=simple
make bt NPROCS=1 CLASS=E SUBTYPE=fortran
make bt NPROCS=1 CLASS=E SUBTYPE=epio

make bt NPROCS=4 CLASS=E SUBTYPE=full
make bt NPROCS=4 CLASS=E SUBTYPE=simple
make bt NPROCS=4 CLASS=E SUBTYPE=fortran
make bt NPROCS=4 CLASS=E SUBTYPE=epio
