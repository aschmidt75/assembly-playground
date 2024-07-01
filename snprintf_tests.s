.import streq.s
.import snprintf.s

.text
.globl _snprintf_tests

_snprintf_tests:

addi    sp, sp, -32
sw      ra, 0(sp)

addi    a0, x0, 4               # print test name
la      a1, snprintf_tests_M
ecall  



# test: pattern without fmt parts must yield identical string
L_snprintf_test_1:
la      a0, snprintf_t_buf
li      a1, 100
la      a2, snprintf_t_nopat
jal     _snprintf

add     a1, zero, a0        # a1 is =buf, a2 is the original compare str
jal     _streq              # compare
la      ra, L_snprintf_test_99   # use ra in this routine to skip to end
beqz    a0, L_snprintf_P    # if ==0, strings are equals, passed
j       L_snprintf_F        # fail otherwise, will return here


# test: empty pattern must yield empty string
L_snprintf_test_99:
la      a0, snprintf_t_buf
li      a1, 100
la      a2, snprintf_t_empty
jal     _snprintf

add     a1, zero, a0        # a1 is =buf, a2 is the empty compare str
jal     _streq              # compare
la      ra, L_snprintf_tests_done   # use ra in this routine to skip to end
beqz    a0, L_snprintf_P    # if ==0, strings are equals, passed
j       L_snprintf_F        # fail otherwise, will return here


L_snprintf_tests_done:
addi    a0, x0, 4
la      a1, snprintf_tests_NEWL
ecall  

lw      ra, 0(sp)   # restore stack frame
addi    sp, sp, 32

ret                 # exit


L_snprintf_F:
addi    a0, x0, 4
la      a1, snprintf_tests_F
ecall  
ret

L_snprintf_P:
addi    a0, x0, 4
la      a1, snprintf_tests_P
ecall  
ret


.data
snprintf_tests_M:
.asciiz "snprintf_tests: "
snprintf_tests_F:
.asciiz "F"
snprintf_tests_P:
.asciiz "P"
snprintf_tests_NEWL:
.byte 13,10,0
snprintf_t_buf:
.space 256
snprintf_t_empty:
.byte 0
snprintf_t_nopat:
.asciiz "SimpleTestWithoutFmt"