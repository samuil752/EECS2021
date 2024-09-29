ecall x10, x0, 5
addi t0, x0, 0
loop1: bge t0, x10, end1
addi t1, x0, 0
addi s1, x0, 0
addi s2, x0, 1
loop2: blt t0, t1, end2
add s3, s1, s2
add s1, x0, s2
add s2, x0, s3
addi t1, t1, 1
jal x0, loop2
end2: ecall x0, s1, 0
addi t0, t0, 1
jal x0, loop1
end1:
ecall x0, x0, 0