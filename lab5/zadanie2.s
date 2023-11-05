#program do zmiany trybu zaokraglania
.data
settings: .word 0
#bity odpowiedzialne za zaokroglanie to bit 11 i bit 10
round_even: .word 0x0000        #0000 0000 0000 0000
round_down: .word 0x0400        #0000 0100 0000 0000
round_up:   .word 0x0800        #0000 1000 0000 0000
round_zero: .word 0x0c00        #0000 1100 0000 0000
text1: .asciz "Zaokraglanie do parzystej: %.10f\n"
text2: .asciz "Zaokraglanie w        dol: %.10f\n"
text3: .asciz "Zaokraglanie w       gore: %.10f\n"
text4: .asciz "Zaokraglanie do      zera: %.10f\n"
number: .double 15.67432
.text

.global main

main:
push %ebp
mov %esp, %ebp

finit                           # inicjalizujemy fpu
fstcw settings                  # zapisujemy ustawienia
movw settings, %ax              # wpisujemy ustawienia do ax
andb $0b11110011, %ah           # zerujemy bit 3 i 2, bo sa
orw %ax, round_even             # to bity odpowiedzialne za tryb zaokraglania
orw %ax, round_down
orw %ax, round_up
orw %ax, round_zero

fldcw round_even                # ladujemy tryb zaokraglania do parzystej
fldl number                     # wpisujemy nasza liczbe
fsqrt                           # obliczamy pierwiastek

subl $8, %esp
fstpl (%esp)
push $text1
call printf
add $12, %esp

fldcw round_down
fldl number
fsqrt

subl $8, %esp
fstpl (%esp)
push $text2
call printf
add $12, %esp

fldcw round_up
fldl number
fsqrt

subl $8, %esp
fstpl (%esp)
push $text3
call printf
add $12, %esp

fldcw round_zero
fldl number
fsqrt

subl $8, %esp
fstpl (%esp)
push $text4
call printf
add $12, %esp

fldcw settings
leave
ret