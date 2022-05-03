#include "for_80.h"
#include "my_main.h"
#include <time.h>

// static int64_t tick(void)
// {
//     uint32_t high, low;
//     __asm__ __volatile__(
//         "rdtsc\n"
//         "movl %%edx, %0\n"
//         "movl %%eax, %1\n"
//         : "=r"(high), "=r"(low)::"%rax", "%rbx", "%rcx", "%rdx");

//     uint64_t clocks = ((uint64_t)high << 32) | low;

//     return clocks;
// }

void sum_float80(__float80 a, __float80 b)
{
    __float80 res;
    for (int i = 0; i < 10000; i++)
        res = a + b;
}

void mult_float80(__float80 a, __float80 b)
{
    __float80 res;
    for (int i = 0; i < 10000; i++)
        res = a * b;
}

void sum_float80_asm(__float80 a, __float80 b)
{
    __float80 res;
     for (int i = 0; i < 10000; i++)
        __asm__(
            "fld %2\n\t"
            "fld %1\n\t"

            "faddp\n\t"

            "fstp %0"
            : "=m"(res)
            : "m"(a), "m"(b)
            );
}

void mult_float80_asm(__float80 a, __float80 b)
{
    __float80 res;
    for (int i = 0; i < 10000; i++)
         __asm__(
            "fld %2\n\t"
            "fld %1\n\t"

            "fmulp\n\t"

            "fstp %0"
            : "=m"(res)
            : "m"(a), "m"(b)
            );
}

void time_test_float80()
{
    __float80 a = 1.23, b = 4.56;
    printf("__float80 bit tests: \n");

    int start = clock();
    sum_float80(a, b);
    int end = clock();
    printf("Sum test: %d\n", end - start);

    start = clock();
    mult_float80(a, b);
    end = clock();
    printf("Mult test: %d\n", end - start);   

    start = clock();
    sum_float80_asm(a, b);
    end = clock();
    printf("Sum_asm test: %d\n", end - start);

    start = clock();
    mult_float80_asm(a, b);
    end = clock();
    printf("Mult_asm test: %d\n", end - start);  
}