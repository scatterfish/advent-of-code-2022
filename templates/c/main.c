#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

int main() {
	
	FILE* file_p;
	file_p = fopen("input.txt", "r");
	if (file_p == NULL) {
		return EXIT_FAILURE;
	}
	
	fclose(file_p);
	
	return EXIT_SUCCESS;
}
