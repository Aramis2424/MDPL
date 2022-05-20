#include "vector_sum.h"

static void c_vector_sum(const vector_t a, const vector_t b, vector_t c)
{
	for (int i = 0; i < 4; i++)
		c[i] = a[i] + b[i];
}

static void asm_vector_sum(const vector_t *a, const vector_t *b, vector_t *c)
{
    __asm__(".intel_syntax noprefix\n\t"
		    "movaps xmm0, %1\n\t" //Перемещение выровненных 128 бит (т.е. как раз 4 float`а в нашем массиве)
			"movaps xmm1, %2\n\t"
			"addps xmm0, xmm1\n\t" //Векторное сложение Float
			"movaps %0, xmm0\n\t"
	:"=m"(*c)
    :"m"(*a), "m"(*b)
    :"xmm0", "xmm1");
}

static void print_vector(const vector_t vec, int len)
{
	printf("(");
	for (int i = 0; i < len; i++)
		printf("%5.2lf; ", vec[i]);
	printf(")\n");
}

void testing_sum(void)
{
    printf("\nTest_1\n");
    {
        vector_t a = {-1, 2, 5, -4};
        vector_t b = {3, 6, -7, 3};
		vector_t c = {0, 0, 0, 0};
		puts("Start values of vectors:");
		printf("a = ");
		print_vector(a, LEN);
		printf("b = ");
		print_vector(b, LEN);
		printf("c = ");
		print_vector(c, LEN);
		
		printf("\nASM func:\n c = ");
		asm_vector_sum(&a, &b, &c);
		print_vector(c, LEN);

		printf("\nC func:\n c = ");
        c_vector_sum(a, b, c);
		print_vector(c, LEN);
    }
	
	printf("\nTest_2\n");
    {
        vector_t a = {-1, 2, 5, -4};
        vector_t b = {1, -2, -5, 4};
		vector_t c = {0, 0, 0, 0};
		puts("Start values of vectors:");
		printf("a = ");
		print_vector(a, LEN);
		printf("b = ");
		print_vector(b, LEN);
		printf("c = ");
		print_vector(c, LEN);
		
		printf("\nASM func:\n c = ");
		asm_vector_sum(&a, &b, &c);
		print_vector(c, LEN);

		printf("\nC func:\n c = ");
        c_vector_sum(a, b, c);
		print_vector(c, LEN);
    }
	
	printf("\nTest_3\n");
    {
        vector_t a = {-1.5, -2.3, 5, -4};
        vector_t b = {3, -7.7, 5.5, 3.1};
		vector_t c = {0, 0, 0, 0};
		puts("Start values of vectors:");
		printf("a = ");
		print_vector(a, LEN);
		printf("b = ");
		print_vector(b, LEN);
		printf("c = ");
		print_vector(c, LEN);
		
		printf("\nASM func:\n c = ");
		asm_vector_sum(&a, &b, &c);
		print_vector(c, LEN);

		printf("\nC func:\n c = ");
        c_vector_sum(a, b, c);
		print_vector(c, LEN);
    }

}

void time_measuring_sum(void)
{
    printf("\n");
	printf("\nTime test_1\n");
	{
		clock_t begin, end;
    
		vector_t a = {101, 202, 303, 404};
		vector_t b = {505, 606, 707, 808};
		vector_t c;
		
		printf("Time result ASM: ");
		begin = clock();
		for (size_t i = 0; i < REPEATS; i++)
			asm_vector_sum(&a, &b, &c);
		end = clock();
		printf("%.3g sec\n", (double)(end - begin) / CLOCKS_PER_SEC / REPEATS);

		printf("Time result C: ");
		begin = clock();
		for (size_t i = 0; i < REPEATS; i++)
			c_vector_sum(a, b, c);
		end = clock();
		printf("%.3g sec\n", (double)(end - begin) / CLOCKS_PER_SEC / REPEATS);
	}
	
	printf("\nTime test_2\n");
	{
		clock_t begin, end;
    
		vector_t a = {101.123, 202.321, 303.555, 404.654};
		vector_t b = {505.111, 606.222, 707.333, 808.301};
		vector_t c;
		
		printf("Time result ASM: ");
		begin = clock();
		for (size_t i = 0; i < REPEATS; i++)
			asm_vector_sum(&a, &b, &c);
		end = clock();
		printf("%.3g sec\n", (double)(end - begin) / CLOCKS_PER_SEC / REPEATS);

		printf("Time result C: ");
		begin = clock();
		for (size_t i = 0; i < REPEATS; i++)
			c_vector_sum(a, b, c);
		end = clock();
		printf("%.3g sec\n", (double)(end - begin) / CLOCKS_PER_SEC / REPEATS);
	}
	
	printf("\nTime test_3\n");
	{
		clock_t begin, end;
    
		vector_t a = {1019.9, 2028.8, 3039.9, 4048.8};
		vector_t b = {5059.8, 6069.7, 7078.9, 8088.7};
		vector_t c;
		
		printf("Time result ASM: ");
		begin = clock();
		for (size_t i = 0; i < REPEATS; i++)
			asm_vector_sum(&a, &b, &c);
		end = clock();
		printf("%.3g sec\n", (double)(end - begin) / CLOCKS_PER_SEC / REPEATS);

		printf("Time result C: ");
		begin = clock();
		for (size_t i = 0; i < REPEATS; i++)
			c_vector_sum(a, b, c);
		end = clock();
		printf("%.3g sec\n", (double)(end - begin) / CLOCKS_PER_SEC / REPEATS);
	}
}
