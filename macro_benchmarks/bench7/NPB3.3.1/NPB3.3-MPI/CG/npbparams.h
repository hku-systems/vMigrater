c NPROCS = 1 CLASS = S
c  
c  
c  This file is generated automatically by the setparams utility.
c  It sets the number of processors and the class of the NPB
c  in this directory. Do not modify it by hand.
c  
        integer            na, nonzer, niter
        double precision   shift, rcond
        parameter(  na=1400,
     >              nonzer=7,
     >              niter=15,
     >              shift=10.,
     >              rcond=1.0d-1 )

c number of nodes for which this version is compiled
        integer    nnodes_compiled
        parameter( nnodes_compiled = 1)
        integer    num_proc_cols, num_proc_rows
        parameter( num_proc_cols=1, num_proc_rows=1 )
        logical  convertdouble
        parameter (convertdouble = .false.)
        character*11 compiletime
        parameter (compiletime='06 Dec 2017')
        character*5 npbversion
        parameter (npbversion='3.3.1')
        character*6 cs1
        parameter (cs1='mpif77')
        character*9 cs2
        parameter (cs2='$(MPIF77)')
        character*22 cs3
        parameter (cs3='-L/usr/local/lib -lmpi')
        character*20 cs4
        parameter (cs4='-I/usr/local/include')
        character*19 cs5
        parameter (cs5='-O3 -mcmodel=medium')
        character*19 cs6
        parameter (cs6='-O3 -mcmodel=medium')
        character*6 cs7
        parameter (cs7='randi8')
