.data
f1: .float 5.4
f2: .float 6.896
f3: .float 67.43
f4: .float 3.1485
f5: .float 7.4
f6: .float 8.5
.text

.global parallel

parallel:
push %ebp
mov %esp, %ebp

FLD f1
FLD f2
FLD f3
FLD f4
FLD f5
FLD f6

FADD (f1)
FADD (f2)
FADD (f3)
FADD (f4)
FADD (f5)
FADD (f6)

leave
ret


