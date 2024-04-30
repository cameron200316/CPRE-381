.data
    value: .word 5
.text
.globl main
main:
    addi $t1, $zero, 1
    lw $t2, value
    #distance of 1 (from $t2 write to read)
    add $zero, $t1, $t2

    #distance of 1 (from $zero write to read)
    add $zero, $t1, $zero

    halt

