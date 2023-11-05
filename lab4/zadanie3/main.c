#include <stdio.h>

extern long vars;
extern void fun();
int varc = 7;

int main(){

        printf("Zmienna z assemblera: %ld\n", vars);
        vars += 10;
        printf("Zmienna z assemblera po dodaniu 10: %ld\n", vars);

        printf("Zmienna z C przed uzyciem w assemblerze: %d\n", varc);
        fun();
        printf("Zmienna z C po dodaniu 10 w assemblerze: %d\n", varc);
        return 0;
}

