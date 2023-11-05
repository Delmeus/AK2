#include <stdio.h>

unsigned long long time();

void reg();

void mem();

void write();

int main(){
        unsigned long long start, stop, result;

        start = time();
        reg();
        stop = time();
        if(stop - start < 0) result = start - stop;
        else result = stop - start;
        printf("Czas trwania dla rejestru: %lld\n", result);

        start = time();
        mem();
        stop = time();
        if(stop - start < 0) result = start - stop;
        else result = stop - start;

        printf("Czas trwania dla pamieci:  %lld\n", result);

        start = time();
        write();
        stop = time();
        if(stop - start < 0) result = start - stop;
        else result = stop - start;

        printf("Czas trwania dla pisania:  %lld\n", result);

        return 0;
}


