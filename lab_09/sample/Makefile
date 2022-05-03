CC := gcc
ASM := nasm
FLAGS := -std=c99 -w -o0 #-masm=intel

SRCS := $(wildcard *.c)
OBJS := $(SRCS:%.c=%.o)

app.exe: FLAGS += -DFPUX87 -m80387 -DASMTEST
app.exe: $(OBJS) *.h
	$(CC) $(FLAGS) $(OBJS) -o  $@
	rm -f *.o

asm_my_sin:
	gcc -E my_sin.c -o my_sin.i
	gcc -S my_sin.i -o my_sin.s
	rm -f *.i

asm_32_64:
	gcc -E for_32_64.c -DFPUX87 -m80387 -DASMTEST -o for_32_64.i
	gcc -S for_32_64.i -DFPUX87 -m80387 -DASMTEST -o for_32_64.s
	rm -f *.i

asm_80:
	gcc -E for_80.c -DFPUX87 -m80387 -DASMTEST -mfpmath=387 -o for_80.i
	gcc -S for_80.i -DFPUX87 -m80387 -DASMTEST -mfpmath=387 -o for_80.s
	rm -f *.i

%.o: %.c *.h 
	$(CC) $(FLAGS) -c $< -o $@
clean:
	rm -f *.o *.exe 