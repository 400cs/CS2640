#
# Name: Nguyen, Benjamin
# Project: 1
# Due: 10/17/2023
# Course: cs-2640-03-f23
#
# Description:
# Write a program that tells what coins to give out
# for any amount of change from 0 cent to 99 cents.
#
	.data
quarter:	.asciiz		"\nQuarter: "
dime:		.asciiz		"\nDime: "
nickel:		.asciiz		"\nNickel: "
penny:		.asciiz		"\nPenny: "
title:		.asciiz     "Change by B. Nguyen\n"
prompt:		.asciiz     "\nEnter the change? "
no_change:	.asciiz     "No change."

	.text
main:
	# output title
	la	$a0, title
	li	$v0, 4
	syscall

	# output prompt
            la          $a0, prompt
            li          $v0, 4
            syscall

            # read an integer
            li          $v0, 5              # input is in $v0
            syscall

            beqz        $v0, change_zero    # if change == 0, then goto change_zero

            # Calculate quarters
            div         $t0, $v0, 25        # number of quarters in $t0
            mfhi        $t1                 # change leftover
            
            # Calculate dimes
            div         $t1, $t1, 10        # number of dimes in $t1
            mfhi        $t2                 # change leftover
            
            # Calculate nickels
            div         $t2, $t2, 5         # number of nickles in $t2
            mfhi        $t3                 # the leftover is the number of pennies

            beqz        $t0, dime_check     # if $t0 == 0, then goto dime_check
            la          $a0, quarter        # output the coin type
            li          $v0, 4
            syscall
            move        $a0, $t0            # output number of quarters
            li          $v0, 1
            syscall
            
dime_check:
            beqz        $t1, nickle_check   # if $t1 == 0, then goto nickle_check
            la          $a0, dime           # output the coin type
            li          $v0, 4
            syscall
            move        $a0, $t1            # output number of dimes
            li          $v0, 1
            syscall
            
nickle_check:
            beqz        $t2, penny_check    # if $t2 == 0, then goto penny_check
            la          $a0, nickel         # output the coin type
            li          $v0, 4
            syscall
            move        $a0, $t2            # output number of nickels
            li          $v0, 1
            syscall

penny_check:
            beqz        $t3, endif          # if $t3 == 0, then goto endif
            la          $a0, penny          # output the coin type
            li          $v0, 4
            syscall
            move        $a0, $t3            # output number of pennies
            li          $v0, 1
            syscall
            j           endif               # exit the program

change_zero:
            la          $a0, no_change      # output no change if input is 0
            li          $v0, 4
            syscall

endif:      
            li          $v0, 10
            syscall