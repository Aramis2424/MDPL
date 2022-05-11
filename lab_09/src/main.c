#include "defines.h"

int main(void)
{
    res_32();
    res_64();
    #ifndef X87
    res_80();
    #endif

    sin_cmp();

    return 0;
}