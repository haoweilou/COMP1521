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

# Frame:	$fp, $ra, $s0, $s1, $s2, $s3, $s7
# Uses:		$a0, $v0, $s0, $s1, $s2, $s3, $s7, $t0, $t1, $t2, $t3
# Clobbers:	$a0, $t0, $t1, $t2, $t3

# Locals:	
#   - 'msg1' in $a0
#   - maxiters in $s0
#   - n in $s1
#   - row in $s2
#   - col in $s3
#   - result from neighbours in $s7
#   - 'N' in $t0
#   - 'newboard' in $t3

# Structure:
#	main
#	-> [prologue]
#	    -> main_init
#	    -> maxiters_init
#	    -> maxiters_condition
#	    -> maxiters_step
#	 	   -> i_init
#	 	   -> i_condition
#	 	   -> i_step
#	  	  		-> j_init
#	    		-> j_condition
#	    		-> j_step
#	    		-> j_finish
#			-> i_finish
#	    -> maxiters_finish
#		-> main__post:
#	-> [epilogue]

# Code:
    #setup stack
main_init:
    sw	$fp, -4($sp)	# push $fp onto stack
	la	$fp, -4($sp)	# set up $fp for this function
	sw	$ra, -4($fp)	# save return address
	sw	$s0, -8($fp)	# save $s0 to use as ... int maxiters
	sw  $s1, -12($fp)    # save $s1 to use as ... int n
	sw  $s2, -16($fp)    # save $s2 to use as ... int i
	sw  $s3, -20($fp)    # save $s3 to use as ... int j
	sw  $s7, -24($fp)    # save $s7 to use as ... int nn
	addi $sp, $sp, -28   # reset $sp to last pushed item
	
	li  $s0, 0   # maxiters = 0
	li  $s1, 1   # n = 1
	li  $s2, 0   # i = 0
	li  $s3, 0   # j = 0
	
	la  $a0, msg1        #printf("# Iterations: ");
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall		        # scanf("%d") into $v0
################################S-Loop 1########################################
maxiters_init:    
	move $s0, $v0       # $s0 = $v0 	
maxiters_condition:                  #while(n <= maxiters)
    bgt $s1, $s0, maxiters_finish 
    lw  $t0, N   # $t0 = N
################################S-Loop 2########################################
i_init:
    li  $s2, 0   # i = 0 
i_condition:          # while(i < N)            
    bge $s2, $t0, i_finish
################################S-Loop 3########################################
j_init:
    li  $s3, 0  # j = 0
j_condition:          # while(j < N)
    bge $s3, $t0, j_finish  
	lw  $t0, N  # $t0 = N 
	
    jal neighbours      # int nn = $t1, $s7 = nn
    mul $t2, $s2, $t0   # $t2 = row * N
    add $t2, $t2, $s3   # $t2 = row + col

    la  $t3, newBoard   # $t3 hold base for newBoard
    add $t3, $t3, $t2   # $t3 = address for newboard[i][j]
    
    jal decideCell      # $t1 is the return value of decidecell
    sb  $t1, ($t3)      # newboard[i][j] = $t1
                        
    
    addi $s3, $s3, 1    # j++
    j j_condition
j_finish:
###########################E-Loop 3#################################### 
    addi $s2, $s2, 1    # i++
    j i_condition
i_finish:
#############################E-Loop 2##################################  
    
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
    
    j maxiters_condition
maxiters_finish:
############################E-Loop 1#################################### 
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
################################################################################
#                                neighbours                                    #
################################################################################
# Frame:	$fp, $ra, $s4, $s5, $s6
# Uses:		$s4, $s5, $s2, $s3, $s7, $t1, $t2, $t3, $t4, $t5, $t6, $t7
# Clobbers:	$t1, $t2, $t3, $t3, $t4, $t5, $t6, $t7

# Locals:	
#   - nn in $t2
#   - $s7 holds the return value
#   - $s2 holds for row
#   - $s3 holds for col
#   - $s4 holds x
#   - $s5 holds y
#   - $s6=0

# Structure:
#	neighbours:
#	-> [prologue]
#	    -> neighbours_init
#	    	-> x_init
#	    	-> x_condition
#	    	-> x_step
#	    		-> y_init
#	    		-> y_condition
#	    		-> y_step
#	    			-> not_pass
#	    			-> continue
#	        	-> y_finish
#	        -> x_finish
#		-> neighbours_finish
#	-> [epilogue]

neighbours:
    sw	$fp, -4($sp)	# push $fp onto stack
	la	$fp, -4($sp)	# set up $fp for this function
	sw	$ra, -4($fp)	# save return address
	sw	$s4, -8($fp)	# save $s4 to use as ... int x;
	sw	$s5, -12($fp)	# save $s5 to use as ... int y;
	sw  $s6, -16($fp)   # save $s6 to be 0  
	addi	$sp, $sp, -20	# reset $sp to last pushed item
neighbours_init:
    lw  $t0, N
    li  $t1, 0
    addi $t7, $t0, -1   # $t7 = N - 1 
    
    li  $t2, 0      # int nn = 0
    li  $t3, 1      # $t3 = 1
    li  $s6, 0      # $s6 = 0
###############################S-for 1##################################
x_init:
	li  $s4, -1	    # int x = -1
x_condition:
    bgt $s4, $t3, x_finish # if x<= 1
###############################S-for 2##################################
y_init:
    li  $s5, -1     # int y = -1
y_condition:
    bgt $s5, $t3, y_finish # if y<=1
    
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
    la  $t4, board      # $t4 holds address for board
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
    j y_condition
y_finish:
###############################E-for 2##################################
    addi $s4, $s4, 1    # x++
    j x_condition
x_finish:
###############################E-for 1##################################
neighbours_finish:

	move $s7, $t1
	lw  $s6, -16($fp)   # restore $s6 value
	lw	$s5, -12($fp)	# restore $s5 value
	lw	$s4, -8($fp)	# restore $s4 value
	lw	$ra, -4($fp)	# restore $ra for return
	la	$sp, 4($fp)	# restore $sp (remove stack frame)
	lw	$fp, ($fp)	# restore $fp (remove stack frame)
	jr	$ra		# return
	
	
################################################################################
#                                decideCell                                    #
################################################################################
# Frame:	$fp, $ra, $s4
# Uses:		$s4, $t1, $t2
# Clobbers:	$t2

# Locals:	
#   - $s4 holds ret
#   - $t1 holds return value

# Structure:
#	decideCells:
#	-> [prologue]
# 	-> decideCell_init
#	    -> if
#	        -> if2
#	        -> else_if2
#    	    -> else2
#	    -> else_if
#	    -> else
# 	-> decideCell_finish
#	-> [epilogue]

decideCell:	# old = board[i][j], nn = $s7
    sw	$fp, -4($sp)	# push $fp onto stack
	la	$fp, -4($sp)	# set up $fp for this function
	sw	$ra, -4($fp)	# save return address
	sw	$s4, -8($fp)	# save $s4 to use as ... char ret;
	addi	$sp, $sp, -12	# reset $sp to last pushed item
decideCell_init:
	la  $t1, board      # $t1 hold addres for board
	mul $t2, $s2, $t0   # $t2 = row*N
	add $t2, $t2, $s3   # $t2 = row*N + col
	add $t1, $t1, $t2   # $t1 = board[i][j]
	lb $t1, ($t1)     # old = board[i][j], old = $t1
	
if:
	li  $t2, 1  # $t2 = 1
	bne $t1, $t2, else   # if(old == 1)
	    if2_init:
	        li  $t2, 2 # $t2 = 2 # if (nn < 2)
	        bge $s7, $t2, else2 # $s7 >= 2, goes to else2
	        li $s4, 0   # ret = 0
	        j decideCell_finish 
	    else_if2:       # if(nn == 2 || nn == 3)
	        li  $s4, 1  # ret = 1
	        j decideCell_finish
	    else2:          # else
	        li  $t2, 2  # $t2 = 2
	        beq $s7, $t2, else_if2
	        
	        li  $t2, 3  # $t2 = 3
	        beq $s7, $t2, else_if2
	        
	        li  $s4, 0  # ret = 0
	        j decideCell_finish
	else_if:        # if(nn == 3)
	    li  $s4, 1  #ret = 1
	    j decideCell_finish
	else:
	    li $t2, 3   # $t2 = 3, # else
	    beq $s7, $t2, else_if   # if(nn == 3), gos to else_if
	    li  $s4, 0  # ret = 0
	    j decideCell_finish
	decideCell_finish:
	
    move $t1, $s4   # newboard[i][j] = return
	lw	$s4, -8($fp)	# restore $s4 value
	lw	$ra, -4($fp)	# restore $ra for return
	la	$sp, 4($fp)	# restore $sp (remove stack frame)
	lw	$fp, ($fp)	# restore $fp (remove stack frame)
	jr	$ra		# return
################################################################################
#                             copyBackAndShow                                  #
################################################################################
# Frame:	$fp, $ra, $s4
# Uses:		$s4, $t1, $t2
# Clobbers:	$t2

# Locals:	
#   - $a0 used to print

# Structure:
#	copyBackAndShow:
#	-> [prologue]
#	    -> copyBackAndShow_init
#	        -> pi_init
#	        -> pi_condition
#	            -> pj_init
#       	    -> pj_condition
#       	    	-> eqlzero
#       	    	-> eqlone
#					-> finish_print
#       	    -> pj_finish
#	        -> pi_finish
#		-> copyBackAndShow_finish
#	-> [epilogue]	

copyBackAndShow:
    sw	$fp, -4($sp)	# push $fp onto stack
	la	$fp, -4($sp)	# set up $fp for this function
	sw	$ra, -4($fp)	# save return address
	addi	$sp, $sp, -8	# reset $sp to last pushed item
copyBackAndShow_init:
	lw  $t0, N
###############################S-Loop 1##################################
pi_init:  # for (int i = 0; i < N; i++)
	li  $t1, 0      # $t1 = i = 0
pi_condition:
	bge $t1, $t0, pi_finish
pi_step:
###############################S-Loop 2##################################
pj_init:
	li  $t2, 0      # $t2 = j = 0
pj_condition:
	bge $t2, $t0, pj_finish # for (int j = 0; i < N; j++)
	
	la  $t4, board  # $t4 hold addres for board
	mul $t3, $t1, $t0   # $t3 = N*row
	add $t3, $t3, $t2   # $t3 = N*row+col
	
	la  $t5, newBoard # t5 hold address for newboard
	add $t5, $t5, $t3   # $t5 = newboard[i][j]
	lb  $t5, ($t5)      # $t5 = newboard
	
	add $t4, $t4, $t3      # $t4 = board[i][j]
	sb  $t5, ($t4)
	
	lb  $t4, ($t4)      # board[i][j] = newBoard[i][j]
	li  $t5, 0
	bne $t4, $t5, eqlone   # if(board[i][j] != 0)

eqlzero:	
	la $a0, msg4        # printf '.'(equal to 0)
	li $v0, 4
	syscall
	j finish_print
	
eqlone:
	la  $a0, msg5       # pirntf '#'(not equal to 0)
	li  $v0, 4
	syscall
	j finish_print
	
finish_print:
	addi $t2, $t2, 1    # j++
	j pj_condition
pj_finish:
###############################E-Loop 2##################################
    la $a0, eol
    li $v0, 4
    syscall
       
    addi $t1, $t1, 1 # i++
    j pi_condition
pi_finish:
###############################E-Loop 1##################################
copyBackAndShow_finish:
	la	$sp, 4($fp)	# restore $sp (remove stack frame)
	lw	$fp, ($fp)	# restore $fp (remove stack frame)
	jr	$ra		# return