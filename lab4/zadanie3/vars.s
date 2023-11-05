.data

.global vars
vars: .long 42

.extern varc
.global fun

.text

fun:
push %ebp
mov %esp, %ebp

addl $10, (varc)

pop %ebp
ret


