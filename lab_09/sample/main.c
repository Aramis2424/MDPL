#include "my_main.h"
#include "for_80.h"
#include "for_32_64.h"
#include "my_sin.h"


#define OK 0


int main()
{
    sin_asm();

    time_test_float();

    time_test_double();

    time_test_float80();
    
    return OK;
}
