#
# Name: Nguyen, Benjamin
# Project: 5
# Due: 12/08/2023
# Course: cs-2640-03-f23
#
# Description:
# Write a complete program that prompts the user for the coefficients
# a, b, and c of a quadratic equation ax^2 + bx + c = 0 and outputs
# the solutions as shown. discriminant = b2 – 4ac
#
	.data
title:	.asciiz		"Quadractic Equation Solver v0.1 by B. Nguyen\n"
aprompt:.asciiz		"Enter value for a? "
bprompt:.asciiz		"Enter value for b? "
cprompt:.asciiz		"Enter value for c? "
xsq:	.asciiz		" x^2 + "
x:	.asciiz		" x + "
equal0:	.asciiz		" = 0"
sol1:	.asciiz		"Not a quadratic equation."
sol2:	.asciiz		"x = "
sol3:	.asciiz		"Roots are imaginary."
sol4a:	.asciiz		"x1 = "
sol4b:	.asciiz		"x2 = "
aval:	.float		0.0
bval:	.float		0.0
cval:	.float		0.0

	.text
main:
	la	$a0, title	# output the title
	li	$v0, 4
	syscall
	li	$a0, '\n'	# output newline
	li	$v0, 11
	syscall

	# collect and store values for a,b, & c
	la	$a0, aprompt	# output the prompt for the a value
	li	$v0, 4
	syscall
	li	$v0, 6
	syscall
	s.s	$f0, aval	# a = the user input

	la	$a0, bprompt	# output the prompt for the b value
	li	$v0, 4
	syscall
	li	$v0, 6
	syscall
	s.s	$f0, bval	# b = the user input

	la	$a0, cprompt	#output the prompt for the c value
	li	$v0, 4
	syscall
	li	$v0, 6
	syscall
	s.s	$f0, cval	# c = the user input

	li	$a0, '\n'	# output newline
	li	$v0, 11
	syscall

	# output the quadratic equation
	lwc1	$f12, aval	# output a
	li	$v0, 2
	syscall

	la	$a0, xsq	# output the x^2 +
	li	$v0, 4
	syscall

	lwc1	$f12, bval	# output b
	li	$v0, 2
	syscall

	la	$a0, x		# output the x +
	li	$v0, 4
	syscall

	lwc1	$f12, cval	# output c
	li	$v0, 2
	syscall
	
	la	$a0, equal0	# output the = 0
	li	$v0, 4
	syscall

	li	$a0, '\n'	# output newline
	li	$v0, 11
	syscall

	li	$a0, '\n'	# output newline
	li	$v0, 11
	syscall
	
	lwc1	$f12, aval
	lwc1	$f13, bval
	lwc1	$f14, cval
	jal	quadeq		# solve the quadratic

	bgez	$v0, endifn1	# check if v0 == -1
	la	$a0, sol3	# output the Root are imaginary.
	li	$v0, 4
	syscall
	j	exit
	
endifn1:bnez	$v0, endif0	# check if v0 == 0
	la	$a0, sol1	# output the Not a quad. eq.
	li	$v0, 4
	syscall
	j	exit

endif0:	li	$t0, 1		#check if v0 == 1
	bne	$t0, $v0, endif1 # if v0 != 1 else v0 == 2
	la	$a0, sol2	# output the x = ...
	li	$v0, 4
	syscall
	mov.s	$f12, $f0
	li	$v0, 2
	syscall
	j	exit
				
endif1:	la	$a0, sol4a	# else v0 == 2
	li	$v0, 4		# output the x1 = ...
	syscall
	mov.s	$f12, $f0
	li	$v0, 2
	syscall
	li	$a0, '\n'	# output newline
	li	$v0, 11
	syscall
	la	$a0, sol4b	# output the x2 = ...
	li	$v0, 4
	syscall
	mov.s	$f12, $f1
	li	$v0, 2
	syscall

exit:	li	$a0, '\n'	# output newline
	li	$v0, 11
	syscall
	li	$v0, 10		# exit
	syscall

# quadeq – solve for solutions to a quadratic equation
#	Parameter:
#		$f12 = float a, $f13 = float b, $f14 = float c
#	return: return status in v0, solutions in $f0, $f1
# 		$v0 = (one of the following ints below)
#		-1: imaginary,
#		0: not quadratic,
#		1: one solution, x in $f0,
#		2: two solutions, x1, x2 in $f0 and $f1.
#b. Must call the procedure named sqrts to compute the square root
quadeq:	li.s	$f6, 0.0
	c.eq.s	$f12, $f6	#check a==0
	bc1f	anoteqz		# if a!=0 then goto a!=0 block
	c.eq.s	$f4, $f6	#check b==0
	bc1f	aeqzbnoteqz	# if a==0 && b!=0 then goto a==0 && b!=0 block
	li	$v0, 0		#return $v0 = 0 (not quadratic)
	jr	$ra
aeqzbnoteqz:			# if a==0 && b!=0
	neg.s	$f6, $f14	# $f6 = -c
	div.s	$f0, $f6, $f13	# x = -c / b
	li	$v0, 1		# return $v0 = 1 (one solution)
	jr	$ra
anoteqz:			# if a != 0
	# calucate the discriminant = b^2 – 4ac
	mul.s	$f8, $f13, $f13	# b^2
	li.s	$f7, 4.0
	mul.s	$f7, $f7, $f12	# 4*a
	mul.s	$f7, $f7, $f14	# 4*a*c
	sub.s	$f7, $f8, $f7	# $f7 = (b^2 – 4ac)
	c.lt.s	$f7, $f6	# check if discriminant < 0
	bc1f	discrNotNeg	# if discriminant >= 0 then goto discrNotNeg
	li	$v0, -1		# return $v0 = -1 (imaginary)
	jr	$ra
discrNotNeg:			# else (b^2 – 4ac) >= 0 
	li.s	$f6, -1.0
	mul.s	$f8, $f13, $f6	#-b = b * -1
	li.s	$f6, 2.0
	mul.s	$f6, $f12, $f6	#2a = a * 2

	# save reg. f0,f1,f2,f3,f4,f5,f31,ra onto the stack
	addi	$sp, $sp, -32
	swc1	$f31, 28($sp)
	swc1	$f5, 24($sp)
	sw	$ra, 20($sp)
	swc1	$f0, 16($sp)
	swc1	$f1, 12($sp)
	swc1	$f2, 8($sp)
	swc1	$f3, 4($sp)
	swc1	$f4, ($sp)
	
	mov.s	$f0, $f7
	jal	sqrts		# calculate sqrt of (b^2 – 4ac)
	
	# restore reg. f0,f1,f2, f3, f4, ra
	lwc1	$f4, ($sp)
	lwc1	$f3, 4($sp)
	lwc1	$f2, 8($sp)
	lwc1	$f1, 12($sp)
	lwc1	$f0, 16($sp)
	lw	$ra, 20($sp)
	lwc1	$f5, 24($sp)
	addi	$sp, $sp, 28

	add.s	$f0, $f8, $f31	#-b + sqrt(b^2 – 4ac)
	sub.s	$f1, $f8, $f31	#-b - sqrt(b^2 – 4ac)
	div.s	$f0, $f0, $f6	# $f0 = (-b + sqrt(b^2 – 4ac)) / 2a
	div.s	$f1, $f1, $f6	# $f1 = (-b - sqrt(b^2 – 4ac)) / 2a

	swc1	$f31, ($sp)	# restore reg. f31
	addi	$sp, $sp, 4
	li	$v0, 2		#return $v0 = 2 (two solutions)
	jr	$ra

# sqrts – solve for the square root of a given floating point number, n
#	Parameter:
#		 $f0 = float n
#	return: 
#		$f31 = sqrt(n)
sqrts:	
	li.s	$f1, 0.0000001	# err = 1e-7
	mov.s	$f31, $f0	#t = n

while:	div.s	$f2, $f0, $f31	# n / t
	sub.s	$f2, $f31, $f2	# t - n / t
	abs.s	$f2, $f2	# abs(t - n / t)
	mul.s	$f3, $f1, $f31	# err * t

	c.lt.s	$f2, $f3	# if abs(t - n / t) < err * t:
	bc1t	endwhile	# end the while loop
	div.s	$f4, $f0, $f31	# n / t
	add.s	$f4, $f4, $f31	# n / t + t
	li.s	$f5, 2.0
	div.s	$f31, $f4, $f5 # t = (n / t + t) / 2.0
	b	while
endwhile:
	jr	$ra