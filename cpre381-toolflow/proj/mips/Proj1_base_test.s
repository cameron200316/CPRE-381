.data
    # Data section
    array: .word 1, 2, 3, 4
    value1: .word 5
    value2: .word 2
    result: .word 0

.text

    # Add instruction
    lw $t0, array    # Load array element 1 into $t0
    lw $t1, array+4   # Load array element 2 into $t1
    add $t2, $t0, $t1   # $t2 = $t0 + $t1

    # Addi instruction
    lw $t3, value1   # Load value1 into $t3
    addi $t3, $t3, 10   # $t3 = $t3 + 10 

    # Addiu instruction
    lw $t4, value2   # Load value2 into $t4
    addiu $t4, $t4, 5   # $t4 = $t4 + 5

Loop:

    # Addu instruction
    addu $t5, $t3, $t4   # $t5 = $t3 + $t4
    # And instruction
    and $t6, $t5, $t2   # $t6 = $t5 & $t2
    # Andi instruction
    andi $t6, $t6, 15   # $t6 = $t6 & 15
    # Lui instruction
    lui $t7, 32768   
    # Lw instruction
    lw $t8, array   # Load word from array into $t8
    # Nor instruction
    nor $t9, $t8, $t6   # $t9 = ~($t8 | $t6)
    # Xor instruction
    xor $t9, $t9, $t7   # $t9 = $t9 ^ $t7
    # Xori instruction
    xori $t9, $t9, 255  # $t9 = $t9 ^ 255
    # Or instruction
    or $s0, $t9, $t7    # $s0 = $t9 | $t7
    # Ori instruction
    ori $s0, $s0, 1023  # $s0 = $s0 | 1023

    # Beq instruction
    beq $s0, $zero, Loop  

   

Loop2:

    # Slt instruction
    slt $s1, $t9, $s0   # $s1 = ($t9 < $s0)
    # Slti instruction
    slti $s1, $s1, -1   # $s1 = ($s1 < -1)
    # Sll instruction
    sll $s2, $s1, 2     # $s2 = $s1 << 2
    # Srl instruction
    srl $s2, $s2, 2     # $s2 = $s2 >> 2
    # Sra instruction
    sra $s2, $s2, 1     # $s2 = $s2 >> 1
    # Sw instruction
    sw $s2, result   # Store $s2 into result
    # Sub instruction
    sub $s3, $s0, $s1   # $s3 = $s0 - $s1
    # Subu instruction
    subu $s3, $s3, $s2   # $s3 = $s3 - $s2

    # Bne instruction
    bne $s3, $zero, exit  
    # J instruction
    j Loop2

funct:

    # Lb instruction
    lb $t0, array   
    # Lh instruction
    lh $t1, array   
    # Lbu instruction
    lbu $t2, array  
    # Lhu instruction
    lhu $t3, array  
    # Sllv instruction
    sllv $t4, $t0, $t2   # $t4 = $t0 << $t2
    # Srlv instruction
    srlv $t4, $t4, $t1   # $t4 = $t4 >> $t1
    # Srav instruction
    srav $t4, $t4, $t3   # $t4 = $t4 >> $t3

    # Jr instruction
    jr $ra 

exit:
    # Jal instruction
    jal  funct
    nop