.import streq.s

.text

.globl _streq_tests
_streq_tests:

addi    sp, sp, -32     # save stack frame
sw      ra, 0(sp)

addi    a0, x0, 4               # print test name
la      a1, streq_tests_M
ecall  

L_1:                            # test case 1
la      a1, test1a
la      a2, test1a
jal     _streq

la      a1, test1r
lw      a2, 0(a1)
sub     a1, a0, a2
beqz    a1, L_1P

L_1F:
addi    a0, x0, 4
la      a1, streq_tests_F
ecall  
j       L_2

L_1P:
addi    a0, x0, 4
la      a1, streq_tests_P
ecall  
j       L_2


L_2:
la      a1, test2a
la      a2, test2a
jal     _streq

la      a1, test2r
lw      a2, 0(a1)
sub     a1, a0, a2
beqz    a1, L_2P

L_2F:
addi    a0, x0, 4
la      a1, streq_tests_F
ecall  
j       L_3

L_2P:
addi    a0, x0, 4
la      a1, streq_tests_P
ecall  
j       L_3


L_3:
la      a1, test2a
la      a2, test3b
jal     _streq

la      a1, test3r
lw      a2, 0(a1)
sub     a1, a0, a2
beqz    a1, L_3P

L_3F:
addi    a0, x0, 4
la      a1, streq_tests_F
ecall  
j       L_4

L_3P:
addi    a0, x0, 4
la      a1, streq_tests_P
ecall  
j       L_4

L_4:

L_streq_tests_done:
addi    a0, x0, 4
la      a1, streq_tests_NEWL
ecall  

lw      ra, 0(sp)   # restore stack frame
addi    sp, sp, 32

ret

.data
streq_tests_M:
.asciiz "streq_tests: "
streq_tests_F:
.asciiz "F"
streq_tests_P:
.asciiz "P"
streq_tests_NEWL:
.byte 13,10

# test cases data
test1a:
.word 0
test1r:
.word 0

test2a:
.asciiz "foobar"
test2r:
.word 0

test3b:
.asciiz "foopar"
test3r:
.word 1
