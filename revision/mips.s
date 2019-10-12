$s0 #i
$s1 #j

    lw  $t0, n
init_loop:
    li  $s0, 0
condition:
    bge $s0, $t0 loop_finish

    li  $t1, 2

    la  $t2, a1 #a1的地址
    li  $t3, 4  #t3=4
    mult  $t3, $t3, $s0
    add $t2, $t2, $t3   #t2 = a1的地址+ith offset
    lw  $t2, ($t2)  #$t2 = src[i]

    div  $t2, $t1   #$t2/$t1
    mfhi $t1    #t1 = src[i]%2

    li $t3, 0
    beq		$t1, $t3, is_even	# if $t1 == 0
is_odd:
    jal finish

is_even:
    la  $t4, a2
    li  $t3, 4  #t3 = 4
    mult $t3, $t3, $s1
    add  $t4, $t4, $t3
    sw	 $t2, ($t4)

    addi $s1, $s1, 1 #j++

finish:
    addi $s0, 1 #i++
    jal condition
loop_finish:

