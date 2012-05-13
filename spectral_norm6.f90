program spectral_norm6
! This uses spectral_norm3 as a starting point, but does not use the Fortran's
! builtin matmul and dotproduct (to make sure it does not call some optimized
! BLAS behind the scene).
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
    v = AvA(A, u)
    u = AvA(A, v)
end do

write(*, "(f0.9)") sqrt(dot_product2(u, v) / dot_product2(v, v))

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
    u(i) = dot_product2(A(:, i), v)
end do
end function

pure real(dp) function dot_product2(u, v) result(w)
! Calculates w = dot_product(u, v)
real(dp), intent(in) :: u(:), v(:)
integer :: i
w = 0
do i = 1, size(u)
    w = w + u(i)*v(i)
end do
end function

pure function matmul3(A, v) result(u)
! Calculates u = matmul(v, A), but much faster (in gfortran)
real(dp), intent(in) :: v(:), A(:, :)
real(dp) :: u(size(v))
integer :: i, j
u = 0
do j = 1, size(v)
    do i = 1, size(v)
        u(i) = u(i) + A(i, j)*v(j)
    end do
end do
end function

pure function AvA(A, v) result(u)
! Calculates u = matmul2(matmul3(A, v), A)
! In gfortran, this function is sligthly faster than calling
! matmul2(matmul3(A, v), A) directly.
real(dp), intent(in) :: v(:), A(:, :)
real(dp) :: u(size(v))
u = matmul2(matmul3(A, v), A)
end function

end program
