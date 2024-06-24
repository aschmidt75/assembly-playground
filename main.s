.import strlen.s
.import strlen_tests.s

.text
main:

jal     _strlen_tests

addi a0, x0, 10             # exit
ecall

.data
msg:
.asciiz "Hello world!"
len:
.byte 0

