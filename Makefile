F90 = gfortran
CPP = g++
CC  = gcc
# Common flags used for all g++, gcc and gfortran
GCCFLAGS = -Wall -Wextra -fPIC -O3 -g -msse2 -march=native -ffast-math -funroll-loops -fomit-frame-pointer -fstrict-aliasing
# Specific g++, gcc and gfortran flags
F90FLAGS = $(GCCFLAGS) -Wimplicit-interface
CPPFLAGS = $(GCCFLAGS)
CFLAGS   = $(GCCFLAGS)

%.o: %.f90
	$(F90) $(F90FLAGS) -c $<

%.o: %.cpp
	$(CPP) $(CPPFLAGS) -c $<

%.o: %.c
	$(CC) $(CFLAGS) -c $<

all: spectral_norm1 spectral_norm2 spectral_norm3 spectral_norm4 spectral_norm5 spectral_norm6 spectral_norm7 spectral_norm8

spectral_norm1: spectral_norm1.o
	$(F90) -o $@ $<

spectral_norm2: spectral_norm2.o
	$(F90) -o $@ $<

spectral_norm3: spectral_norm3.o
	$(F90) -o $@ $<

spectral_norm4: spectral_norm4.o
	$(CPP) -o $@ $<

spectral_norm5: spectral_norm5.o
	$(CPP) -o $@ $<

spectral_norm6: spectral_norm6.o
	$(F90) -o $@ $<

spectral_norm7: spectral_norm7.o
	$(CPP) -o $@ $<

test:
	@echo "spectral_norm1"
	time ./spectral_norm1 5500
	@echo "spectral_norm2"
	time ./spectral_norm2 5500
	@echo "spectral_norm3"
	time ./spectral_norm3 5500
	@echo "spectral_norm4"
	time ./spectral_norm4 5500
	@echo "spectral_norm5"
	time ./spectral_norm5 5500
	@echo "spectral_norm6"
	time ./spectral_norm6 5500
	@echo "spectral_norm7"
	time ./spectral_norm7 5500
	@echo "spectral_norm8"
	time ./spectral_norm8 5500
