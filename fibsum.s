#
# Name: Nguyen, Benjamin
# Homework: 2
# Due: date
# Course: cs-2640-03-f23
#
# Description:
# Write a program that will:
# 1. Declare an array named fibs that can hold 30 integer numbers.
# 2. Write the code to compute and fill this array with the first 30 Fibonacci numbers.
# fibs[0] = 0, fibs[1] = 1, fibs[2] = 1, fibs[3] = 2, ..., fib[n] = fib[n -1] + fib[n - 2]
# 3. Write the code to compute the sum of all the even numbers in fibs and store it in a location named sum.
# 4. Output the content of the location sum
#
	.data
title:	.asciiz		"Fibonacci by B. Nguyen"
sum:	.asciiz		"Sum = "
fibs:	.word		0:30

	.text
main:	la	$a0, title		# ouput title and sum prompts
	li	$v0, 4
	syscall

	li	$a0, '\n'
	li	$v0, 11
	syscall

	li	$a0, '\n'
	li	$v0, 11
	syscall

	la	$a0, sum
	li	$v0, 4
	syscall

	# calculate fibonacci numbers
	la	$t0, fibs		# Load the base address of the 'fibs' array
	li	$t1, 1			
	sw	$t1, 4($t0)		# store number 1 into 2nd element of the array
	li	$t1, 2			# t1 is our count:j = 2 (count starts at 2)

for:	bge	$t1, 30, endfor		# when j >= 30 end for loop
	lw	$t2, ($t0)		# t2 holds the value at i - 2 in the array
	lw	$t3, 4($t0)		# t3 hold the value at i - 1 in the array
	add	$t4, $t2, $t3		# add fibs[i] = fibs[i - 1] + fibs[i - 2]
	sw	$t4, 8($t0)
	addi	$t0, $t0, 4		# update the pos. of array by adding 4(offset)
	addi	$t1, $t1, 1		# j + 1 (update count)
	b	for
endfor:

	la	$t0, fibs		# set t0 to start at fibs[0] the begining
	li	$t1, 0			# t1 is our count:j = 0 (count starts at 0)
	li	$t2, 0			# sum = 0
	li	$t4, 2
	
	# calculate the sum of all the even fibonacci numbers
for2:	bge	$t1, 30, endfor2	# when j >= 30 end for loop
	lw	$t3, ($t0)
	div	$t3, $t4		# fibs[j] / 2		
	mfhi	$t5			# the remainder
	bnez	$t5, endif		# if (fibs[j] mod 2 != 0) then goto endif
	add	$t2, $t2, $t3		# sum = sum + fibs[j]

endif:	
	addi	$t0, $t0, 4		# update the pos. of array by adding 4 (the offset)
	addi	$t1, $t1, 1		# j + 1 (update count)
	b	for2
endfor2:

	move 	$a0, $t2		# output the sum
	li	$v0, 1
	syscall

	li	$v0, 10
	syscall
