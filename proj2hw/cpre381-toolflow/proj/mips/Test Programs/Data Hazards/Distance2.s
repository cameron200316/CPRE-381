.data
.text
.globl main
main:
    addi $t1, $zero, 1
    # Instruction 1
    nop
    
    #distance of 3 (from $t1 write to read)
    add $t2, $t1, $zero

    halt

