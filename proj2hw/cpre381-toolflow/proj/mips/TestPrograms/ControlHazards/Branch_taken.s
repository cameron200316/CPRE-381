.data
.text
.globl main
main:
    addi $t1, $zero, 1
    addi $t2, $zero, 2
    addi $t3, $zero, 3
    
    beq $zero, $zero, break # Branch always taken

    addi $t4, $zero, 4
    addi $t5, $zero, 5
    addi $t6, $zero, 6

    halt

break:

    addi $t7, $zero, 7
    addi $t8, $zero, 8
    addi $t9, $zero, 9

    halt
