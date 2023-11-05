.data
f1: .float 5.4
f2: .float 6.896
f3: .float 67.43
f4: .float 3.1485
f5: .float 7.4
f6: .float 65.2
.text

.global serial

serial:
push %ebp
mov %esp, %ebp

FLD f1
FLD f2
FLD f3
FLD f4
FLD f5
FLD f6

FADD (f1)
FADD (f1)
FADD (f1)
FADD (f1)
FADD (f1)
FADD (f1)


leave
ret

