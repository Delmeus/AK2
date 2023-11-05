EXIT = 1
WRITE = 4
READ = 3
STDIN = 0
STDOUT = 1

SYS = 0x80

len = 1

.data
bufor: .space len

.text

.global _start

_start:
#funkcja czytajaca bajty
mov $READ, %eax
mov $STDIN, %ebx
mov $bufor, %ecx
mov $len, %edx
int $SYS

cmp $0x0, %eax
je koniec               #jesli funckja read zwraca 0 to skocz na koniec programu

mov $0x1, %cl           #ustawiamy cl (najmniej znaczacy bajt ecx) na 1, poniewaz bedziemy uzywac go jako licznika petli
mov (bufor), %ebx       #wpisujemy zawartosc bufora do ebx

odwroc:
mov %ebx, %eax          #wpisujemy do eax zawartosc ebx
and $0x1, %eax          #wyodrebniamy najmniej znaczacy bit eax
ror %cl,  %eax          #rotujemy eax w prawo o licznik petli, co ustawia bit na odpowiedniej pozycji
or  %eax, %edx          #zapisujemy do edx bit otrzymany w eax
shr $0x1, %ebx          #przesuwamy ebx o jeden bit aby moc pozniej pobrac kolejny bit do eax
inc %cl                 #zwiekszamy licznik petli
cmp $0x8, %cl           #porownujemy licznik do 8
jbe odwroc              #jesli mniejsze lub rowne to skocz do odwroc

shr $0x18, %edx         #przesuwamy bity w edx o 24 w prawo, poniewaz chcemy miec wynik na najmlodszym bajcie
                        #wiec nalezy przesunac caly bajt o 3 bajty w 4 bajtowym rejestrze
                        #operacja ta jest wymagana poniewaz uzywajac ror umiescilismy bity w najbardziej znaczacym bajcie

mov %edx, (bufor)       #wpisanie przetworzonego bajtu do bufora

#funkcja wypisujaca bajty
mov $WRITE, %eax
mov $STDOUT, %ebx
mov $bufor, %ecx
mov $len, %edx
int $SYS
jmp _start              #bezwarunkowy skok do _start aby pobrac kolejny bajt

koniec:
mov $EXIT, %eax
mov $0x0, %ebx
int $SYS