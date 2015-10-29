CC = gcc
LDFLAGS = -L/usr/lib -lglut -lGLU -lGL -lm
IFLAGS  = -I/usr/include 
CCFLAGS = -g -Wall -O2

EXENAME = p4

TARGETS = practica4.c

all: compile run

compile:
	$(CC) $(TARGETS) $(CCFLAGS) $(IFLAGS) $(LDFLAGS) -o $(EXENAME)

run:
	./$(EXENAME)
