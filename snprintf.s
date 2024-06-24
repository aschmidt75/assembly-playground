# .data
# _snprintf_fmt_start: 
# .byte '%'

.text
.globl _snprintf

# _snprintf formats 
# in:
# - a0 target buffer
# - a1 size of buffer
# - a2 format string
# - all options on stack, reverse
# out:
# - a0 >=0: length of resulting string or <0: error in nth format element
# internal:
# - s0 = deref: current byte in target buffer
# - s2 = deref: current byte in format string

_snprintf:

addi    sp, sp, -32
sw      s5, 28(sp)
sw      s4, 24(sp)
sw      s3, 20(sp)
sw      s2, 16(sp)
sw      s1, 12(sp)
sw      s0, 8(sp)
sw      ra, 4(sp)
sw      fp, 0(sp)
addi    fp, sp, 32 

# quick check if buffer is 0 length, return right away
blez    a1, L_snprintf_mainloop_1_done

addi    s0, a0, 0       # s0 = loop deref over target buffer
addi    s2, a2, 0       # s2 = loop deref over format string

L_snprintf_mainloop_1:  # loop over the format string

# check if out of capacity
addi    s5, a1, -1      # out of cap == remaining cap == 1
beqz    s5, L_snprintf_mainloop_1_done   

lb      s1, 0(s2)       # deref s1 in format string next char 
beqz    s1, L_snprintf_mainloop_1_done        # check if at end

addi    s3, s1, -0x25   # check if *c == '%'
bnez    s3, L_snprintf_mainloop_1_nofmt   # no, skip

L_snprintf_mainloop_1_fmt:
addi    s2, s2, 1       # skip the % in pattern
call    L_snprintf_fmt  # descend into formatting next pattern
# we fully processed the pattern fmt-ing part, and 
# it advanced the pointers also. loop
j       L_snprintf_mainloop_1

L_snprintf_mainloop_1_nofmt:

addi    s2, s2, 1       # move forward in format string

sb      s1, 0(s0)       # store to target buf
addi    s0, s0, 1       # move forward in target buf
addi    a1, a1, -1      # dec target buf capacity

L_snprintf_mainloop_1_fmt_done:

j       L_snprintf_mainloop_1

L_snprintf_mainloop_1_done:

# write 0 termination
addi    s1, zero, 0
sb      s1, 0(s0)

# TODO: return size of buffer

lw      fp, 0(sp)       # restore stack frame
lw      ra, 4(sp)
lw      s0, 8(sp)
lw      s1, 12(sp)
lw      s2, 16(sp)
lw      s3, 20(sp)
lw      s4, 24(sp)
lw      s5, 28(sp)
addi    sp, sp, 32

ret



# _snprintf_fmt processes a single %...x pattern 
# in:
# - s2 points to next char in format string
# - s0 points to next char in target buffer
# out:
#
L_snprintf_fmt:

addi    sp, sp, -8
sw      ra, 4(sp)

# 
lb      s3, 0(s2)       # deref next byte in pattern
addi    s2, s2, 1       # move forward in pattern
addi    s5, s3, -0x25   # is it a %, too?
beqz    s5, L_snprintf_fmt_escape   
j       L_snprintf_fmt_done

L_snprintf_fmt_escape:  # found escape pattern (%%)
sb      s3, 0(s0)       # write % (still in s3) to target buf
addi    s0, s0, 1       # move forward in target buf
addi    a1, a1, -1      # dec target buf capacity
j       L_snprintf_fmt_done


L_snprintf_fmt_done:    # we processed the single pattern

lw      ra, 4(sp)
addi    sp, sp, 8

ret
