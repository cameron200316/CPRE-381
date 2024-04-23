.data
.text
.globl main
main:
   
    addi $zero, $zero, 1
    addi $at, $zero, 0

    addi $v0, $zero, 1
    addi $v1, $zero, 2
    addi $a0, $zero, 3
    addi $a1, $zero, 4
    addi $a2, $zero, 5
    addi $a3, $zero, 6

    addi $t0, $zero, 1
    addi $t1, $zero, 2
    addi $t2, $zero, 3
    addi $t3, $zero, 4
    addi $t4, $zero, 5
    addi $t5, $zero, 6
    addi $t6, $zero, 7
    addi $t7, $zero, 8
    addi $t8, $zero, 9
    addi $t9, $zero, 10

    addi $s0, $t0, 0
    addi $s1, $t1, 0
    addi $s2, $t2, 0
    addi $s3, $t3, 0
    addi $s4, $t4, 0
    addi $s5, $t5, 0
    addi $s6, $t6, 0
    addi $s7, $t7, 0

    halt
