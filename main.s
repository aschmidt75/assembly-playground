.import strlen.s

.text
main:

#
# call _strlen, write length of string
# to memory location
#
la      a0, msg          # get string length of msg
jal     _strlen

la      a1, len          # write to mem
sw      a0, 0(a1)

addi a0, x0, 10             # exit
ecall

.data
msg:
.asciiz "Hello world!"
len:
.byte 0

