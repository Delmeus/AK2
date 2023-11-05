.global time

.text

time:
push %ebx

xor %eax, %eax
cpuid
rdtsc

pop %ebx
ret


