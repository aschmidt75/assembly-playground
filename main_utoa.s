# .import strlen.s
# .import utoa.s

# .text
# main:

# la a0, buf
# la t1, value
# lw a1, 0(t1)
# jal _utoa

# # strlentest
# #la a0, msg          # get string length of msg
# #jal _strlen
# #
# #la a1, len          # write to mem
# #sw a0, 0(a1)
# # .data
# # msg:
# # .asciiz "Hi!"
# # len:
# # .byte 0

# addi a0, x0, 10             # exit
# ecall

# .data
# value:
# .word 168
# buf:
# .byte 32