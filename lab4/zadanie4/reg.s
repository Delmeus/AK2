.global reg

.text

reg:

push %eax

mov $1, %eax
add $1, %eax

pop %eax

ret

