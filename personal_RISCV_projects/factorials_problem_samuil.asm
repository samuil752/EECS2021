l1: DC "factorials with stacks by samuil: \0"
addi s1, x0, l1
ecall x1, s1, 4
ecall x10, x0, 5
jal x1, fact
ecall x0, x10, 0
ebreak x0,x0,0


fact:	beq x10, x0, adjust			;have you reached the base case?
	addi sp, sp, -16
	sd x10, 0(sp)
	sd x1, 8(sp)
	addi x10, x10, -1
	jal x1, fact
//pop
	ld x1, 8(sp)
	ld x5, 0(sp)			;load return address for every number stored
	mul x10, x10, x5			;cumlative product
	addi sp, sp, 16			;next numbers
	jalr x0, 0(x1)			

adjust: addi x10, x0, 1				;adjust x10 to 1 for pop op
	jalr x0, 0(x1)			;proceed to pop operation
	

	