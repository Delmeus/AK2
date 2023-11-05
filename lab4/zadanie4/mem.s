.global mem

.data
pamiec: .byte 1

.text

mem:

push %eax

movl (pamiec), %eax
add $1, %eax
movl %eax, (pamiec)

pop %eax

ret

