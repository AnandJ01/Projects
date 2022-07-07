all: swim_mill fish pellet

swim_mill: swim_mill.c
	gcc -pthread swim_mill.c -o swim_mill

fish: fish.c
	gcc -pthread fish.c -o fish

pellet: pellet.c
	gcc -pthread pellet.c -o pellet

clean:
	rm swim_mill fish pellet