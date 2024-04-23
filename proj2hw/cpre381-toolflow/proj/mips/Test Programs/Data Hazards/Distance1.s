.data
.text
.globl main
main:
    addi $t1, $zero, 1
    
    #distance of 2 (from $t1 write to read)
    add $t2, $t1, $zero

    halt

