CFLAGS = -O0 -Wall -Wextra -Wpedantic -g

.phony:
all: clean run

run: main
	./$^

main: main.c unionfind.S help_methods.S
	$(CC) $(CFLAGS) -o $@ $^

clean:
	$(RM) main
