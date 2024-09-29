	ecall x0, x10, 0
	ecall x10, x0, 5

// IMPORTANT! Stack pointer must reamin a multiple of 16!!!!
fib: 	beq x10, x0, done 	// If n= 0, return 0
	addi x5, x0, 1
	beq x10, x5, done 	// If n=-1, return 1
	addi x2, x2, -16		// Allocate 2 words of stack space
	sd x1, 0(x2)		// Save the return address
	sd x10, 8(x2)		// Save the current n
	addi x10, x10, -1		// x10 = n-1
	jal x1, fib 		// fib(n-1)
	ld x5, 8(x2)		// Load old n from the stack
	sd x10, 8(x2)		// Push fib(n-1) onto the stack 
	addi x10, x5, -2		// x10 = n-2
	jal x1, fib		// Call fib(n-2)
	ld x5, 8(x2) 		// x5 = fib(n-1)
	add x10, x10, x5		// x10 = fib(n-1)+fib(n-2)
// Clean up:
	ld x1, 0(x2)		// Load saved return address
	addi x2, x2, 16		// Pop two words from the stack
done:
	jalr x0, 0(x1)