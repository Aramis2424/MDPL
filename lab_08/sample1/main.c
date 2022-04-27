#include <stdio.h>
#include <string.h>


#define N 100

int asm_len(const char *str)
{
    int len = 0;
    const char *copy = str;

    __asm__(
        // "xor %%al, %%al"
        "mov $0, %%al\n\t" // поместить 0 в al // "xor %%al, %%al"
        "mov %1, %%rdi\n\t" // из первой переменной в rdi
        "mov $0xffffffff, %%ecx\n\t" // в ecx помещаем такую цифру
        "repne scasb\n\t" // повторять операцию, пока флаг ZF показывает "не равно или не ноль" 
        // SCASB Сканирование строки байт
        "not %%ecx\n\t" // инвертируем 
        "dec %%ecx\n\t" // -1
        "mov %%ecx, %0" // передаем то, что получили в 0 переменную
        : "=r"(len) // выходные операнды
        : "r"(copy) // входные операнды
        // то есть переменная copy разместиться в каком-то регистре общего назначения
        // (задано символом r), перед выполнением кода вставки
        : "%ecx", "%rdi", "%al"
    );
    return len;
}

void strcopy(char *dest, char *src, int len);

void tests_for_strlen()
{
    char s[] = "12345";
    printf("String for test: \"%s\"\nAsm_len = %d\nStrlen = %zu\n", s, asm_len(s), strlen(s));
    
    char s1[10] = "1";
    printf("String for test: \"%s\"\nAsm_len = %d\nStrlen = %zu\n", s1, asm_len(s1), strlen(s1));
}

void tests_for_strcopy()
{
    char sourse[] = "qwertyuiopasdfg";
    char destination[N] = "0123456789";
    int len = 0;

    printf("Test 1 (different source and destination)\n");
    len = 4;
    printf("Data for ests: \nsourse = \"%s\", destination = \"%s\"\nSymbols copied = %d\n", 
    sourse, destination, len);
    // char * strcpy( char * destptr, const char * srcptr );
    // Функция копирует Си-строку srcptr, 
    // включая завершающий нулевой символ в строку 
    //назначения, на которую ссылается указатель destptr
    strcopy(destination, sourse, len);
    printf("Result: \"%s\"\n", destination);
    printf("------------------------\n");


    printf("Test 2 (destination = source + 6)\n");
    printf("String for tests: \nsourse = \"%s\", destination = \"%s\"\n", sourse, sourse + 6);
    len = 5;
    strcopy(sourse + 6, sourse, len);
    printf("Result: \"%s\"\n", sourse);
    printf("------------------------\n");

    printf("Test 3 (source = destination + 4)\n");
    printf("String for tests: \nsourse = \"%s\", destination = \"%s\"\n", sourse, sourse + 4);
    len = 5;
    strcopy(sourse, sourse + 4, len);
    printf("Result: \"%s\"\n", sourse);
    printf("------------------------\n");
}

int main()
{
    printf("TESTS FOR LEN!!!\n");
    tests_for_strlen();
    printf("\nTESTS FOR COPY!!!\n");
    tests_for_strcopy();
}
