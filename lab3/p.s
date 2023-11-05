EXIT = 1
SYS = 0x80
WRITE = 4
STDOUT = 1
len = 128
.section .data
size: .long 128
sieve: .space 128

.section .text
.global _start
_start:
mov size, %ecx          #wpisujemy size do ecx aby uzyc go jako
                        #licznika przy inicjalizacji sita

xor %edx, %edx
movb $0xf6, sieve(,%edx,) #wpisujemy f6 na pierwszy bajt, aby
inc %edx                  #0 i 1 byly ustawione na 0

init_sieve:             #inicjalizujemy sito - kazdy bit na 1
movb $0xff, sieve(,%edx,)
inc %edx
loop init_sieve         #loop wykorzystuje ecx jako licznik i
                        #dekrementujac je i porownujac do 0
xor %edx, %edx          #edx bedzie przechowywac indeks
xor %ebx, %ebx          #bx bedzie uzywane do odwolywania sie do
                        #kolejnych bitow w bajcie
loop1:
xor %eax, %eax          #zerujemy eax
movb sieve(,%edx,), %al #wczytujemy bajt do al
cmp $0x8, %bx
jge iterate             #jezeli przeszlismy wszystkie 8 bitow to
                        #sprawdzamy warunek zakonczenia petli i
                        #iterujemy licznik
bt %ax, %bx             #sprawdzamy czy bit wskazywany przez bx
inc %bx                 #jest ustawiony, jesli tak liczba nie jest
jnc loop1               #pierwsza, ax i bx uzyte zamiast al i bl
pushal                  #w zwiazku z wymaganiami rozkazu bt

mov %edx, %ecx
mov %edx, %eax          #inicjalizacja licznikow do petli wewnetrznej
push %edx
mul %ecx
pop %edx                #i = p * p
xor %ebx, %ebx

loop2:                  #jesli licznik bedzie >= 8, to nalezy odpowiednio odwolac sie do tablicy
add %edx, %eax
cmp size, %eax
jle get_index           #jezeli licznik > n to zakoncz petle wewnetrzna
popal
jmp loop1

get_index:
cmp $0x8, %eax
jl set_zero             #jezeli mniej niz 8 to mamy indeks interesujacego nas bitu
inc %ebx
sub $0x8, %eax
jmp get_index
set_zero:
pushal
xor %ecx, %ecx
movb sieve(,%ebx,), %cl
btr %ecx, %eax          #ustawiamy bit na pozycji wskazywanej przez eax na zero
popal
jmp loop2


iterate:                #zwieksz indeks
inc %edx
push %edx
mov %edx, %ecx
mov %edx, %eax
mul %ecx
xor %ebx, %ebx
mov %edx, %ecx
pop %edx
#cmp $0, %ecx           #jezeli liczba przekracza 32 bity to koniec petli
cmp size, %eax
jl loop1


mov $WRITE, %eax
mov $STDOUT, %ebx
mov sieve, %ecx
mov size, %edx
int $SYS

end:
mov $EXIT, %eax
mov $0, %ebx
int $SYS