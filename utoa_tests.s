.import utoa.s
.import streq.s
.text

.globl _utoa_tests
_utoa_tests:

addi    sp, sp, -32     # save stack frame
sw      ra, 0(sp)

addi    a0, x0, 4               # print test name
la      a1, utoa_tests_M
ecall  

L_1:                            # test case 1
la      a0, testbuf
lw      a1, test1val
jal     _utoa
la      a1, testbuf
la      a2, test1res

call    _streq

beqz    a0, L_1P

L_1F:
addi    a0, x0, 4
la      a1, utoa_tests_F
ecall  
j       L_2

L_1P:
addi    a0, x0, 4
la      a1, utoa_tests_P
ecall  
j       L_2


L_2:                            # test case 1
la      a0, testbuf
lw      a1, test2val
jal     _utoa
la      a1, testbuf
la      a2, test2res

call    _streq

beqz    a0, L_2P

L_2F:
addi    a0, x0, 4
la      a1, utoa_tests_F
ecall  
j       L_utoa_tests_done

L_2P:
addi    a0, x0, 4
la      a1, utoa_tests_P
ecall  
j       L_utoa_tests_done


L_utoa_tests_done:
addi    a0, x0, 4
la      a1, utoa_tests_NEWL
ecall  

lw      ra, 0(sp)   # restore stack frame
addi    sp, sp, 32

ret

.data
utoa_tests_M:
.asciiz "utoa_tests: "
utoa_tests_F:
.asciiz "F"
utoa_tests_P:
.asciiz "P"
utoa_tests_NEWL:
.byte 13,10,0

# test cases data
testbuf:
.byte   128
test1val:
.word 0
test1res:
.asciiz "0"
test2val:
.word 987654321
test2res:
.asciiz "987654321"