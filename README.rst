Spectral Norm Shootout
======================

These are codes for the Spectral Norm problem:

http://shootout.alioth.debian.org/u32/performance.php?test=spectralnorm#about

All solutions are accepted (no matter how they are implemented, as long as they
give the correct answer). They should run on a single processor only (single
thread).

Solutions
---------

As compared to the shootout.alioth.debian.org:

* `spectral_norm1.f90`: The most direct Fortran implementation (our
  implementation)
* `spectral_norm2.f90`: Like `spectral_norm1`, but optimized for gfortran (our
  implementation)
* `spectral_norm3.f90`: Fortran Intel #2
* `spectral_norm4.cpp`: C++ GNU g++ #6 (removed openmp)
* `spectral_norm5.cpp`: C++ GNU g++ #2 (removed openmp)

Compile
-------

Type::

    make

Run timings
-----------

Type::

    make test

The output should look like::

    $ make test
    spectral_norm1
    time ./spectral_norm1 5500
    1.274224153
    5.49user 0.15system 0:05.68elapsed 99%CPU (0avgtext+0avgdata 949568maxresident)k
    0inputs+0outputs (0major+59416minor)pagefaults 0swaps
    spectral_norm2
    time ./spectral_norm2 5500
    1.274224153
    2.49user 0.17system 0:02.69elapsed 99%CPU (0avgtext+0avgdata 949104maxresident)k
    0inputs+0outputs (0major+59406minor)pagefaults 0swaps
    spectral_norm3
    time ./spectral_norm3 5500
    1.274224153
    12.25user 0.00system 0:12.27elapsed 99%CPU (0avgtext+0avgdata 4176maxresident)k
    0inputs+0outputs (0major+317minor)pagefaults 0swaps
    spectral_norm4
    time ./spectral_norm4 5500
    1.274224153
    5.28user 0.00system 0:05.30elapsed 99%CPU (0avgtext+0avgdata 4432maxresident)k
    0inputs+0outputs (0major+336minor)pagefaults 0swaps
    spectral_norm5
    time ./spectral_norm5 5500
    1.274224153
    5.29user 0.00system 0:05.30elapsed 99%CPU (0avgtext+0avgdata 2528maxresident)k
    0inputs+0outputs (0major+201minor)pagefaults 0swaps
