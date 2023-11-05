.data

.text

.global timer

timer:
push %ebx

xor %eax, %eax
cpuid
rdtsc

pop %ebx

ret
