.data
prompt1: .asciiz "Enter the sequence index\n"

.text
main:
    addi $t0, $zero 4           # loop counter

loop:
    lui $t1, 1          
    srl $t1, $t1, 16   
    nor $t1, $t1, $zero 
    xor $t1, $t1, $zero
    or $t1, $t1, $zero 
    sll $t1, $t1, 1     
    sra $t1, $t1, 1    
    lb $t2, 0($t1)      
    lh $t3, 0($t1)    
    lbu $t4, 0($t1)    
    lhu $t5, 0($t1)     
    sllv $t6, $t1, $t0  
    srlv $t7, $t1, $t0  
    srav $t8, $t1, $t0  
    addi $t0, $t0, -1   # Decrement loop counter
    bne $t0, $zero past      # Branch if loop counter is not zero
    j loop              # Jump to past label

past:
   	# Printing out the text
	li $v0, 4	#set system call to print string mode
   	la $a0, prompt1	#set $a0 with the string to print
	syscall		#print the string in $a0

	# Getting user input
	addiu $v0, $zero, 5	#set system call to input mode
	syscall		#ask for user input and store in #a0
    
	# call fibnum function
	add $a0, $v0, $zero
	jal fibnum
	add $t0, $v0, $zero

	# Printing out the number
	andi $v0, $v0, 0    #clearing v0
	ori $v0, $zero, 1	#set system call to print int mode
	add $a0, $t0, $zero	#move number in $v0 to $a0 to print
	syscall 	#print interger in $a0

	# End Program
	and $v0, $v0, $zero #clearing v0
	xori $v0, $zero, 10	#set system call to end program
	syscall		#end the program
	
# MIPS assembly code for fibnum function

# Define function
fibnum:
	
	#$a0 = n
	#bgt $a0, 1, recursive # if the value doesnt pass the base case then recursive again
    lui $t0, 1
    srl $t0, $t0, 16
    slt $at, $t0, $a0
    bne $at, $zero, recursive
	#end loop -- this only happens if the number doesnt pass the base case
	addu $v0, $a0, $zero # set return register $v0 to fib
	jr $ra # Return to caller

recursive:
	addi $sp, $sp, -12 #we need 3 registers to be stored in the stack... so this moves the stack pointer down 3 registers the stack
	sw $ra, 0($sp) #store the return address in the stack
	sw $a0, 4($sp) #store the current value of N in the stack
	
	#call the function
    slti $t0, $zero, 1
    sub $a0, $a0, $t0
	jal fibnum
	sw $v0, 8($sp) #store the returned value of the recursive call
	
	#call the function again
	lw $a0, 4($sp) #because a0 has been changed we need to get the orginal N value from the stack 
    addi $t0, $zero, 2
	subu $a0, $a0, $t0 #this is the N-w parameter
	jal fibnum
	
	lw $t0, 8($sp) # retrieve first function result
	add $v0, $v0, $t0
	lw $ra, 0($sp) # retrieve return address
	addi $sp, $sp, 12
	jr $ra
