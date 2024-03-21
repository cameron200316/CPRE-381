.data
arr: .word 5, 3, 9, 1, 7     # Example array to be sorted
n: .word 5                   # Number of elements in the array

newline: .asciiz "\n"
arr_msg: .asciiz "Array before sorting: \n"
arr_sorted_msg: .asciiz "Array after sorting: \n"
space: .asciiz " "

.text
main:
    # Load array address and size
    la $a0, arr     # Load array address into $a0
    la $a1, n       # Load array size into $a1

    # Print array before sorting
    li $v0, 4       
    la $a0, arr_msg
    syscall
    la $a0, arr
    la $a1, n
    jal printArray

    # Sort the array
    la $a0, arr
    lw $a1, n
    jal bubbleSort

    # Print array after sorting
    li $v0, 4
    la $a0, newline
    syscall
    li $v0, 4      
    la $a0, arr_sorted_msg
    syscall
    la $a0, arr
    la $a1, n
    jal printArray

    # End Program
    li $v0, 10      # Set system call to end program
    syscall         # End the program

printArray:
    lw $t1, 0($a1)       # Load array size into $t1
    li $t0, 0            # Initialize index to 0

    # Load the address of the array into a temporary register
    move $t3, $a0

loop:
    lw $t2, 0($t3)      # Load value from array into $t2
    li $v0, 1           # Print integer syscall
    move $a0, $t2       # Move value to $a0 for printing
    syscall             # Print the integer
    
    li $v0, 4           # Print string syscall (for space or newline)
    la $a0, space
    syscall
    
    addi $t3, $t3, 4    # Increment array pointer by 4 bytes
    addi $t0, $t0, 1    # Increment index
    blt $t0, $t1, loop  # Loop until index is less than array size
    jr $ra              # Return





#int $a0 arr[] 
#int $a1 n
# Define function
bubbleSort:

    addi $t0, $zero, 0      # boolean swapped;
    addi $t1, $zero, 0      # int i;
    addi $t2, $zero, 0      # int j;
    subi $t3, $a1, 1        # int length = n-1;
    la $t4, 0($a0)          # $t1 = &arr[0]

    FirstLoop:
        # for i < length
        bge $t1, $t3, Exit
        addi $t0, $zero, 0      # swapped = false;
        
            addi $t2, $zero, 0      # j = 0;
        SecondLoop:
            # for j < length - i
            sub $t5, $t3, $t1      # $t5 = length - i;
            bge $t2, $t5, StartIf2  

            # setup if cond
            sll $t6, $t2, 2  # $t6 = j * 4
            add $t6, $t4, $t6  # $t6 = &arr[j]
            
            addi $t2, $t2, 1  # j = j + 1
            sll $t7, $t2, 2  # $t7 = j * 4
            subi $t2, $t2, 1  # j = j - 1
            add $t7, $t4, $t7  # $t7 = &arr[j+1]

            # at this point
            # $t6 contains &arr[j] and $t7 contains &arr[j+1]

            # load elements
            lw $t8, 0($t6)     
            lw $t9, 0($t7)

            StartIf:
                ble $t8, $t9, EndIf # if 
                # prefrom swap
                sw $t8, 0($t7)
                sw $t9, 0($t6)
                addi $t0, $t0, 1  # swapped = true;
            EndIf:

            # this is the end of the first loop
            addi $t2, $t2, 1        # j = j + 1;
            j SecondLoop

    StartIf2:
        bne $t0, $zero, EndIf2 # if swapped == false
        j Exit # break;
    EndIf2:

        # this is the end of the first loop
        addi $t1, $t1, 1        # i = i + 1;
        j FirstLoop
Exit:
    jr $ra                  # Return