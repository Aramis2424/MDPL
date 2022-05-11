#include "defines.h"

#ifndef X87

long double sum_80bit(long double a, long double b)
{
    return a + b;
}

long double mul_80bit(long double a, long double b)
{
    return a * b;
}

long double _asm_sum_80bit(long double a, long double b)
{
    long double sum = 0.;
    __asm__(".intel_syntax noprefix\n\t"
            "fld %1\n\t"
            "fld %2\n\t"
            "faddp\n\t"
            "fstp %0\n\t"
            : "=&m" (sum)
            : "m" (a), "m" (b)
            );
    return sum;
}

long double _asm_mul_80bit(long double a, long double b)
{
    long double mul = 0.;
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

void res_80(void)
{
    printf("\n80bit:\n");

    long double a = 1.232, b = 15e-5, res;
    int repeat = 10000000;

    clock_t begin, end, total = 0;

    begin = clock();
    for (int i = 0; i < repeat; i++)
        res += sum_80bit(a, b);
    end = clock();

    total = (end - begin)  ;

    printf("%s %d\n", "(SUM) std: ", total);

    begin = clock();
    for (int i = 0; i < repeat; i++)
        mul_80bit(a, b);
    end = clock();

    total = (end - begin)  ;

    printf("%s %d\n", "(MUL) std: ", total);

    begin = clock();
    for (int i = 0; i < repeat; i++)
        res += _asm_sum_80bit(a, b);
    end = clock();

    total = (end - begin)  ;

    printf("%s %d\n", "(SUM) asm: ", total);

    begin = clock();
    for (int i = 0; i < repeat; i++)
        _asm_mul_80bit(a, b);
    end = clock();

    total = (end - begin)  ;

    printf("%s %d\n", "(MUL) asm: ", total);
}

#endif