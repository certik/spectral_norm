#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

/* Define the generic vector type macro. */  
#define vector(elcount, type)  __attribute__((vector_size((elcount)*sizeof(type)))) type

double Ac(int i, int j)
{
    return 1.0 / ((i+j) * (i+j+1)/2 + i+1);
}

double dot_product2(int n, double u[], double v[])
{
    double w;
    int i;
    union {
        vector(2,double) v;
        double d[2];
        } *vu = u, *vv = v, acc[2];

    /* Init some stuff. */
    acc[0].d[0] = 0.0; acc[0].d[1] = 0.0;
    acc[1].d[0] = 0.0; acc[1].d[1] = 0.0;

    /* Take in chunks of two by two doubles. */
    for ( i = 0 ; i < (n/2 & ~1) ; i += 2 ) {
        acc[0].v += vu[i].v * vv[i].v;
        acc[1].v += vu[i+1].v * vv[i+1].v;
        }
    w = acc[0].d[0] + acc[0].d[1] + acc[1].d[0] + acc[1].d[1];

    /* Catch leftovers (if any) */
    for ( i = n & ~3 ; i < n ; i++ )
        w += u[i] * v[i];

    return w;

}

void matmul2(int n, double v[], double A[], double u[])
{
    int i, j;
    union {
        vector(2,double) v;
        double d[2];
        } *vu = u, *vA, vi;

    bzero( u , sizeof(double) * n );

    for (i = 0; i < n; i++) {
        vi.d[0] = v[i];
        vi.d[1] = v[i];
        vA = &A[i*n];
        for ( j = 0 ; j < (n/2 & ~1) ; j += 2 ) {
            vu[j].v += vA[j].v * vi.v;
            vu[j+1].v += vA[j+1].v * vi.v;
            }
        for ( j = n & ~3 ; j < n ; j++ )
            u[j] += A[i*n+j] * v[i];
        }

}


void matmul3(int n, double A[], double v[], double u[])
{
    int i;

    for (i = 0; i < n; i++)
        u[i] = dot_product2( n , &A[i*n] , v );

}

void AvA(int n, double A[], double v[], double u[])
{
    double tmp[n] __attribute__ ((aligned (16)));
    matmul3(n, A, v, tmp);
    matmul2(n, tmp, A, u);
}


double spectral_game(int n)
{
    double *A;
    double u[n] __attribute__ ((aligned (16)));
    double v[n] __attribute__ ((aligned (16)));
    int i, j;

    /* Aligned allocation. */
    /* A = (double *)malloc(n*n*sizeof(double)); */
    if ( posix_memalign( (void **)&A , 4*sizeof(double) , sizeof(double) * n * n ) != 0 ) {
        printf( "spectral_game:%i: call to posix_memalign failed.\n" , __LINE__ );
        abort();
        }


    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            A[i*n+j] = Ac(i, j);
        }
    }


    for (i = 0; i < n; i++) {
        u[i] = 1.0;
    }
    for (i = 0; i < 10; i++) {
        AvA(n, A, u, v);
        AvA(n, A, v, u);
    }
    free(A);
    return sqrt(dot_product2(n, u, v) / dot_product2(n, v, v));
}

int main(int argc, char *argv[]) {
    int i, N = ((argc >= 2) ? atoi(argv[1]) : 2000);
    for ( i = 0 ; i < 10 ; i++ )
        printf("%.9f\n", spectral_game(N));
    return 0;
}
