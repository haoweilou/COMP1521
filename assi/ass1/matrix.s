# COMP1521 19t2 ... Game of Life on a NxN grid
#
# Written by <<Haowei Lou>>, June 2019

## Requires (from `boardX.s'):
# - N (word): board dimensions
# - board (byte[][]): initial board state
# - newBoard (byte[][]): next board state
    .data
msg1:   .asciiz "# Iterations: "
msg2:   .asciiz "=== After iteration "
msg3:   .asciiz " ==="
eol:    .asciiz "\n"
spa:    .asciiz " "

## Provides:
	.globl	main
	#.globl	decideCell
	# .globl	neighbours
	#.globl	copyBackAndShow
########################################################################
# .TEXT <main>
	.text
main:

# Frame:	...
# Uses:		...
# Clobbers:	...

# Locals:	...

# Structure:
#	main
#	-> [prologue]
#	-> ...
#	-> [epilogue]

# Code:
    #setup stack
    sw	$fp, -4($sp)	# push $fp onto stack
	la	$fp, -4($sp)	# set up $fp for this function
	sw	$ra, -4($fp)	# save return address
	sw	$s0, -8($fp)	# save $s0 to use as ... int maxiters
	sw  $s1, -12($fp)    # save $s1 to use as ... int n
	sw  $s2, -16($fp)    # save $s2 to use as ... int i
	sw  $s3, -20($fp)    # save $s3 to use as ... int j
	addi $sp, $sp, -24   # reset $sp to last pushed item
	
	li  $s0, 0   # maxiters = 0
	li  $s1, 1   # n = 1
	li  $s2, 0   # i = 0
	li  $s3, 0   # j = 0
	
	
	la  $a0, msg1        #printf("# Iterations: ");
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall		        # scanf("%d") into $v0
    
	move $s0, $v0       # $s0 = $v0
################################S-Loop 1######################################## 	
while1:                  #while(n <= maxiters)
    bgt $s1, $s0, exit1 
    li  $s2, 0   # i = 0
################################S-Loop 2######################################## 
while2:          # while(i < N)
    lw  $t0, N              
    bge $s2, $t0, exit2  
    li  $s3, 0  # j = 0
################################S-Loop 3######################################## 
while3:          # while(j < N)
    bge $s3, $t0, exit3  
    
    la  $a0, board
    li  $t2, 1      #$t2 = 4
    mul $t3, $s2, $t0   # $t3 = Row*N
    mul $t3, $t3, $t2   # $t3 = 4*Row*N
    mul $t4, $s3, $t2   # $t4 = Col*4
    add $t3, $t3, $t4   # $t3 = 4*Row*N+ Col*4
    add $t3, $a0, $t3
    
    lb $a0, ($t3)
    move $v0, $a0
    li $v0, 1
    syscall
    
    la $a0, spa
    li  $v0, 4
    syscall
    
    addi $s3, $s3, 1
    j while3
    exit3:
################################E-Loop 3######################################## 
    la $a0, eol
    li $v0, 4
    syscall
    
    addi $s2, $s2, 1    # i++
    j while2
    exit2:
################################E-Loop 2########################################  
    addi $s1, $s1, 1    #n++ 
    j while1
    exit1:
################################E-Loop 1######################################## 
	lw  $s3, -20($fp)
	lw  $s2, -16($fp)
	lw  $s1, -12($fp)
	lw	$s0, -8($fp)
	lw	$ra, -4($fp)
	la	$sp, 4($fp)
	lw	$fp, ($sp)
	
	li $v0, 0
main__post:
	jr	$ra

	# Put your other functions here
