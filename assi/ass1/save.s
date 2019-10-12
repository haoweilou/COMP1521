# board1.s ... Game of Life on a 10x10 grid

	.data

N:	.word 10  # gives board dimensions

board:
	.byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0
	.byte 0, 0, 0, 1, 0, 0, 0, 0, 0, 0
	.byte 0, 0, 1, 0, 1, 0, 0, 0, 0, 0
	.byte 0, 0, 0, 0, 1, 0, 0, 0, 0, 0
	.byte 0, 0, 0, 0, 1, 1, 1, 0, 0, 0
	.byte 0, 0, 0, 1, 0, 0, 1, 0, 0, 0
	.byte 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
	.byte 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
	.byte 0, 0, 1, 0, 0, 0, 0, 0, 0, 0

newBoard: .space 100
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
msg3:   .asciiz " ===\n"
msg4:   .asciiz "."
msg5:   .asciiz "#"
eol:    .asciiz "\n"
## Provides:
	.globl	main
	.globl	decideCell
	.globl	neighbours
	.globl	copyBackAndShow
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
	sw  $s7, -24($fp)    # save $s3 to use as ... int nn
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
    lw  $t0, N   # $t0 = N
    li  $s2, 0   # i = 0
################################S-Loop 2######################################## 
while2:          # while(i < N)            
    bge $s2, $t0, exit2  
    li  $s3, 0  # j = 0
    lw  $t0, N  # $t0 = N
################################S-Loop 3######################################## 
while3:          # while(j < N)
    bge $s3, $t0, exit3  
    
    jal neighbours      # int nn = $t1, $s7 = nn
    #li  $t1, newBoard   # $t1 hold base for newBoard
    mul $t2, $s2, $t0   # $t2 = row * N
    add $t2, $t2, $s3   # $t2 = row + col
    #li  $t4, 4
    #mul $t2, $t2, $t4
    #add $t1, $t1, $t2   # $t1 = newboard[i][j]
    la  $t3, newBoard
    add $t4, $t3, $t2
    
    jal decideCell
    sb  $t1, ($t4)
    
    
    #la  $t1, newBoard
    #add $t2, $t1, $t2
    #lb $t2, ($t2)
    #move  $a0, $t2
    #li  $v0, 1
    #syscall
    
    addi $s3, $s3, 1
    j while3
    exit3:
################################E-Loop 3######################################## 

    
    addi $s2, $s2, 1    # i++
    j while2
    exit2:
################################E-Loop 2########################################  
    
    la  $a0, msg2   # === After iteration
    li  $v0, 4
    syscall
    
    move  $a0, $s1   # %d
    li  $v0, 1
    syscall
    
    la  $a0, msg3   # ===\n
    li  $v0, 4
    syscall
    
    addi $s1, $s1, 1    #n++ 
    jal copyBackAndShow
    
    j while1
    exit1:
################################E-Loop 1######################################## 
	lw  $s7, -24($fp)
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
neighbours:
    sw	$fp, -4($sp)	# push $fp onto stack
	la	$fp, -4($sp)	# set up $fp for this function
	sw	$ra, -4($fp)	# save return address
	sw	$s4, -8($fp)	# save $s4 to use as ... int x;
	sw	$s5, -12($fp)	# save $s5 to use as ... int y;
	sw  $s6, -16($fp)   # save $s6 to be 0  
	addi	$sp, $sp, -20	# reset $sp to last pushed item

    lw  $t0, N
    li  $t1, 0
    addi $t7, $t0, -1   # $t7 = N - 1 
    
    li  $t2, 0      # int nn = 0
    li  $s4, -1	    # int x = -1
    li  $t3, 1      # $t3 = 1
    li  $s6, 0      # $t6 = 0
###############################S-for 1##################################
for1:
    bgt $s4, $t3, exit_n1 # if x<= 1
    li  $s5, -1     # int y = -1
###############################S-for 2##################################
for2:
    bgt $s5, $t3, exit_n2 # if y<=1
    
    # if (i + x < 0 || i + x > N - 1) continue
    add $t4, $s2, $s4   # $t4 = i + x
    blt $t4, $s6, continue # i + x < 0, continue
    bgt $t4, $t7, continue # i + x > N - 1, continue
    
    # if (j + y < 0 || j + y > N - 1) continue;
    add $t4, $s3, $s5   # $t4 = j + y
    blt $t4, $s6, continue # j + y < 0, continue
    bgt $t4, $t7, continue # j + y > N - 1, continue
    
    # if (x == 0 && y == 0) continue;
    bne $s4, $s5, not_pass   # x != y, not_pass
    beq $s4, $s6, continue   # x == 0, continue
    not_pass:
    
    # if (board[i + x][j + y] == 1) nn++;
    la  $t4, board      # $t3 holds address for board
    add $t5, $s2, $s4   # $t5 = i + x
    add $t6, $s3, $s5   # $t6 = j + y
    
    mul $t5, $t5, $t0   # $t5 = $t5*N
    add $t5, $t6, $t5   # $t5 = $t6 + $t5 
    add $t5, $t4, $t5   # $t5 + offset
    # $t5 = board[i+x][j+y]
    lb  $t6, ($t5)
    
    bne $t6, $t3, continue  # $t5 != 1, go continue
    addi $t1, $t1, 1    # nn++
    
    continue:
    addi $s5, $s5, 1    # y++
    j for2
exit_n2:
###############################E-for 2##################################
    addi $s4, $s4, 1    # x++
    j for1
exit_n1:
###############################E-for 1##################################
	move $s7, $t1
	lw  $s6, -16($fp)
	lw	$s5, -12($fp)	# restore $s4 value
	lw	$s4, -8($fp)	# restore $s5 value
	lw	$ra, -4($fp)	# restore $ra for return
	la	$sp, 4($fp)	# restore $sp (remove stack frame)
	lw	$fp, ($fp)	# restore $fp (remove stack frame)
	jr	$ra		# return
	
decideCell:	# old = board[i][j], nn = $s7
    sw	$fp, -4($sp)	# push $fp onto stack
	la	$fp, -4($sp)	# set up $fp for this function
	sw	$ra, -4($fp)	# save return address
	sw	$s4, -8($fp)	# save $s4 to use as ... char ret;
	addi	$sp, $sp, -12	# reset $sp to last pushed item
	
	la  $t1, board      # $t1 hold addres for board
	mul $t2, $s2, $t0   # $t2 = row*N
	add $t2, $t2, $s3   # $t2 = row*N + col
	add $t1, $t1, $t2   # $t1 = board[i][j]
	lb $t1, ($t1)     # old = board[i][j], old = $t1
	
	if:
	li  $t2, 1  # $t2 = 1
	bne $t1, $t2, else   # if(old == 1)
	    if2:
	        li  $t2, 2 # $t2 = 2
	        bge $s7, $t2, else2 # $s7 >= 2, goes to else2
	        li $s4, 0   # ret = 0
	        j finish    # if (nn < 2)
	    else_if2:
	        li  $s4, 1  # ret = 1
	        j finish
	    else2:
	        li  $t2, 2  # $t2 = 2
	        beq $s7, $t2, else_if2
	        
	        li  $t2, 3  # $t2 = 3
	        beq $s7, $t2, else_if2
	        
	        li  $s4, 0  # ret = 0
	        j finish
	else_if:
	    li  $s4, 1  #ret = 1
	    j finish
	else:
	    li $t2, 3   # $t2 = 3
	    beq $s7, $t2, else_if   # if(nn == 3), gos to else_if
	    li  $s4, 0  # ret = 0
	    j finish
	    
	finish:
    move $t1, $s4   # newboard[i][j] = return
	lw	$s4, -8($fp)	# restore $s4 value
	lw	$ra, -4($fp)	# restore $ra for return
	la	$sp, 4($fp)	# restore $sp (remove stack frame)
	lw	$fp, ($fp)	# restore $fp (remove stack frame)
	jr	$ra		# return
	
copyBackAndShow:
    sw	$fp, -4($sp)	# push $fp onto stack
	la	$fp, -4($sp)	# set up $fp for this function
	sw	$ra, -4($fp)	# save return address
	sw	$s4, -8($fp)	# save $s4 to use as ... char ret;
	addi	$sp, $sp, -12	# reset $sp to last pushed item
	lw  $t0, N
	li  $t1, 0      # $t1 = i = 0
###############################S-Loop 1##################################
	loop1:  # for (int i = 0; i < N; i++)
	bge $t1, $t0, end_loop1
	li  $t2, 0      # $t2 = j = 0
###############################S-Loop 2##################################
	loop2:
	bge $t2, $t0, end_loop2
	
	la  $t4, board  # $t4 hold addres for board
	mul $t3, $t1, $t0   # $t3 = N*row
	add $t3, $t3, $t2   # $t3 = N*row+col
	
	la  $t5, newBoard  # t5 hold address for newboard
	add $t5, $t5, $t3   # $t5 = newboard[i][j]
	lb  $t5, ($t5)      # $t5 = newboard
	
	add $t4, $t4, $t3      # $t4 = board[i][j]
	sb  $t5, ($t4)
	
	lb  $t4, ($t4)      # board[i][j] = newBoard[i][j]
	#move $a0, $t5       
	#li $v0, 1
	#syscall 
	li  $t5, 0
	bne $t4, $t5, one
	
	la $a0, msg4        # print ''
	li $v0, 4
	syscall
	j printed
	
	one:
	la  $a0, msg5
	li  $v0, 4
	syscall
	j printed
	
	printed:
	addi $t2, $t2, 1    # j++
	j loop2
	end_loop2:
###############################E-Loop 2##################################
    la $a0, eol
    li $v0, 4
    syscall
       
    addi $t1, $t1, 1 # i++
    j loop1
	end_loop1:
###############################E-Loop 1##################################
	lw	$s4, -8($fp)	# restore $s4 value
	lw	$ra, -4($fp)	# restore $ra for return
	la	$sp, 4($fp)	# restore $sp (remove stack frame)
	lw	$fp, ($fp)	# restore $fp (remove stack frame)
	jr	$ra		# return
