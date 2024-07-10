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

mv      a1, a0              # a1 is =buf, a2 is the original compare str
jal     _streq              # compare
la      ra, L_snprintf_test_2   # use ra in this routine to skip to next
beqz    a0, L_snprintf_P    # if ==0, strings are equals, passed
j       L_snprintf_F        # fail otherwise, will return here


# test: pattern with escape fmt parts must yield correct string
L_snprintf_test_2:
la      a0, snprintf_t_buf
li      a1, 100
la      a2, snprintf_t_pat_esc
jal     _snprintf

mv      a1, a0
la      a2, snprintf_t_pat_esc_r
jal     _streq              
la      ra, L_snprintf_test_3  
beqz    a0, L_snprintf_P    
j       L_snprintf_F        

# test: pattern with char fmt parts must yield correct string
L_snprintf_test_3:
addi    sp, sp, -8
li      a1, 0x30          # 0x30 = "0", put on stack
sb      a1, 0(sp)
li      a1, 0x31          # "1"
sb      a1, 1(sp)
li      a1, 0x32          # "2"
sb      a1, 2(sp)
la      a0, snprintf_t_buf
li      a1, 100
la      a2, snprintf_t_pat_char
jal     _snprintf
addi    sp, sp, 8

mv      a1, a0
la      a2, snprintf_t_pat_char_r
jal     _streq              
la      ra, L_snprintf_test_4  
beqz    a0, L_snprintf_P    
j       L_snprintf_F        

# test: must not produce a result longer than given buffer capacity
  # test: for static string
L_snprintf_test_4:
la      a0, snprintf_t_buf
li      a1, 10                      # cut buffer capacity
la      a2, snprintf_t_nopat
jal     _snprintf

mv      a1, a0
la      a2, snprintf_t_nopat_r_cap
jal     _streq              
la      ra, L_snprintf_test_5   
beqz    a0, L_snprintf_P    
j       L_snprintf_F        

  # test: when last fmt part would break the capacity (string,char,escape,...)
L_snprintf_test_5:
la      a0, snprintf_t_buf
li      a1, 8                      # cut buffer capacity, 8 in this case to check if fmt subroutine adheres to length check
la      a2, snprintf_t_pat_esc
jal     _snprintf

mv      a1, a0
la      a2, snprintf_t_pat_esc_r_cap
jal     _streq              
la      ra, L_snprintf_test_6   
beqz    a0, L_snprintf_P    
j       L_snprintf_F        

# test: format with %s in pattern
L_snprintf_test_6:
la      a0, snprintf_t_buf
la      a2, snprintf_t_pat_string
addi    sp, sp, -8
la      a1, snprintf_t_pat_string_p1    # put arg on stack
sb      a1, 0(sp)
li      a1, 100                         # buffer length
jal     _snprintf
addi    sp, sp, 8

mv      a1, a0
la      a2, snprintf_t_pat_string_r
jal     _streq              
la      ra, L_snprintf_test_99   
beqz    a0, L_snprintf_P    
j       L_snprintf_F        

# test: format with %s in pattern but capacity less than required

# test: complex example

# test: returns length of resulting string

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
snprintf_t_szbuf:
.word 256
snprintf_t_empty:
.byte 0
snprintf_t_nopat:
.asciiz "SimpleTestWithoutFmt"
snprintf_t_nopat_r_cap:             # test for cap=10 (\0 is 10th byte)
.asciiz "SimpleTes"
snprintf_t_pat_esc:
.asciiz "%%Simple%%Escape%%"
snprintf_t_pat_esc_r:
.asciiz "%Simple%Escape%"
snprintf_t_pat_esc_r_cap:
.asciiz "%Simple"
snprintf_t_pat_char:
.asciiz "%cSimple%cPat%c"
snprintf_t_pat_char_r:
.asciiz "0Simple1Pat2"
snprintf_t_pat_string:
.asciiz "Simple%sPattern"
snprintf_t_pat_string_p1:
.asciiz "Test"
snprintf_t_pat_string_r:
.asciiz "SimpleTestPattern"

