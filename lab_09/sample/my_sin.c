#include "my_sin.h"
#include <math.h>
#include "my_main.h"

void sin_asm()
{
    double res;

    printf("Simple test sin(3.14): %.15g\n", sin(3.14));
    printf("Simple test sin(3.141596): %.15g\n", sin(3.141596));

#ifdef FPUX87
    __asm__ 
    (
        "fldpi\n\t"
        "fsin\n\t"
        "fstp %0\n\t" 
        ::"m"(res));
    printf("Sin test fpu: %.15g\n", res);
#endif

    printf("\n\nSimple test sin(3.14 / 2): %.15g\n", sin(3.14 / 2));
    printf("Simple test sin(3.141596 / 2): %.15g\n", sin(3.141596 / 2));

#ifdef FPUX87
    double res1 = 0.0;
    __asm__ //__volatile__
    (
        "fldpi\n\t"
        "fld1\n\t"
        "fld1\n\t"
        "faddp\n\t"
        "fdiv\n\t"
        "fsin\n\t"
        "fstp %0\n\t"
        : "=m"(res1));
    printf("Sin(pi / 2) test fpu: %g\n", res1);
#endif
}