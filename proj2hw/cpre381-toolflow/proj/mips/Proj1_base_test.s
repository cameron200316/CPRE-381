.data
   # Data section
   array: .word 1, 2, 3, 4
   result: .word 0

.text


   addi $t0, $zero, 1
   addi $t1, $zero, 2 
   addi $t2, $zero, 3
   addi $t3, $zero, 4
   addi $t4, $zero, 5
   addi $s0, $zero, 10
   addi $s1, $zero, 15


   add $t5, $t0, $t1  
   addu $t6, $t0, $t1  
   addiu $t7, $t2, 5  


Loop:


   # And instruction
   and $t8, $t2, $t3  
   # Andi instruction
   andi $t9, $t4, 15  
   # Lui instruction
   lui $s3, 32768  
   # Lw instruction
   lw $t8, array   # Load word from array into $t8
   # Nor instruction
   addi $t0, $t0, -1
   add $t1, $t1, $t2
   nor $t9, $t5, $t6  
   # Xor instruction
   xor $t9, $t7, $t7  
   # Xori instruction
   xori $t9, $t7, 255 
   # Or instruction
   or $s2, $t8, $t7  
   # Ori instruction
   ori $s3, $s4, 1023

   # Beq instruction
   beq $t0, $zero, Loop 
   nop
   nop
   nop
   nop
   nop
   nop
   nop
   nop


   # Sllv instruction
   sllv $t2, $t1, $t1  
   # Srlv instruction
   srlv $t5, $t3, $t4 
   # Srav instruction
   srav $t8, $t6, $t7 
 


Loop2:

   addi $t3 $zero, 0
   addi $t2 $zero, 0

   # Slt instruction
   slt $s5, $t9, $s0 
   # Slti instruction
   slti $s6, $s1, -1  
   # Sll instruction
   sll $s7, $s2, 2 
   # Srl instruction
   srl $s0, $s3, 2  
   # Sra instruction
   sra $t0, $s4, 1   
   # Sw instruction
   sw $t1, result  
   # Sub instruction
   sub $t4, $t2, $zero  
   # Subu instruction
   subu $t7, $t6, $t5 

   # Bne instruction
   bne $t2, $t3, Loop2 
   nop
   nop
   nop
   nop
   # J instruction
   j exit
   nop
   nop
   nop
   nop


funct:


   # Lb instruction
   lb $s0, array  
   # Lh instruction
   lh $s1, array  
   # Lbu instruction
   lbu $s2, array 
   # Lhu instruction
   lhu $s3, array 


   # Jr instruction
   jr $ra
   nop
   nop
   nop
   nop


exit:
   # Jal instruction
   jal  funct
   nop
   nop
   nop
   nop
   halt
