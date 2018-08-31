# Semester project by Robbie Castillo (Tic Tac Toe)
# This game is played as normal. We use a linear algebra matrix to place our X's and O's
# An example of how the values are displayed
#	__		   __
#	|m1,1	m1,2	m1,3|
#	|m2,1	m2,2	m2,3|
#	|m3,1	m3,2	m3,3|
#	--		   --
# So to get to m3,2, you would put X Coordinate = 3 & Y Coordinate = 2.
# To get to m1,3, you would put X = 1 & Y = 3
# One extra rule I put in the game is that, if you try to enter a pair of coordinates
#	whose location is already 'taken,' the turn is forfeited and the coordinates are
#	declared invalid.
		.data
m11:		.byte '-'
		.align 2
m12:		.byte '-'
		.align 2
m13:		.byte '-'
		.align 2
m21:		.byte '-'
		.align 2
m22:		.byte '-'
		.align 2
m23:		.byte '-'
		.align 2
m31:		.byte '-'
		.align 2
m32:		.byte '-'
		.align 2
m33:		.byte '-'
		.align 2
enter:		.asciiz "\n"
enter_xCoor: 	.asciiz "Please enter X Coordinate: "
enter_yCoor: 	.asciiz "Please enter Y Coordinate: "
xCoor:		.word -1
yCoor: 		.word -1
player1:	.byte 'X'
		.align 2
player2:	.byte 'O'
		.align 2
invalidInput:	.asciiz "Invalid coordinates, please enter numbers from 1-3 for x & y.\n"
spaceTaken:	.asciiz "This space has been taken, duh. We're skipping your turn since you play dirty >:( #badCoordinates\n"
draw:		.asciiz "A Draw has occurred.\n Wanna play again?"
playAgainQ:	.asciiz "Would you like to play again? Click 'Yes' to continue, or 'No' to quit."
Player1Win:	.asciiz	"Player 1 ('X') has won! Huzzah!\n Wanna play again?"
Player2Win:	.asciiz "Player 2 ('O') has won! Huzzah!\n Wanna play again?"
emptyCopy:	.byte '-'
p1:		.asciiz "(P1) "
p2:		.asciiz "(P2) "
space:		.asciiz "\n"



	.text 
#MAIN FUNCTION
main:
	la $a0, space
	li $v0, 4
	syscall
	
	move $v1, $zero
	jal printBoard
	
reRun:	
	la $a2, p1
	jal enterCoordinates
	lb $a0, player1
	jal changeBoard
	jal printBoard
	
	lb $v0, player1	
	jal checkVictory
	beq $v1, -200, Draw
	beq $v1, -100, Victory1
	
	la $a2, p2
	jal enterCoordinates
	lb $a0, player2
	jal changeBoard
	jal printBoard
	
	lb $v0, player2
	jal checkVictory
	beq $v1, -200, Draw
	beq $v1, -100, Victory2
	
	j reRun

exit:
	li $v0, 10	#exit function
	syscall
	
	
#CHECK VICTORY FUNCTION FOR BOARD -------------------#
checkVictory:
	
	#load all the 9 board pieces for comparisons
	lb $t0, m11 
	lb $t1, m12 
	lb $t2, m13 
	lb $t3, m21 
	lb $t4, m22 
	lb $t5, m23 
	lb $t6, m31 
	lb $t7, m32 
	lb $t8, m33 
	
	#Check for any empty slot; if not empties, then it is a draw
	lb $t9, emptyCopy
	beq $t9, $t0, notFull
	beq $t9, $t1, notFull
	beq $t9, $t2, notFull
	beq $t9, $t3, notFull
	beq $t9, $t4, notFull
	beq $t9, $t5, notFull
	beq $t9, $t6, notFull
	beq $t9, $t7, notFull
	beq $t9, $t8, notFull
	addi $v1, $zero, -200
	jr $ra
	
notFull:
	
case0:	
	bne $v0, $t0, case1
		bne $v0, $t1, case1
			bne $v0, $t2, case1	#for three-in-row horz, top row
				addi $v1, $zero, -100	#declare we have a winner using value -100
				jr $ra
case1:	
	bne $v0, $t3, case2
		bne $v0, $t4, case2
			bne $v0, $t5, case2	#for three-in-row horz, middle row
				addi $v1, $zero, -100
				jr $ra
case2:
	bne $v0, $t6, case3
		bne $v0, $t7, case3
			bne $v0, $t8, case3	#for three-in-row horz, bottom row
				addi $v1, $zero, -100	
				jr $ra
case3:
	bne $v0, $t0, case4
		bne $v0, $t3, case4
			bne $v0, $t6, case4	#for three-in-row vert, left row
				addi $v1, $zero, -100	
				jr $ra

case4:
	bne $v0, $t1, case5
		bne $v0, $t4, case5
			bne $v0, $t7, case5	#for three-in-row vert, middle row
				addi $v1, $zero, -100
				jr $ra
case5:
	bne $v0, $t2, case6
		bne $v0, $t5, case6
			bne $v0, $t8, case6	#for three-in-row vert, right row
				addi $v1, $zero, -100	
				jr $ra
case6:
	bne $v0, $t0, case7
		bne $v0, $t4, case7
			bne $v0, $t8, case7	#for diagonal right case
				addi $v1, $zero, -100	
				jr $ra
case7:
	bne $v0, $t2, leave1
		bne $v0, $t4, leave1
			bne $v0, $t6, leave1	#for diagonal left case
				addi $v1, $zero, -100
				jr $ra

leave1:	jr $ra	#maybe nothing worked, so we just go back to main

#DRAW JUMP TO FUNCTION --------------------------#	
Draw:	#display draw message and ask if we wanna play again
	
	la $a0, draw
	li $v0, 50
	syscall
	
	#Continue here by comparing the inserted value
	beq $a0, 0, clear #if the input was clicking 'YES', clear board and roll out
	beq $a0, 1, exit #if the input was blank, terminate the program
	beq $a0, 2, exit #	^	^	^	^
	
clear: 	#we clear the board here
	lb $t9, emptyCopy
	lb $t0, emptyCopy
	lb $t1, emptyCopy  
	lb $t2, emptyCopy  
	lb $t3, emptyCopy 
	lb $t4, emptyCopy  
	lb $t5, emptyCopy  
	lb $t6, emptyCopy  
	lb $t7, emptyCopy  
	lb $t8, emptyCopy
	
	sb $t0, m11
	sb $t1, m12
	sb $t2, m13
	sb $t3, m21
	sb $t4, m22
	sb $t5, m23
	sb $t6, m31
	sb $t7, m32
	sb $t8, m33 
	
	j main 

#Victory Condition for Player 1  ('X')
Victory1:
	#P1 Victory message
	la $a0, Player1Win
	li $v0, 50
	syscall
	
	#Continue here by comparing the inserted value
	beq $a0, 0, clear #if the input was clicking 'YES', clear board and roll out
	beq $a0, 1, exit #if the input was blank, terminate the program
	beq $a0, 2, exit #	^	^	^
	
#Victory Condition for Player 2 ('O')
Victory2:
	#Display Victory message for P2
	la $a0, Player2Win
	li $v0, 50
	syscall
	
	#Continue here by comparing the inserted value
	beq $a0, 0, clear #if the input was clicking 'YES', clear board and roll out
	beq $a0, 1, exit #if the input was blank, terminate the program
	beq $a0, 2, exit #	^	^	^
#ENTER COORDINATES FUNCTION ----------------------#
enterCoordinates:

	#Load & print (P2) msg
	move $a0, $a2
	li $v0, 4
	syscall
	#ask for x Coordinate (MESSAGE)
	la $a0, enter_xCoor
	li $v0, 4
	syscall
	#get x Coordinate
	li $v0, 5
	syscall
	blt $v0, 1, nope
	bgt $v0, 3, nope
	sw $v0, xCoor
	
	#Load & print (P2) msg
	move $a0, $a2
	li $v0, 4
	syscall
	#ask for y Coordinate (MESSAGE)
	la $a0, enter_yCoor
	li $v0, 4
	syscall
	#get y Coordinate
	li $v0, 5
	syscall
	blt $v0, 1, nope
	bgt $v0, 3, nope
	sw $v0, yCoor
	
	jr $ra
	
nope:
	la $a0, invalidInput	#If bad input, we ask again for the correct input
	li $v0, 4
	syscall
	j enterCoordinates
	
#CHANGE BOARD FUNCTION ---------------------------#
changeBoard:
	lw $t1, xCoor
	lw $t2, yCoor
	lb $t9, emptyCopy
	
x1:	bne  $t1, 1, x2	#if x == 1
		bne $t2, 1, y12 #if y==1, so array[1,1]
			lb $t3, m11
			bne $t3, $t9, DNE	#if not empty, go fix it 
			sb $a0, m11
			jr $ra
			
y12:		bne $t2, 2, y13 #if y==2, then array[1,2]
			lb $t3, m12
			bne $t3, $t9, DNE	#if not empty, go fix it
			sb $a0, m12
			jr $ra
			
y13:			lb $t3, m13
			bne $t3, $t9, DNE	#if not empty, go fix it
			sb $a0, m13 #if y ==3, then array[1,3]
			jr $ra

			j DNE	#if x==2 but y != 1, or 2, or 3, then y is invalid. We redo input
			
x2:	bne $t1, 2, x3	#if x == 2
		bne $t2, 1, y22 #if y==1, so array[2,1]
			lb $t3, m21
			bne $t3, $t9, DNE	#if not empty, go fix it 
			sb $a0, m21
			jr $ra
y22:		bne $t2, 2, y23 #if y==2, then array[2,2]
			lb $t3, m22
			bne $t3, $t9, DNE	#if not empty, go fix it 
			sb $a0, m22
			jr $ra
			
y23:			lb $t3, m23
			bne $t3, $t9, DNE	#if not empty, skip turn 
			sb $a0, m23 #if y ==3, then array[2,3]
			jr $ra
			
			j DNE	#if x==2 but y != 1, or 2, or 3, then y is invalid. We redo input
			
x3:	bne $t1, 3, DNE	#if x == 3
		bne $t2, 1, y32 #if y==1, so array[3,1]
			lb $t3, m31
			bne $t3, $t9, DNE	#if not empty, go fix it 
			sb $a0, m31
			jr $ra
y32:		bne $t2, 2, y33 #if y==2, then array[3,2]
			lb $t3, m32
			bne $t3, $t9, DNE	#if not empty, go fix it 
			sb $a0, m32
			jr $ra
			
y33:			lb $t3, m33
			bne $t3, $t9, DNE	#if not empty, go fix it 
			sb $a0, m33 #if y ==3, then array[3,3]
			jr $ra
			
			j DNE
			
DNE:	la $a0, spaceTaken
	li $v0, 4
	syscall
	jr $ra
#PRINT BOARD FUNCTION ----------------------------#
printBoard:

#Here, we print the board as if it were a (3x3) matrix in linear algebra
#An example of how the values are displayed
#	__		   __
#	|m1,1	m1,2	m1,3|
#	|m2,1	m2,2	m2,3|
#	|m3,1	m3,2	m3,3|
#	--		   --
#
	la $a0, m11
	li $v0, 4
	syscall 
	la $a0, m12
	li $v0, 4
	syscall
	la $a0, m13
	li $v0, 4
	syscall
	la $a0, enter	#our "newline", if you will
	li $v0, 4
	syscall

	
	la $a0, m21
	li $v0, 4
	syscall
	la $a0, m22
	li $v0, 4
	syscall
	la $a0, m23
	li $v0, 4
	syscall
	la $a0, enter
	li $v0, 4
	syscall

	
	la $a0, m31
	li $v0, 4
	syscall
	la $a0, m32
	li $v0, 4
	syscall
	la $a0, m33
	li $v0, 4
	syscall
	la $a0, enter
	li $v0, 4
	syscall
	
	jr $ra
