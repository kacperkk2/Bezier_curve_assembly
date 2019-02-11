CC=g++
CFLAGS=-Wall

all: bezier.o bezier_asm.o
	$(CC) $(CFLAGS) bezier.o -lSDL2 bezier_asm.o -o bezier
bezier.o: bezier.cpp
	$(CC) bezier.cpp -lSDL2 -c -o bezier.o
bezier_asm.o: bezier_asm.s
	nasm -f elf64 -o bezier_asm.o bezier_asm.s
clean:
	rm -f *.o
