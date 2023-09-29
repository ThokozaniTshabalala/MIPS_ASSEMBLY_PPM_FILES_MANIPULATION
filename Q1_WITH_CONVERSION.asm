.data
filename: .asciiz "C:/Users/27677/OneDrive - University of Cape Town/Documents/CSC2002S/2023/Arch_assignment/subset3.ppm"
buffer:     .space  50288             # Buffer to store the read data
file_descriptor: .word 0            # File descriptor
anError: .asciiz "Error in reading file"
anError2: .asciiz "Error in opening the file"

prompt: .asciiz "Character: "
prompt1: .asciiz "Here\n"
prompt2: .asciiz "Here in parse Loop|\n"
prompt3: .asciiz "before addition: "
prompt4: .asciiz "after addition: "
prompt5: .asciiz "WhiteSpace handling"


dest: .space 128
Total: .word 0

newline: .asciiz "\n" 

.text
.globl main

main: 
     li $v0, 13                   # System call code for open file
     la $a0, filename             # Load the address of the filename
     li $a1, 0                    # Open for reading
     li $a2, 0                    # Mode (ignored for reading)
     syscall                      # Perform the system call
     
         # Check for errors (file descriptor >= 0 means success)
    #move $t0, $v0
    bgez $v0, file_opened
     
     
    li $v0, 1 
    move $a0,$t0
    syscall
    
    li $v0, 4 
    la $a0,anError2
    syscall
    
    li $v0, 10                   # Exit program (error)
    syscall

file_opened:
    move $t0, $v0                # Store the file descriptor in $t0

    # Read data from the file (syscall 14)
    li $v0, 14                   # System call code for read file
    move $a0, $t0                # File descriptor
    la $a1, buffer               # Load the address of the buffer
    li $a2, 50288                 # Maximum number of bytes to read
    syscall                      # Perform the system call
    
    #print the file
    #li $v0, 4 
    #la $a0,buffer
    #syscall

    # Check for errors (bytes read < 0 means error)
    bltz $v0, read_error
    bgez $v0, read_success

read_error:
    li $v0, 4 
    la $a0,anError
    syscall
    
    
    li $v0, 10                   # Exit program (error)
    syscall

read_success:
    # Print the read data (syscall 4)
    #li $v0, 4                    # System call code for print string
    #la $a0, buffer               # Load the address of the buffer
    #syscall                      # Perform the system call
    
    
    
    #save our reference adrresses
    la $s0,buffer
    la $s1, dest
    
    #print without new lines
    #j newLineCheck
    j Done

    # Close the file (syscall 16)
    li $v0, 16                   # System call code for close file
    move $a0, $t0                # File descriptor
    syscall                      # Perform the system call

    # Exit the program
    li $v0, 10                   # System call code for exit
    syscall


saveToStack: 
             #we will store every character byte by byte (1 byte at a time)
            addi $sp,$sp,-1 # create space in the stack that is the size of 1byte
            lb $t1,0($s0)
            sb $t1,0($sp)
            
            beqz $t1,Done
            j saveToStack

Done: 
     #assign values
     
     #p2 first value
     lb $t1,0($s0)  #load 1st byte from $s0
     sb $t1,0($s1)   
     
     addi $s0,$s0,1  #increment address by 1, move up by 1
     lb $t1,0($s0)   #load 2nd byte from $s0
     
     addi $s1,$s1,1  #increment $s1 by 1 so we can add the next byte to the next memory address
     sb $t1,0($s1)   #save second byte
     
     #new line
     addi $s0,$s0,1
     lb $t1,0($s0)   #load 2nd byte from $s0
     
     addi $s1,$s1,1  #increment $s1 by 1 so we can add the next byte to the next memory address
     sb $t1,0($s1)
     #******************
     
     
     #save second line
     addi $s0,$s0,1
     lb $t1,0($s0)  #load the '#"
     sb $t1,0($s1)  #save '#'
     
     
     # ' ' (empty space)
     addi $s0,$s0,1  #increment address by 1, move up by 1
     lb $t1,0($s0)   # load the ' ' (empty space)
     
     addi $s1,$s1,1  #increment $s1 by 1
     sb $t1,0($s1)   #save ' ' (empty space)
     
     # 'Hse' --- saving the letters indepedently
     #first letter 
     addi $s0,$s0,1
     lb $t1,0($s0)  #load first letter
     
       addi $s1,$s1,1  #increment $s1 by 1
     sb $t1,0($s1)   #save 1st letter
     
     #second letter
     addi $s0,$s0,1
     lb $t1,0($s0)  #load 2nd letter
     
     addi $s1,$s1,1  #increment $s1 by 1
     sb $t1,0($s1)   #save 2nd letter
     
     #3rd letter
     addi $s0,$s0,1
     lb $t1,0($s0)  #load 3rd letter
     
     addi $s1,$s1,1  #increment $s1 by 1
     sb $t1,0($s1)   #save 3rd letter
     
     
     #new line
     addi $s0,$s0,1
     lb $t1,0($s0)   
     
     addi $s1,$s1,1 
     sb $t1,0($s1)
     #******************
     
     
     #64 by 64
     #To do 
     
     addi $s0,$s0,5
     
     #new line
     addi $s0,$s0,1 #skipped new line now
     
     #max value ( i.e 255)
     addi $s0,$s0,4 # skipped the entirety of 255
     
     #skip the new line
     addi $s0,$s0,1
     
     
     # for subset 3
     addi $s0,$s0,4
     
     # WE ARE NOW AT LINE 5
     #print the current progress
     
    #li $v0, 4 
    #move $a0,$s0
    #syscall
    
    #print new line
    li $v0, 11           # Syscall 11 (print character)
    li $a0, '\n'
    syscall
     
     #pasted the new conversion module here
    # Initialize registers
    li $t2, 0            #($t0) Initialize a counter for the position in the buffer
    li $t3, 0            #($t1) Initialize an accumulator for the integer value
    li $t4, 10           #($t2) Constant 10 for decimal multiplication

parse_loop:

    #li $v0, 4           # Syscall 11 (print character)
    #la $a0, prompt2
    #syscall
    # Load the current character from the buffer into $t3
    lb $t5, ($s0)

    # Check for the null terminator (end of string)
    beqz $t5, done
    
    # Check for the newline character
    li $t6,10
    #beq $t5, $t6, process_integer
    beq $t5,'\n', process_integer   
    
     
   #whitespace handling***************************************
    
    li $t6, ' '   # ASCII code for space
    li $t7, '\t'  # ASCII code for tab
    li $t8, '\n'  # ASCII code for newline
    
    beq $t5, $t6, skip_whitespace
    beq $t5, $t7, skip_whitespace
    beq $t5, $t8, skip_whitespace
    
    #********************White space Handling done***********# 
    
    
    #print character prompt
    li $v0, 4           # Syscall 11 (print character)
    la $a0,prompt
    syscall
    
    #print character
    li $v0, 11           # Syscall 11 (print character)
    move $a0,$t5
    syscall
    
    # Print a newline character
    li $v0, 11           # Syscall 11 (print character)
    li $a0, '\n'
    syscall
    
   


    # Convert ASCII character to integer (assuming ASCII '0' to '9')
    subi $t5, $t5, '0'

    # Multiply the current result by 10 and add the new digit
    mul $t3, $t3, $t4
    add $t3, $t3, $t5
    
    #print the current progress of integer
    li $v0, 1            # Syscall 1 (print integer)
    move $a0, $t3        # Integer value to print
    syscall

    # Move to the next character in the string
    addi $s0, $s0, 1   # Increment $s0 instead of $t0 for the buffer address

    # Repeat the loop
    j parse_loop

process_integer:
    # $t1 now contains the parsed integer
    # You can use $t1 for further processing or printing
    
    #Print  before calculation
    li $v0, 4           # Syscall 11 (print character)
    la $a0, prompt3
    syscall
    
    
    #
    li $v0, 1            # Syscall 1 (print integer)
    move $a0, $t3        # Integer value to print
    syscall
    
    # fix the -35 problem*********
    
    addi $t3,$t3,35
    
    #fixed************************
    
    addi $t3,$t3,10
    
     # Print a newline character
    #li $v0, 4           # Syscall 11 (print character)
    #la $a0, prompt1
    #syscall
    
    # Print a newline character
    li $v0, 11           # Syscall 11 (print character)
    li $a0, '\n'
    syscall
    
    # Print the integer value aftercalculatio
    li $v0, 4           # Syscall 11 (print character)
    la $a0, prompt4
    syscall
    
    # Print the integer value aftercalculation (for testing)
    li $v0, 1            # Syscall 1 (print integer)
    move $a0, $t3        # Integer value to print
    syscall

    # Print a newline character
    li $v0, 11           # Syscall 11 (print character)
    li $a0, '\n'
    syscall
    
    # Print a newline character
    li $v0, 11           # Syscall 11 (print character)
    li $a0, '\n'
    syscall

    # Reset the accumulator $t1 for the next integer
    li $t3, 0

    # Move to the next character after the newline
    addi $s0, $s0, 1   # Increment $s0 instead of $t0 for the buffer address

    # Repeat the loop
    j parse_loop
    
    
skip_whitespace:
    # Move to the next character in the buffer
    addi $s0, $s0, 1
    
    
    #**************************************
    #Whats the character 
    #print whiteSpace Handling prompt
    li $v0, 4           # Syscall 11 (print character)
    la $a0,prompt5
    syscall
    
     # Print a newline character
    li $v0, 11           # Syscall 11 (print character)
    li $a0, '\n'
    syscall
    
    #*******************************************

    # Check for the end of the line
    li $t9, '\n'  # ASCII code for newline
    beq $t5, $t9, process_integer

    # Repeat the loop
    j parse_loop

done:
    j Finish
     
Finish:	
       # Close the file
       li $v0, 16                   # Load the system call code for close (16) into $v0
       move $a0, $v0                # Move the file descriptor to $a0
       syscall
       
       # Exit the program
        li $v0, 10                  
        syscall 