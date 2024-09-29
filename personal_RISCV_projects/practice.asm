l0: DC "Friday lab section\0"
l1: DC "input1: \0"
l2: DC "input2: \0"
l3: DC "GCD = \0"
ss: EQU 16

addi x5, x0, l0
addi x3, x0, l1
addi x4, x0, l2

ecall x0, x5, 4
ecall x1, x3, 4
ecall x1, x0, 5
ecall x2, x4, 4
ecall x2, x0, 5

GCD:
beq x2, x0, END
rem s1, x1, x2
add x1, x0, x2
add x2, x0, s1
beq x0, x0, GCD
END:

addi s2, x0, l3
ecall x1, s2, 4
ecall x0, x1, 0


