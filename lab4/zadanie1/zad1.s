.data
input_short: .space 2
input_char: .space 1
format_char: .asciz "%s"
format_short: .asciz "%hd"
output_short: .asciz "Wprowadzony short: %hd\n"
output_string: .asciz "Wprowadzony short: %hd\nWprowadzony char: %s\n"
.section .text

call main
mov $1, %eax
xor %ebx, %ebx
int $0x80

.globl main
main:

push %ebp
mov %esp, %ebp

mov $format_short, %eax
mov $input_short, %edx
push %edx
push %eax
call scanf
add $8, %esp

mov $format_char, %eax
mov $input_char, %edx
push %edx
push %eax
call scanf
add $8, %esp

mov $output_string, %eax
movw input_short, %dx
movl $input_char, %ecx
push %ecx
push %edx
push %eax
call printf
add $12, %esp


leave
ret
        
