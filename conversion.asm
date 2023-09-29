.data
    filename: .asciiz "C:/Users/27677/OneDrive - University of Cape Town/Documents/CSC2002S/2023/Arch_assignment/subset.ppm"     # Replace with your file name
    buffer: .space 256                # Buffer to store a line from the file
    intValue: .word 0                # Store the integer value
    
    prompt1:   .asciiz "current number"
newLine: .asciiz "\n"

.text
    # Open the file for reading
    li $v0, 13          # Syscall 13 (open file)
    la $a0, filename    # Load the filename
    li $a1, 0           # Read-only mode
    li $a2, 0           # Default permission
    syscall

    # File descriptor is now in $v0, save it
    move $s0, $v0

read_loop:
    # Read a line from the file into the buffer
    li $v0, 14          # Syscall 14 (read file)
    move $a0, $s0       # File descriptor
    la $a1, buffer      # Buffer to store the line
    li $a2, 256         # Maximum number of characters to read
    syscall

    # Check if the read operation reached the end of the file
    beq $v0, $zero, done_reading

    # Null-terminate the string in the buffer
    add $a1, $a1, $v0  # Set the buffer length
    sb $zero, 0($a1)    # Null-terminate the string

    # Convert the string to an integer
    li $v0, 4           # Syscall 4 (print string)
    la $a0, buffer      # Load the address of the string to print
    syscall
    
    #print new line
     li $v0, 4 
     la $a0,newLine
     syscall
    
    #li $v0,4          
    #la $a0,prompt1
    #syscall

    li $v0, 5           # Syscall 5 (read integer)
    syscall

    # The integer value is now in $v0
    # You can store it in memory (intValue) or use it as needed
    move $t0,$v0
    sw $t0,intValue
    
    li $v0,1         
    la $a0,intValue
    syscall
    
    
    

    # Continue reading the next line
    j read_loop

done_reading:
    # Close the file
    li $v0, 16          # Syscall 16 (close file)
    move $a0, $s0       # File descriptor
    syscall

    # Exit the program (optional)
    li $v0, 10          # Syscall 10 (exit)
    syscall
