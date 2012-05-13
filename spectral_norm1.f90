program spectral_norm1
! This is the most natural/direct implementation of the mathematics in Fortran.
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
    v = matmul(matmul(A, u), A)
    u = matmul(matmul(A, v), A)
end do

write(*, "(f0.9)") sqrt(dot_product(u, v) / dot_product(v, v))

contains

pure real(dp) function Ac(i, j) result(r)
integer, intent(in) :: i, j
r = 1._dp / ((i+j-2) * (i+j-1)/2 + i)
end function

end program
