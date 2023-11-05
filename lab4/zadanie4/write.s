.global write

.data
word: .ascii "Hello, from assembly\n"
msgLen = .-word

.text

write:

pushal

mov $4, %eax
mov $1, %ebx
mov $word, %ecx
mov $msgLen, %edx
int $0x80

popal

ret


