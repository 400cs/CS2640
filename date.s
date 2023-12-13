#
# Name: Nguyen, Benjamin
# Project: 2
# Due: 10/26/2023
# Course: cs-2640-03-f23
#
# Description:
# Write a program that prompts for a date and outputs
# if the year is leap or not and the day of the week of date.
#
		.data
title:		.asciiz		"Date by B. Nguyen"
month_prompt:	.asciiz		"\nEnter the month? "
day_prompt:	.asciiz		"Enter the day? "
year_prompt:	.asciiz		"Enter the year? "
is_leap_year:	.asciiz		" is a leap year."
not_leap_year:	.asciiz		" is not a leap year."
monday:		.asciiz		"Monday "
tuesday:	.asciiz		"Tuesday "
wednesday:	.asciiz		"Wednesday "
thursday:	.asciiz		"Thursday "
friday:		.asciiz		"Friday "
saturday:	.asciiz		"Saturday "
sunday:		.asciiz		"Sunday "

		.text
main:
		la	$a0, title		# output the title
		li	$v0, 4
		syscall

		li	$a0, '\n'		# output newline
		li	$v0, 11
		syscall

		la	$a0, month_prompt	# output the prompt asking for the month
		li	$v0, 4
		syscall

		li	$v0, 5			# user inputting the month
		syscall
		move	$t0, $v0

		la	$a0, day_prompt		# output the prompt asking for the day
		li	$v0, 4
		syscall

		li	$v0, 5			# user inputitng the day
		syscall
		move	$t1, $v0

		la	$a0, year_prompt	# output the prompt asking for the year
		li	$v0, 4
		syscall

		li	$v0, 5			# user inputting the year
		syscall
		move	$t2, $v0

		# calculating the day of the week
		li	$t3, 14
		sub	$t3, $t3, $t0
		div	$t3, $t3, 12		# calculating a = 14 - month /12

		sub	$t4, $t2, $t3		# calculating y = year - a

		mul	$t5, $t3, 12
		add	$t5, $t0, $t5
		sub	$t5, $t5, 2		# calculating m = month + 12*a - 2

		div	$t6, $t4, 4		# calculating y / 4
		div	$t7, $t4, 100		# calculating y / 100
		div	$t8, $t4, 400		# calculating y / 400
		mul	$t9, $t5, 31
		div	$t9, $t9, 12		# calculating (31 * m) / 12

		add	$s0, $t1, $t4
		add	$s0, $s0, $t6
		sub 	$s0, $s0, $t7
		add	$s0, $s0, $t8
		add	$s0, $s0, $t9
		li	$s1, 7
		div	$s0, $s1
		mfhi	$s0			# calculating d = (day + y + y/4 -y/100 + y/400 + 31*m/12) mod 7

		li	$a0, '\n'		# output newline
		li	$v0, 11
		syscall

		# outputting the day of the week
		bne	$s0, 0, check_mon	# if d != 0 then check if its monday
		la	$a0, sunday
		li	$v0, 4
		syscall

check_mon:	bne	$s0, 1, check_tue	# if d != 1 then check if its tuesday
		la	$a0, monday
		li	$v0, 4
		syscall

check_tue:	bne	$s0, 2, check_wed	# if d != 2 then check if its wednesday
		la	$a0, tuesday
		li	$v0, 4
		syscall

check_wed:	bne	$s0, 3, check_thur	# if d != 3 then check if its thursday
		la	$a0, wednesday
		li	$v0, 4
		syscall
		
check_thur:	bne	$s0, 4, check_fri	# if d != 4 then check if its friday
		la	$a0, thursday
		li	$v0, 4
		syscall

check_fri:	bne	$s0, 5, check_sat	# if d != 5 then check if its saturday
		la	$a0, friday
		li	$v0, 4
		syscall

check_sat:	bne	$s0, 6, endif		# if d != 6 then goto endif
		la	$a0, saturday
		li	$v0, 4
		syscall

endif:		# output the date formated as month/day/year
		move	$a0, $t0
		li	$v0, 1
		syscall

		li	$a0, '/'
		li	$v0, 11
		syscall

		move	$a0, $t1
		li	$v0, 1
		syscall

		li	$a0, '/'
		li	$v0, 11
		syscall

		move	$a0, $t2
		li	$v0, 1
		syscall

		# calculating if the year is a leap year
		# Leap year is divisible by 4 and not divisible by 100
		li	$t3, 4
		div	$t2, $t3
		mfhi	$t4			# year mod 4
		li	$t3, 100
		div	$t2, $t3
		mfhi	$t5			# year mod 100

		# outputting if the year is a leap year or not
		beqz	$t4, check_div_100	# if (year % 4) == 0 then go check if year is not divisible by 100
		la	$a0, not_leap_year	# outputting is not a leap year
		li	$v0, 4
		syscall
		b	exit			# branch to exit 
check_div_100:
		bnez	$t5, leap_year		# if (year % 100) != 0 then
		la	$a0, not_leap_year	# goto leap_year because the year is a leap year
		li	$v0, 4
		syscall
		b	exit			# branch to exit 
leap_year:
		la	$a0, is_leap_year	# outputting is a leap year
		li	$v0, 4
		syscall

exit:		li	$v0, 10
		syscall