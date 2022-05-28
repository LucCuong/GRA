# Add additional compiler flags here
CFLAGS=-O0 -g

all: main
main: main.c find_union.S
	$(CC) $(CFLAGS) -o $@ $^
clean:
	rm -f main
