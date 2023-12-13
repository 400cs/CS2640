#
# Name: Nguyen, Benjamin
# Homework: 4
# Due: 12/05/2023
# Course: cs-2640-03-f23
#
# Description:
# Write a program to calculate the area of a circle using
# floating-point numbers
#
	.data
title:	.asciiz		"Circle Area by B. Nguyen\n"
radiusp:.asciiz		"Enter the radius? "
areap:	.asciiz		"Area = "

	.text
main:
	la	$a0, title	# output the title
	li	$v0, 4
	syscall

	li	$a0, '\n'	# output newline
	li	$v0, 11
	syscall

	la	$a0, radiusp	# output the radius prompt
	li	$v0, 4
	syscall

	li	$v0, 7		# prompt the user for a double preciesion radius
	syscall

	mov.d	$f2, $f0
	jal	circle_area	# calculate the area

	la	$a0, areap	# output the area prompt
	li	$v0, 4
	syscall
	
	mov.d	$f12, $f0
	li	$v0, 3		# output the area
	syscall

	li	$v0, 10		# exit
	syscall
# circle_area - calculates the area of a cirle given the radius
# parameters: 
#		f2: double radius
# return: 
#		f0: double area of cirle (pi * r^2)
circle_area:
	mul.d	$f4, $f2, $f2		# r^2 = r * r
	li.d	$f6, 3.141592653589793	# pi = 3.141592653589793
	mul.d	$f0, $f6, $f4		# area = (pi * r^2)
	jr	$ra
	