.import strlen.s
.import utoa.s
.import snprintf.s

.text
main:

la a0, buf
la t0, len
lw a1, 0(t0)
la a2, fstr
call _snprintf

addi a0, x0, 10             # exit
ecall

.data
buf:
.asciiz "01234567890123456789012345678901234567890123456789"
len:
.word 5
fstr:
.asciiz "ab%%cd"