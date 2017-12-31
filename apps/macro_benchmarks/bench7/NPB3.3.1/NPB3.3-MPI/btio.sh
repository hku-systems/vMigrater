#!/bin/bash


#smallest size
make bt NPROCS=1 CLASS=W SUBTYPE=full
make bt NPROCS=1 CLASS=W SUBTYPE=simple
make bt NPROCS=1 CLASS=W SUBTYPE=fortran
make bt NPROCS=1 CLASS=W SUBTYPE=epio

make bt NPROCS=4 CLASS=W SUBTYPE=full
make bt NPROCS=4 CLASS=W SUBTYPE=simple
make bt NPROCS=4 CLASS=W SUBTYPE=fortran
make bt NPROCS=4 CLASS=W SUBTYPE=epio


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

