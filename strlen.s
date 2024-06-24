.text

.globl _strlen
# _strlen computes the length of a zero-based string
# In: 
# - a0: addr of string
# Out:
# - a0: length of string
#
_strlen:
addi    sp, sp, -32     # save stack frame
sw      s2, 12(sp)
sw      s1, 8(sp)
sw      ra, 4(sp)
sw      fp, 0(sp)
addi    fp, sp, 32 

add     s2, a0, zero    # save beginning of string

L_strlen_dowhile:
lb      s1, 0(a0)
beq     s1, zero, L_strlen_dowhile_done    # while *c != 0, loop
addi    a0, a0, 1
j       L_strlen_dowhile

L_strlen_dowhile_done:
sub     a0, a0, s2      # return length 

lw      fp, 0(sp)       # restore stack frame
lw      ra, 4(sp)
lw      s1, 8(sp)
lw      s2, 12(sp)
addi    sp, sp, 32

ret

# _strlen:
# addi    sp, sp, -32     # save stack frame
# sw      s2, 16(sp)
# sw      s1, 12(sp)
# sw      s0, 8(sp)
# sw      ra, 4(sp)
# sw      fp, 0(sp)
# addi    fp, sp, 32 

# addi    s0, x0, 0       # s0 = counter
# addi    s1, a0, 0       # s1 = pointer to current char

# L_strlen_for_3746:
# lb      s2, 0(s1)
# addi    s0, s0, 1
# addi    s1, s1, 1
# bne     s2, x0, L_strlen_for_3746    # while *c != 0, loop

# L_strlen_for_3746_done:
# addi    a0, s0, -1      # a0 = s0-1 : return string length

# lw      fp, 0(sp)       # restore stack frame
# lw      ra, 4(sp)
# lw      s0, 8(sp)
# lw      s1, 12(sp)
# lw      s2, 16(sp)
# addi    sp, sp, 32

# ret




