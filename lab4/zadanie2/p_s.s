.global p_s

.text

p_s:
push %ebx

xor %eax, %eax
cpuid
rdtsc

pop %ebx
ret


