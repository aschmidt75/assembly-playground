.text
.globl _streq

# _streq tests 2 strings for equality
# - a1 1st string
# - a2 2nd string
# - a0 =0 if both are equal
_streq:
addi    sp, sp, -32     # save stack frame
sw      s3, 16(sp)
sw      s2, 12(sp)
sw      s1, 8(sp)
sw      ra, 4(sp)
sw      fp, 0(sp)
addi    fp, sp, 32 

L_streq_loop:

lb      s1, 0(a1)
lb      s2, 0(a2)
sub     s3, s2, s1
bnez    s3, L_streq_neq         # *a1 != *a2, not equal
beqz    s1, L_streq_eq          # if (*a1) == 0 then (*a2) must also == 0, and both reached eos
addi    a1, a1, 1
addi    a2, a2, 1
j       L_streq_loop

L_streq_neq:
li      a0, 1
j       L_streq_done

L_streq_eq:
li      a0, 0


L_streq_done:

lw      fp, 0(sp)       # restore stack frame
lw      ra, 4(sp)
lw      s1, 8(sp)
lw      s2, 12(sp)
lw      s3, 16(sp)
addi    sp, sp, 32

ret