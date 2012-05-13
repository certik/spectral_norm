#include <cmath>
#include <cstdlib>
#include <cstdio>

double Ac(int i, int j)
{
    return 1.0 / ((i+j) * (i+j+1)/2 + i+1);
}

double dot_product2(int n, double u[], double v[])
{
    double w;
    int i;
    w = 0;
    for (i = 0; i < n; i++) {
        w += u[i]*v[i];
    }
    return w;
}

void matmul2(int n, double v[], double **A, double u[])
{
    int i, j;
    for (i = 0; i < n; i++) {
        u[i] = 0;
    }
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            u[i] += A[j][i] * v[j];
        }
    }
}


void matmul3(int n, double **A, double v[], double u[])
{
    int i, j;
    for (i = 0; i < n; i++) {
        u[i] = 0;
    }
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            u[i] += A[i][j] * v[j];
        }
    }
}

void AvA(int n, double **A, double v[], double u[])
{
    double tmp[n];
    matmul3(n, A, v, tmp);
    matmul2(n, tmp, A, u);
}


double spectral_game(int n)
{
    double **A, u[n], v[n];
    A = (double **)malloc(n*sizeof(double *));
    int i, j;
    for (i = 0; i < n; i++) {
        A[i] = (double *)malloc(n*sizeof(double));
    }

    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            A[i][j] = Ac(i, j);
        }
    }


    for (i = 0; i < n; i++) {
        u[i] = 1;
    }
    for (i = 0; i < 10; i++) {
        AvA(n, A, u, v);
        AvA(n, A, v, u);
    }
    return sqrt(dot_product2(n, u, v) / dot_product2(n, v, v));
}

int main(int argc, char *argv[]) {
    int N = ((argc >= 2) ? atoi(argv[1]) : 2000);
    printf("%.9f\n", spectral_game(N));
    return 0;
}
