.import strlen.s
.import strlen_tests.s
.import streq.s
.import streq_tests.s
.import utoa.s
.import utoa_tests.s

.text
main:

jal     _utoa_tests
jal     _streq_tests
jal     _strlen_tests

addi a0, x0, 10             # exit
ecall


