#
# Name: Nguyen, Benjamin
# Homework: 3
# Due: 12/05/2023
# Course: cs-2640-03-f23
# Description:
# Extend project 4 to output the strings in sorted order.
#
	.data
title:	.asciiz		"Elements v0.2 by B. Nguyen\n"
element:.asciiz		"118 elements\n"
head:	.word		0
input:	.space		64
ptfname:.asciiz		"C:/Users/benng/Documents/mips32/project4/enames.dat"
	.text
main:	la	$a0, title		# output the title
	li	$v0, 4
	syscall
	li	$a0, '\n'		# output newline
	li	$v0, 11
	syscall
	la	$a0, element		# output the number of elements
	li	$v0, 4
	syscall
	li	$a0, '\n'		# output newline
	li	$v0, 11
	syscall
	la	$a0, ptfname		# open file: enames.dat
	jal	open
	move	$s0, $v0
	# Build the linked list
do:	move	$a0, $s0		# move fd (file descriptor) into a0
	la	$a1, input
	jal	fgetln
	lb	$t0, input
	beq 	$t0, '\n', endif	# if input[0] == '\n' exit loop
	la	$a0, input
	jal	strdup			# strdup(input)
	move	$a0, $v0
	lw	$a1, head
	jal	getnode			# getnode(s, head)
	sw	$v0, head		# head = getnode(s, head)
	b	do
endif:	# Convert the linked list into an array using toarray
	lw	$a0, head
	li	$a1, 118	# size is 118 b/c 118 element names
	jal	toarray
	#Sort the array using sort
	move	$a0, $v0
	li	$a1, 118
	#jal	sort
	# Output the array
	move	$t1, $v0
printloop:
	bgt	$t0, 117, endprintloop
	li	$t0, 0
	lw	$a0, ($t1)
	jal	print
	addiu	$t1, $t1, 4
	addi	$t0, $t0, 1
	b	printloop
endprintloop:
	move	$a0, $s0		# Close the file
	jal	close
	li	$v0, 10			# Exit the program
	syscall

# toarray - This procedure will convert a linked list into an array
#
# parameter:
#		a0: address head
#		a1: int size
# return:
#		v0: address of the array
toarray:addiu	$sp, $sp, -8
	sw	$a0, 4($sp)
	sw	$ra, ($sp)
	move	$a0, $a1
	sll	$a0, $a0, 2	# size = 118 * 4 = 472
	jal	malloc		# allocate an array of size
	move	$t2, $v0	# address of the array in t2
	lw	$t0, 4($sp)	# address of head node in t0
whilearr:
	beqz	$t0, endtoarray	# if node.next == 0 then end loop
	lw	$t1, ($t0)	# get the data from the node
	sw	$t1, 0($t2)	# store the data into the array
	lw	$t0, 4($t0)	# goto the next node
	addiu	$t2, $t2, 4	# increament the array
	b	whilearr
endtoarray:
	lw	$a0, 4($sp)	# restore the stack
	lw	$ra, ($sp)
	addiu	$sp, $sp, 8
	jr	$ra

# sort - This procedure will sort the array of addresses to cstring
# (use selection sort)
# parameter:
#		a0: address array
#		a1: int size
# return:	void
sort:	li	$t0, 0		# startScan = 0
	sll	$t1, $a1, 2	# t1 = 472
for:	bgt	$t0, 468, endfor1	# if startscan > array.length-1 then end for loop
	move	$t2, $t0	# t2: minIndex = startScan
	lw	$t3, ($a0)	# t3: minValue = array[startScan]
	addiu	$t4, $t0, 4	# index = startScan + 1
for2:	bgt	$t4, 472, endfor2	# if index > array.length then end for loop2
	addiu	$sp, $sp, -12
	sw	$a1, 8($sp)
	sw	$a0, 4($sp)
	sw	$ra, ($sp)


	move	$a1, $t3
	jal	strcmp


	lw	$a1, 8($sp)
	lw	$a0, 4($sp)
	lw	$ra, ($sp)
	addiu	$sp, $sp, 12
	addiu	$t4, $t4, 4	# index++
	b	for2
	
endfor2:
	addiu	$t0, $t0, 1	# startScan++
	b	for
endfor1:
	jr	$ra

# strcmp - This procedure will compare s1 and s2 and return 
#		-1: s1 < s2,
#		0: s1 == s2,
#		1: s1 > s2,
# parameter:
#		a0: cstring s1
#		a1: cstring s2
# return:
#		v0: int -1 or 0 or 1
strcmp:



# strdup - returns the address of the duplicated source, must call strlen and malloc
#
# parameter:
# 	a0: source
# return:
# 	v0: address of the duplicated source
strdup:	addiu	$sp, $sp, -8
	sw	$a0, 4($sp)
	sw	$ra, ($sp)
	jal	strlen		# get length of src
	addi	$a0, $v0, 1	# size = length + 1 account for '\0' when allocating
	jal	malloc		# allocate space
	move	$t0, $v0	# base address of allocated block copy into $t0
	lw	$a0, 4($sp)
while0:	lb	$t1, ($a0)	# while(*d = *s)
	sb	$t1, ($t0)
	beqz	$t1, endw0
	addiu	$a0, $a0, 1
	addiu	$t0, $t0, 1
	b	while0
endw0:	lw	$a0, 4($sp)
	lw	$ra, ($sp)
	addiu	$sp, $sp, 8
	jr	$ra

# strlen - gives length of a string
#
# parameter:
# 	a0: cstring source
# return:
# 	v0: length of string
strlen:	move	$t0, $a0
while1:	lb	$t1, ($t0)
	beqz	$t1, endw1
	addiu	$t0, $t0, 1
	b	while1
endw1:	subu	$v0, $t0, $a0
	jr	$ra

# malloc - Allocates a block of size bytes of dynamic memory
#
# parameter:
# 	a0: size in bytes
# return:
# 	v0: the address to the beginning of the block
malloc:	addiu	$sp, $sp, -4
	sw	$a0, ($sp)
	move	$t0, $a0
	rem	$t2, $t0, 4
make4:	beqz	$t2, endmal
	addi	$t0, $t0, 1
	rem	$t2, $t0, 4
	b	make4
	#addi	$a0, $a0, 3
	#addi	$a0, $a0, 0xfffc
endmal:	move	$a0, $t0
	li	$v0, 9
	syscall
	lw	$a0, ($sp)
	addiu	$sp, $sp, 4
	jr	$ra

# getnode - returns an address to a new node initialized with data and next
#
# parameter:
# 	a0: address data
# 	a1: address next
# return:
# 	v0: address to a new node
getnode:addiu	$sp, $sp, -8
	sw	$ra, 4($sp)
	sw	$a0, ($sp)	# store data(a0) and ra onto the stack
	li	$a0, 8		# size = 8 bytes
	jal	malloc		# allocate size memory for the node
	lw	$a0, ($sp)
	sw	$a0, ($v0)	# initialize node data
	sw	$a1, 4($v0)	# initialize node next
	lw	$ra, 4($sp)	# restore stack
	lw	$a0, ($sp)
	addiu	$sp, $sp, 8
	jr	$ra

# print - output source to the console using format: #:$ where $ is the string and # is the
# length of the string
#
# parameter:
# 	a0: cstring source
# return: void
print:
	addiu	$sp, $sp, -8
	sw	$ra, ($sp)
	sw	$a0, 4($sp)
	jal	strlen
	move	$a0, $v0
	li	$v0, 1
	syscall
	li	$a0, ':'	
	li	$v0, 11
	syscall
	lw	$a0, 4($sp)
	li	$v0, 4
	syscall
	lw	$ra, ($sp)
	addiu	$sp, $sp, 8
	jr	$ra

# traverse - traverses the list and calls proc passing the data of the node visit
#
# parameter:
# 	a0: address list
# 	a1: address proc
# return: void
traverse:
	addiu	$sp, $sp, -12
	sw	$ra, ($sp)
	sw	$a0, 4($sp)
	sw	$a1, 8($sp)

	beqz	$a0, endtrav
	lw	$a0, 4($a0)
	jal	traverse

	lw	$a0, 4($sp)
	lw	$a0, 0($a0)
	jalr	$a1

endtrav:
	lw	$ra, ($sp)
	lw	$a1, 8($sp)
	addiu	$sp, $sp, 12
	jr	$ra

