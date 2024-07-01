.import strlen.s
.import strlen_tests.s
.import streq.s
.import streq_tests.s
.import utoa.s
.import utoa_tests.s
.import snprintf.s
.import snprintf_tests.s

.text
main:

jal     _snprintf_tests
jal     _utoa_tests
jal     _streq_tests
jal     _strlen_tests

addi a0, x0, 10             # exit
ecall
