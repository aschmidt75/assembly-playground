.text

.globl _utoa
# _utoa converts a 32bit signed word into asciiz
# in: 
# - a0: addr of (target) buffer
# - a1: value to convert
# out:
# - a0: length of string
# how:
# - loop while / and % by ten, put all on stack as ascii chars
# - determine length of digits processed = length of string
# - walk back on stack, writing to buffer
# - return number of digits processed = strlen 
_utoa:
addi    sp, sp, -32     # save stack frame
sw      s3, 20(sp)
sw      s2, 16(sp)
sw      s1, 12(sp)
sw      s0, 8(sp)
sw      ra, 4(sp)
sw      fp, 0(sp)
addi    fp, sp, 32 

L_utoa_setup:
addi    s0, x0, 10      # in loop, / and % by 10
addi    s3, x0, 0       # s3 = counter of digits processed

L_utoa_while_1:
remu    s2, a1, s0      # s1 = a1/10, s2 = a1 % %10
divu    s1, a1, s0

addi    sp, sp, -1      # push remainder to stack, as char
addi    s2, s2, 48      # to ascii, 48='0'
sb      s2, 0(sp)
addi    s3, s3, 1       # we processed 1 digit

addi    a1, s1, 0       # a1 = s1, loop with the division result
bnez    s1, L_utoa_while_1    # if division result != 0, we have digits to come

L_utoa_while_1_done:    # all digits processed

add     s0, x0, a0      # pop from stack in reverse order, write to buf; s0=buf ptr
add     a0, x0, s3      # already save string length in a0 as return
L_utoa_for_2:
lb      s1, 0(sp)       # load char from stack
sb      s1, 0(s0)       # and write to buf 
      
addi    sp, sp, 1       # restore stack p
addi    s3, s3, -1      # count down on the s3 until 0
addi    s0, s0, 1       # advance in buf
bnez    s3, L_utoa_for_2

L_utoa_for_2_done:      # we've processed all chars from stack
sb      x0, 0(s0)       # write \0 byte

lw      fp, 0(sp)       # restore stack frame
lw      ra, 4(sp)
lw      s0, 8(sp)
lw      s1, 12(sp)
lw      s2, 16(sp)
lw      s3, 20(sp)
addi    sp, sp, 32

ret




