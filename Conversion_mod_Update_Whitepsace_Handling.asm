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
dest: .space 128
Total: .word 0

newline: .asciiz "\n" 


filename2:  .asciiz "C:\\Users\27677\\OneDrive - University of Cape Town\\Documents\\CSC2002S\\2023\\Arch_assignment\\\house_64_in_ascii_cr.ppm"

.text
.globl main

main:
    li $v0, 13           # System call code for open file
    la $a0, filename     # Load the address of the filename
    li $a1, 0            # Open for reading
    li $a2, 0            # Mode (ignored for reading)
    syscall              # Perform the system call

    # Check for errors (file descriptor >= 0 means success)
    bgez $v0, file_opened

    li $v0, 4
    la $a0, anError2
    syscall

    li $v0, 10           # Exit program (error)
    syscall

file_opened:
    move $t0, $v0        # Store the file descriptor in $t0

    # Read data from the file (syscall 14)
    li $v0, 14           # System call code for read file
    move $a0, $t0        # File descriptor
    la $a1, buffer       # Load the address of the buffer
    li $a2, 50288        # Maximum number of bytes to read
    syscall              # Perform the system call

    # Initialize registers
    la $s0, buffer       # Load the address of the buffer into $s0
    la $s1, dest         # Load the address of the destination buffer into $s1
    li $t2, 0            # Initialize a counter for the position in the buffer
    li $t3, 0            # Initialize an accumulator for the integer value
    li $t4, 10           # Constant 10 for decimal multiplication

parse_loop:
    # Load the current character from the buffer into $t5
    lb $t5, ($s0)

    # Check for the null terminator (end of string)
    beqz $t5, done

    # Check for whitespace characters (space, tab, newline)
    li $t6, ' '   # ASCII code for space
    li $t7, '\t'  # ASCII code for tab
    li $t8, '\n'  # ASCII code for newline

    # Check if the current character is whitespace
    beq $t5, $t6, skip_whitespace
    beq $t5, $t7, skip_whitespace
    beq $t5, $t8, skip_whitespace

    # Print the non-whitespace character
    li $v0, 11           # Syscall 11 (print character)
    move $a0, $t5
    syscall

    # Convert ASCII character to integer (assuming ASCII '0' to '9')
    subi $t5, $t5, '0'

    # Multiply the current result by 10 and add the new digit
    mul $t3, $t3, $t4
    add $t3, $t3, $t5

    # Move to the next character in the buffer
    addi $s0, $s0, 1

    # Repeat the loop
    j parse_loop

skip_whitespace:
    # Move to the next character in the buffer
    addi $s0, $s0, 1

    # Check for the end of the line
    li $t9, '\n'  # ASCII code for newline
    beq $t5, $t9, end_of_line

    # Repeat the loop
    j parse_loop

end_of_line:
    # Print a newline character
    li $v0, 11
    li $a0, '\n'
    syscall

    # Store the parsed integer in the destination buffer
    sb $t3, ($s1)

    # Move to the next position in the destination buffer
    addi $s1, $s1, 1

    # Reset the accumulator for the next integer
    li $t3, 0

    # Repeat the loop
    j parse_loop

done:
    # Close the file
    li $v0, 16           # Load the system call code for close (16) into $v0
    move $a0, $t0        # Move the file descriptor to $a0
    syscall

    # Exit the program
    li $v0, 10           # Exit program
    syscall
