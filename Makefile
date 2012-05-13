F90 = gfortran
CPP = g++
# Common flags used for both g++ and gfortran
GCCFLAGS = -Wall -Wextra -fPIC -O3 -march=native -ffast-math -funroll-loops
# Specific g++ and gfortran flags
F90FLAGS = $(GCCFLAGS) -Wimplicit-interface
CPPFLAGS = $(GCCFLAGS)

%.o: %.f90
	$(F90) $(F90FLAGS) -c $<

%.o: %.cpp
	$(CPP) $(CPPFLAGS) -c $<

all: spectral_norm1 spectral_norm2 spectral_norm3 spectral_norm4 spectral_norm5 spectral_norm6

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
