.import strlen.s

.text

.globl _strlen_tests
_strlen_tests:

addi    sp, sp, -32     # save stack frame
sw      ra, 0(sp)

addi    a0, x0, 4               # print test name
la      a1, strlen_tests_M
ecall  

L_1:                            # test case 1
la      a0, teststr1
jal     _strlen
la      a1, testres1
lw      a2, 0(a1)
sub     a1, a0, a2
beqz    a1, L_1P

L_1F:
addi    a0, x0, 4
la      a1, strlen_tests_F
ecall  
j       L_2

L_1P:
addi    a0, x0, 4
la      a1, strlen_tests_P
ecall  
j       L_2

L_2:                            # test case 2
la      a0, teststr2
jal     _strlen
la      a1, testres2
lw      a2, 0(a1)
sub     a1, a0, a2
beqz    a1, L_2P

L_2F:
addi    a0, x0, 4
la      a1, strlen_tests_F
ecall  
j       L_3

L_2P:
addi    a0, x0, 4
la      a1, strlen_tests_P
ecall  
j       L_3

L_3:
# none

L_strlen_tests_done:
addi    a0, x0, 4
la      a1, strlen_tests_NEWL
ecall  

lw      ra, 0(sp)   # restore stack frame
addi    sp, sp, 32

ret

.data
strlen_tests_M:
.asciiz "strlen_tests: "
strlen_tests_F:
.asciiz "F"
strlen_tests_P:
.asciiz "P"
strlen_tests_NEWL:
.byte 13,10,0

# test cases data
teststr1:
.asciiz ""
testres1:
.word 0
teststr2:
.asciiz "Hello!"
testres2:
.word 6