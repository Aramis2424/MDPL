#include "my_sin.h"
#include <math.h>
#include "my_main.h"

void sin_asm()
{
    double res;

    printf("Standart func: sin(3.14): %.15g\n", sin(3.14));
    printf("Standart func: sin(3.141596): %.15g\n", sin(3.141596));

#ifdef FPUX87
    __asm__ 
    (
		// ST соответствует регистру - текущей вершине стека, ST(1)..ST(7) - прочие регистры
        "fldpi\n\t" // число пи (константа FPU), устанавливает число пи в вершину стека ( St(0) )
        "fsin\n\t" // Команда FSIN замещает содержимое ST значением sin(ST)
        "fstp %0\n\t"  // считать число с вершины стека в приёмик
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