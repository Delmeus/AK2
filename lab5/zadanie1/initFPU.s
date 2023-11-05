.data

.text

.global initFPU
initFPU:

push %ebp
mov %esp, %ebp

FINIT

leave
ret
