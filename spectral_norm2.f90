program spectral_norm2
! This uses spectral_norm1 as a starting point and introduces two improvements:
!
! 1) matmul2() function, that is much faster than gfortran's builtin function
! 2) AvA() function, that is a bit faster than manually inlining the code
!
! Using 1) and 2), gfortran is able to optimize the code better. For IFort, one
! should start from spectral_norm1 and see what tricks produce the fastest
! code.
implicit none

integer, parameter :: dp = kind(0d0)
real(dp), allocatable :: A(:, :), u(:), v(:)
integer :: i, j, n
character(len=6) :: argv

call get_command_argument(1, argv)
read(argv, *) n

allocate(u(n), v(n), A(n, n))
do j = 1, n
    do i = 1, n
        A(i, j) = Ac(i, j)
    end do
end do

u = 1
do i = 1, 10
    !v = matmul2(matmul(A, u), A)
    !u = matmul2(matmul(A, v), A)
    v = AvA(A, u)
    u = AvA(A, v)
end do

write(*, "(f0.9)") sqrt(dot_product(u, v) / dot_product(v, v))

contains

pure real(dp) function Ac(i, j) result(r)
integer, intent(in) :: i, j
r = 1._dp / ((i+j-2) * (i+j-1)/2 + i)
end function

pure function matmul2(v, A) result(u)
! Calculates u = matmul(v, A), but much faster (in gfortran)
real(dp), intent(in) :: v(:), A(:, :)
real(dp) :: u(size(v))
integer :: i
do i = 1, size(v)
    u(i) = dot_product(A(:, i), v)
end do
end function

pure function AvA(A, v) result(u)
! Calculates u = matmul2(matmul(A, v), A)
! In gfortran, this function is sligthly faster than calling
! matmul2(matmul(A, v), A) directly.
real(dp), intent(in) :: v(:), A(:, :)
real(dp) :: u(size(v))
u = matmul2(matmul(A, v), A)
end function

end program
