# COMP1521 17s2 Final Exam
# void colSum(m, N, a)

   .text
   .globl colSum

# params: m=$a0, N=$a1, a=$a2
colSum:
# prologue
   addi $sp, $sp, -4
   sw   $fp, ($sp)
   la   $fp, ($sp)
   addi $sp, $sp, -4
   sw   $ra, ($sp)
   addi $sp, $sp, -4
   sw   $s0, ($sp)
   addi $sp, $sp, -4
   sw   $s1, ($sp)
   addi $sp, $sp, -4
   sw   $s2, ($sp)
   addi $sp, $sp, -4
   sw   $s3, ($sp)
   addi $sp, $sp, -4
   sw   $s4, ($sp)
   addi $sp, $sp, -4
   sw   $s5, ($sp)
   # if you need to save more than six $s? registers
   # add extra code here to save them on the stack

# suggestion for local variables (based on C code):
# m=#s0, N=$s1, a=$s2, row=$s3, col=$s4, sum=$s5
   # add code for your colSum function here

   move  $s1, N
   la  $s0, m

init_loop_1:
   li $s4, 0 #col = 0
   
loop1_condition:
   bge $s4, $s1 j finish_1

init_loop_2:
   li $s5 0 #sum = 0
   li $s3 0 #row = 0
loop2_condition:
   bge $s3, $s1 j finish_2
   
   la $s0, a
   
   mult $t1, $s3, $s1   #$t1 = row *N
   add $t1, $t1, $s4 #$t1 = row*N + col
   mul $t1, $t1, 4

   add $t0, $s0, $t1 

   lw $t0, ($t0)
   add $s5, $s5, $t0 #sum += m[col][row]  

   addi $s4, 1 #row++
   jal loop2_condition
finish_2:

   li $t0, 0
   add $t0, $t0, $s4
   mul $t0, $t0, 4   #t0*4
   
   la  $s2, a
   add $s2, $s2, $t0
   sw		$s5, ($s2) 
    
   addi $s4, 1 #col++
   jal loop1_condition
finish_1:


# epilogue
   # if you saved more than six $s? registers
   # add extra code here to restore them
   lw   $s5, ($sp)
   addi $sp, $sp, 4
   lw   $s4, ($sp)
   addi $sp, $sp, 4
   lw   $s3, ($sp)
   addi $sp, $sp, 4
   lw   $s2, ($sp)
   addi $sp, $sp, 4
   lw   $s1, ($sp)
   addi $sp, $sp, 4
   lw   $s0, ($sp)
   addi $sp, $sp, 4
   lw   $ra, ($sp)
   addi $sp, $sp, 4
   lw   $fp, ($sp)
   addi $sp, $sp, 4
   j    $ra

