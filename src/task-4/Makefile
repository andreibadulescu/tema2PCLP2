.PHONY: all clean run build

all: checker

build: checker

run: checker
	./checker

sudoku.o: sudoku.asm
	nasm -f elf $^ -o $@

check_sudoku.o: check_sudoku.c
	gcc -c -g -m32 -no-pie $^ -o $@

checker: sudoku.o check_sudoku.o
	gcc -m32 -g -no-pie $^ -o $@
	rm *.o

clean:
	rm -f checker
	rm -f check_sudoku.o
	rm -f sudoku.o
	rm -f output/test_*