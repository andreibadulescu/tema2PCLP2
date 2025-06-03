.PHONY: all clean run build

all: checker

build: checker

run: checker
	./checker

base64.o: base64.asm
	nasm -f elf $^ -o $@

check_base64.o: check_base64.c
	gcc -c -g -m32 $^ -o $@

checker: check_base64.o  base64.o
	gcc -m32 -no-pie -g $^ -o $@

clean:
	rm -f output/base64_*
	rm -f checker
	rm -f *.o 2> /dev/null

