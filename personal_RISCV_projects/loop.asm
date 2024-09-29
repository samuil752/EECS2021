	lui	s0, 0x23b8f	#base adress store in s0
	addi	s0, s0, 0x780 #base adress store in s0 adress is 0x23b8f780
	addi	x13, zero, 20 #until 20
	add	x11, zero, s0
	addi	x23, x23, 0 #the index in the array i

#loop2 stores an array of multiples of 2 in sequence smallest to largest
loop2:	slli	x11, x23, 3	
	add	x11, x11, s0 #x11 is the offset plus base adress
	addi	t0, t0, 1	#t0 = t0 + 1
	slli	x6, t0, 1	#x6 will store 2*t0
	sd	x6, 0(x11) #store x6 into x11 adress in the array
	beq	x6, x13, Exit2
	addi	x23, x23, 1 #i+=1
	beq	x0, x0, loop2

Exit2:	addi	x22, x22, 0 #the index in the array i
	addi	x24, x24, 14 #the kth value for comparison

#translation of the C code: while (save[i] != k) i += 1;
loop:	slli	x10, x22, 3 #offset
	add	x10, x10, s0 #offset plus base adress
	ld	x9, 0(x10) #value at the index
	addi	x22, x22, 1 #i+=1
	beq	x9, x24, Exit #comapre
	beq	x0, x0, loop

Exit: #above loop iterates 7 times (14)/2 that is x24/2=x22