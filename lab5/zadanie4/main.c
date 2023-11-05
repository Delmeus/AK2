#include <stdio.h>

void serial();

void parallel();

void initFPU();

unsigned long long time();

int main(){
	unsigned long long start, stop, result;

	initFPU();

	start = time();
	serial();
	stop = time();
	if(stop - start < 0)
	       	result = start - stop;
	else
	       	result = stop - start;

	printf("Czas trwania operacji szeregowych: %lld\n", result);
	
	initFPU();

	start = time();
	parallel();
	stop = time();
	if(stop - start < 0)
	       	result = start - stop;
	else
	       	result = stop - start;

	printf("Czas trwania operacji rownoleglych: %lld\n", result);


	return 0;
}
