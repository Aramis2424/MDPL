#include <stdio.h>
#include <assert.h>
#include <time.h>

#define LEN 4
#define REPEATS 10000000

typedef float vector_t[LEN]; // 128 бит

void testing_sum(void);
void time_measuring_sum(void);
