# COMP1521 Practice Prac Exam #1
# arrays

    .data

N:  .word  4

m:  .word  2, 5, 3, 4
    .word  1, 7, 2, 7
    .word  6, 6, 4, 5
    .word  2, 5, 3, 4

a:  .space 16

    .align  2
# COMP1521 Practice Prac Exam #1
# main program + show function

   .data
msg1:
   .asciiz "Matrix\n"
msg2:
   .asciiz "Array\n"
   .align  2

   .text
   .globl main
main:
   addi $sp, $sp, -4
   sw   $fp, ($sp)
   la   $fp, ($sp)
   addi $sp, $sp, -4
   sw   $ra, ($sp)

   la   $a0, m
   lw   $a1, N
   la   $a2, a
   jal  colSum       # colSum(m, N, a)

   la   $a0, msg1
   li   $v0, 4
   syscall           # printf("Matrix\n")
   la   $a0, m
   lw   $a1, N
   jal  showMatrix   # showMatrix(m, N)

   la   $a0, msg2
   li   $v0, 4
   syscall           # printf("Array\n")
   la   $a0, a
   lw   $a1, N
   jal  showArray    # showArray(b, N)

   lw   $ra, ($sp)
   addi $sp, $sp, 4
   lw   $fp, ($sp)
   addi $sp, $sp, 4
   j    $ra

# end main()

# void showMatrix(m, N)
# params: m=$a0, N=$a1
# locals: m=$s0, N=$s1, row=$s2, col=$s3
showMatrix:
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

   move $s0, $a0
   move $s1, $a1
   li   $s2, 0
show_matrix_loop1:
   bge  $s2, $s1, end_show_matrix_loop1

   li   $s3, 0
show_matrix_loop2:
   bge  $s3, $s1, end_show_matrix_loop2

   li   $a0, ' '          # putchar(' ')
   li   $v0, 11
   syscall

   move $t0, $s2
   mul  $t0, $t0, $s1
   add  $t0, $t0, $s3
   li   $t1, 4
   mul  $t0, $t0, $t1
   add  $t0, $t0, $s0
   lw   $a0, ($t0)
   li   $v0, 1            # printf("%d",m[row][col])
   syscall

   addi $s3, $s3, 1       # col++
   j    show_matrix_loop2

end_show_matrix_loop2:
   li   $a0, '\n'         # putchar('\n')
   li   $v0, 11
   syscall

   addi $s2, $s2, 1       # row++
   j    show_matrix_loop1

end_show_matrix_loop1:

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

# void showArray(a, N)
# params: a=$a0, N=$a1
# locals: a=$s0, N=$s1, i=$s2
showArray:
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

   move $s0, $a0
   move $s1, $a1
   li   $s2, 0            # i = 0
show_array_for:
   bge  $s2, $s1, end_show_array_for

   li   $a0, ' '          # putchar(' ')
   li   $v0, 11
   syscall

   move $t0, $s2
   mul  $t0, $t0, 4
   add  $t0, $t0, $s0
   lw   $a0, ($t0)
   li   $v0, 1            # printf("%d",a[i])
   syscall

incr_show_array_for:
   addi $s2, $s2, 1       # i++
   j    show_array_for

end_show_array_for:
   li   $a0, '\n'
   li   $v0, 11
   syscall

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

   lw  $s1, $a0
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

