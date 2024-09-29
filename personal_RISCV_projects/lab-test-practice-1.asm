// This is for Question 1 (7.5 Pts)
sn:	DC	"Student's number: 123456789"
str1:	DC	"Input an integer:"
str2:	DC	"Results="

// A: Print Student numnber, followed by my student number
	addi	x5, x0, sn
	ecall	x0, x5, 4

// B: Print "Input an integer:" and store in x1

	addi	x5, x0, str1
	ecall	x0, x5, 4
	ecall	x1, x0, 5

// C: Loop 1
	addi	x7, x0, 1		// Init x7
	addi	x28, x1, 1		// Different Starting
loop1:	bge	x7, x28, end
	addi	x8, x0, 1		// Init x8
	jal	x2, loop2
	addi	x4, x4, 10
	addi	x7, x7, 1		// Increment x7 counter
	beq	x0, x0, loop1

// D: Loop 2
loop2:	bge	x8, x1, end2
	mul	x3, x7, x8
	add	x4, x3, x4
	addi	x8, x8, 1		// Increment x8 counter
	beq	x0, x0, loop2

end2:	jalr	x0, 0(x2)

// E: Break out of the loop
end:	addi	x5, x0, str2
	ecall	x0, x5, 4		// F: Print results
	ecall	x0, x4, 0
	ebreak	x0, x0, 0