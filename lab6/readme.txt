Program written fully in fixed-point arithmetics.

Compile command:
gcc -msse4.1 -m32 /usr/include/png.h png.c -lpng timer.s -O3 -o p

Run:
./p car.png
