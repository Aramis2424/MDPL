#include "defines.h"

float sum_32bit(float a, float b)
{
    return a + b;
}

float mul_32bit(float a, float b)
{
    return a * b;
}

float asm_sum_32bit(float a, float b)
{
    float sum = 0;
    __asm__(".intel_syntax noprefix\n\t"
            "fld %1\n\t"
            "fld %2\n\t"
            "faddp\n\t"
            "fstp %0\n\t"
            : "=&m"(sum)
            : "m"(a),"m"(b)
            );
    return sum;
}

float asm_mul_32bit(float a, float b)
{
    float mul = 0.;
    __asm__(".intel_syntax noprefix\n\t"
            "fld %1\n\t"
            "fld %2\n\t"
            "fmulp\n\t"
            "fstp %0\n\t"
            : "=&m" (mul)
            : "m" (a), "m" (b)
            );
    return mul;
}

void res_32(void)
{
    printf("\n32bit:\n");

    float a = 1.232, b = 15e-5, res;
    int repeat = 10000000;

    clock_t begin, end;
    double total;

    begin = clock();
    for (int i = 0; i < repeat; i++)
        res += sum_32bit(a, b);
    end = clock();

    total = (double)(end - begin) ;

    printf("%s %.3g\n", "(SUM) std: ", total);

    begin = clock();
    for (int i = 0; i < repeat; i++)
        mul_32bit(a, b);
    end = clock();

    total = (double)(end - begin)  ;

    printf("%s %.3g\n", "(MUL) std: ", total);

    begin = clock();
    for (int i = 0; i < repeat; i++)
        res += asm_sum_32bit(a, b);
    end = clock();

    total = (double)(end - begin)  ;

    printf("%s %.3g\n", "(SUM) asm: ", total);

    begin = clock();
    for (int i = 0; i < repeat; i++)
        asm_mul_32bit(a, b);
    end = clock();

    total = (double)(end - begin)  ;

    printf("%s %.3g\n", "(MUL) asm: ", total);
}