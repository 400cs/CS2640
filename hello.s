#
# Name: Nguyen, Benjamin
# Homework: 1
# Due: 10/3/2023
# Course: cs-2640
#
# Description:
# MIPS32 Hello World!
#

		.data
hello:	.ascii "Hello by B. Nguyen\n\n"
		.asciiz "hello world from mips32!\n"

		.text
main:	
		la		$a0, hello		# display hello
		li		$v0, 4
		syscall
	
		add		$t0, $t1, $t2	#

		li		$v0, 10		# exit
		syscall