
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
  lui $1,4097
  nop
  nop
  nop
  ori $4,$1,0
  lui $1,4097
  nop
  nop
  nop
  ori $5,$1,20

  # Print array before sorting
  addiu $2,$0,4
  lui $1,4097
  nop
  nop
  nop
  ori $4,$1,26
  syscall  
  lui $1,4097
  nop
  nop
  nop
  ori $4,$1,0
  lui $1,4097
  nop
  nop
  nop
  ori $5,$1,20
  nop
  nop
  nop
  jal printArray  
  nop
  nop

  # Sort the array
  lui $1,4097
  nop
  nop
  nop
  ori $4,$1,0
  lui $1,4097
  nop
  nop
  nop
  lw $5,20($1)
  nop
  nop
  nop
  jal bubbleSort  
  nop
  nop

  # Print array after sorting
  addiu $2,$0,4
  lui $1,4097 
  nop
  nop
  nop
  ori $4,$1,24
  syscall  
  addiu $2,$0,4   
  lui $1,4097 
  nop
  nop
  nop
  ori $4,$1,50
  syscall 
  lui $1,4097
  nop
  nop
  nop
  ori $4,$1,0
  lui $1,4097
  nop
  nop
  nop
  ori $5,$1,20
  nop
  nop
  nop
  jal printArray  
  nop
  nop

  # End Program
  addiu $2,$0,10
  syscall         # End the program  
  halt




printArray:  
  lw $t1, 0($a1)       # Load array size into $t1
  nop
  nop
  nop
  addiu $8,$0,0

  # Load the address of the array into a temporary register
  addu $11,$0,$4
  nop
  nop
  nop

loop:  
  lw $t2, 0($t3)      # Load value from array into $t2
  addiu $2,$0,1           # Print integer syscall
  nop
  nop
  addu $4,$0,$10       # Move value to $a0 for printing  
  syscall             # Print the integer  

  addiu $2,$0,4           # Print string syscall (for space or newline)  
  lui $1,4097 
  nop
  nop
  nop
  ori $4,$1,73
  syscall  

  addi $t3, $t3, 4    # Increment array pointer by 4 bytes
  addi $t0, $t0, 1    # Increment index  
  nop
  nop
  nop     
  slt $1,$8,$9
  nop
  nop
  nop
  bne $1,$0, loop
  #blt $t0, $t1, loop  # Loop until index is less than array size  
  nop     
  nop
  jr $ra              # Return  
  nop
  nop




















#int $a0 arr[]
#int $a1 n
# Define function
bubbleSort:

  addi $t0, $zero, 0      # boolean swapped;
  addi $t1, $zero, 0      # int i;
  addi $t2, $zero, 0      # int j;
  addi $t3, $a1, -1        # int length = n-1;
  ori $1,$0,0
  nop
  nop
  nop
  add $12,$4,$1

  FirstLoop:
      # for i < length
      slt $1,$9,$11
      nop
      nop
      nop
      beq $1,$0,Exit
      #bge $t1, $t3, Exit
      nop
      nop
      addi $t0, $zero, 0      # swapped = false;
    
          addi $t2, $zero, 0      # j = 0;
      SecondLoop:
          # for j < length - i
          sub $t5, $t3, $t1      # $t5 = length - i;
          nop
          nop
          nop
          slt $1,$10,$13
          nop
          nop
          nop
          beq $1,$0,StartIf2
          #bge $t2, $t5,  StartIf2
          nop
          nop

          # setup if cond
          sll $t6, $t2, 2  # $t6 = j * 4
          nop
          nop
          nop
          add $t6, $t4, $t6  # $t6 = &arr[j]
        
          addi $t2, $t2, 1  # j = j + 1
          nop
          nop
          nop
          sll $t7, $t2, 2  # $t7 = j * 4
          addi $t2, $t2, -1  # j = j - 1
          nop
          nop
          add $t7, $t4, $t7  # $t7 = &arr[j+1]

          # at this point
          # $t6 contains &arr[j] and $t7 contains &arr[j+1]

          # load elements
          lw $t8, 0($t6) 
          nop
          nop  
          lw $t9, 0($t7)

          StartIf:
              nop
              nop
              nop
              slt $1,$25,$24
              nop
              nop
              nop
              beq $1,$0,EndIf
              #ble $t8, $t9, EndIf # if
              nop
              nop
              # prefrom swap
              sw $t8, 0($t7)
              sw $t9, 0($t6)
              addi $t0, $t0, 1  # swapped = true;
          EndIf:

          # this is the end of the first loop
          addi $t2, $t2, 1        # j = j + 1;
          j SecondLoop
          nop
          nop

  StartIf2:
      nop
      nop
      bne $t0, $zero, EndIf2 # if swapped == false
      nop
      nop
      j Exit # break;
      nop
      nop
  EndIf2:

      # this is the end of the first loop
      addi $t1, $t1, 1        # i = i + 1;
      j FirstLoop
      nop
      nop
Exit:
  jr $ra                  # Return  
  nop
  nop
