.data
inputString: .asciiz "12345"   # The ASCII string containing the number
result: .word 0                # Store the integer result
emptyLine: .asciiz "\n"

.text
.globl main
main:
    # Load the address of the input string into $a0
    la $a0, inputString
    
    # Initialize result to 0
    lw $t0, result
    li $t1, 0

parse_loop:
    # Load the current character from the string into $t2
    lb $t2, 0($a0)
    
    # Check for the null terminator (end of string)
    beqz $t2, done
    
    # Convert ASCII character to integer (assuming ASCII '0' to '9')
    subi $t2, $t2, '0'
    
    # Multiply the current result by 10 and add the new digit
    mul $t1, $t1, 10
    add $t1, $t1, $t2
    
    li $v0,1
    move $a0,$t1
    syscall
    
    # Move to the next character in the string
    addi $a0, $a0, 1
    
    # Repeat the loop
    j parse_loop

done:
    # Store the final integer result
    sw $t1, result
    
    li $v0,1
    move $a0,$t1
    syscall
    
    #print a new line
    li $v0,4
    la $a0,emptyLine
    syscall
    
    #check to see if this is an int( by adding 1 to this value)
    addi $t1,$t1,1
    
    li $v0,1
    move $a0,$t1
    syscall
    
    # Exit the program
    li $v0, 10
    syscall
