#program wywolujacy blad dzielenia przez 0 lub blad utraty precyzji
.data
value: .long 1
zero: .float 3
output: .ascii "Status bledu %d\n"
outputLen = .-output
.text

.global main

main:

push %ebp
mov %esp, %ebp

finit
fild value
fdiv zero

fstsw %ax
mov %ax, %dx
xor %dh, %dh
cmp $0b00000100, %dl
jz print_error

fcos
fstsw %ax
mov %ax, %dx
xor %dh, %dh
cmp $0b00100000, %dl
jnz no_error

print_error:
mov $output, %eax
push %dx
push %eax
call printf
add $6, %esp

no_error:
leave 
ret
