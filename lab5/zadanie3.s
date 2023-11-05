#program do zmiany trybu precyzji
.data
settings: .word 0
output64: .asciz "Dla 64: %.60f\n"
output24: .asciz "Dla 24: %.60f\n"
prec64: .word 0x0300    # 0000 0011 0000 0000
prec24: .word 0x0000    # 0000 0000 0000 0000
liczba: .double 420
.text

.global main

main:

push %ebp
mov %esp, %ebp

finit
fstcw settings          # zapisujemy aktualne ustawienia
movw settings,%ax       # wpisujemy ustawienia do ax
andb $0b11111100, %ah   # zerujemy dwa ostatnie bity ah, bo sa to bity
                        # ktore odpowiadaja za precyzje FPU
orw %ax, prec64         # ustawiamy odpowiednio bity odpowiedzialne za precyzje
orw %ax, prec24
fldcw prec24            # ladujemy precyzje 24 bity
fldl liczba
fsqrt

subl $4,%esp            # rezerwujemy miejsce na stosie
fstpl (%esp)
push $output24
call printf
add $8, %esp

fldcw prec64
fldl liczba
fsqrt

subl $8, %esp
fstpl (%esp)
push $output64
call printf
add $12, %esp

fldcw settings           # przywracamy ustawienia

leave
ret