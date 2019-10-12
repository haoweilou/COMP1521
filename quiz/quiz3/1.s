.data
EOL:     .asciiz "\n"
.text
    .globl  main
main:
   add $t1, $0, $0
   lui $t1, 0x4321
   
   move $a0, $t1
   li   $v0, 1
   syscall

   la  $a0, EOL
   li   $v0, 4
   syscall
   
   ori $t1, $t1, 0x8765
   
   move $a0, $t1
   li   $v0, 1
   syscall
   
    la  $a0, EOL
   li   $v0, 4
   syscall
   
li $t1, 0x43218765
   move $a0, $t1
   li   $v0, 1
   syscall
   
   
   jr $ra
  
