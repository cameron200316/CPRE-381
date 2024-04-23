.data
    value: .word 5
.text
.globl main
main:
    addi $t1, $zero, 1
    lw $t2, value   

    #distance of 1 (from $t1 write to read)
    add $t3, $t2, $t1

    halt

