#Assignemnt Question 1
#Melissa Githinji 09/2023

.data
    fin:   .asciiz "Users//melissagithinji//Desktop//UCT//CompSci 2002S//Architecture//myrepo//Mips_imageProcessing//sample_images//house_64_in_ascii_cr.ppm"     # filename for reading (created outside the program)
    fout:   .asciiz "Users//melissagithinji//Desktop//UCT//CompSci 2002S//Architecture//myrepo//Mips_imageProcessing//output_greyscale.ppm"
    buffer: .space 3  
    header: .asciiz "P2\n# Hse\n64 64\n"

.text
.globl main
main:
    # Open output file to write the changes
    li   $v0, 13       # system call for open file
    la   $a0, fout     # output file name
    li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
    li   $a2, 0        # mode is ignored
    syscall            # open a file (file descriptor returned in $v0)
    move $s6, $v0      # save the file descriptor 
    
    # Hardcode: Write header to output file
    li   $v0, 15       # system call for write to file
    move $a0, $s6      # file descriptor 
    la   $a1, header   # address of buffer from which to write
    li   $a2, 15       # hardcoded buffer length
    syscall            # write to file

    # Open input file for reading
    li   $v0, 13 
    la   $a0, fin   
    li   $a1, 0   
    li   $a2, 0  
    syscall 
    move $s7, $v0

    # read header of input file
    li   $v0, 14       # system call for write to file
    move $a0, $s7      # file descriptor 
    la $a1, buffer   # address of buffer from which to write
    li   $a2, 15       # hardcoded buffer length
    syscall            # read file

    li $t6,3    #The number of bytes to read
    j loopRead

loopRead:
    #Read 1st byte
    li   $v0, 14  
    move $a0, $s7  
    la   $a1, buffer
    li   $a2, 1        
    syscall            # read file
    lb $s1, buffer
    #base case $v0 = 0 at end of file
    beq $zero,$v0, finishedReading
    #case to ignore /n character, skip storing it, and proceed to the next line
    li $t0, 10
    beq $t0, $s1, loopRead
    
    #carry on to read the next 2 bytes if we're already on a new line
    #Read 2nd byte
    li   $v0, 14      
    move $a0, $s7 
    la   $a1, buffer
    li   $a2, 1        
    syscall            # read file
    lb $s2, buffer
    #case to ignore /n character for short numbers
    li $t0, 10
    beq $t0, $s2, pad2

    #Read 3rd byte
    li   $v0, 14      
    move $a0, $s7 
    la   $a1, buffer
    li   $a2, 1        
    syscall            # read file
    lb $s3, buffer
    #case to ignore /n character for short numbers
    li $t0, 10
    beq $t0, $s3, pad1

    #deal with some counter idk, might have to change how you do paddings
    #have some condition that makes us know that we have the 3 bytes and can go do the calculation for the average
    j doCalculation

pad1:
    move $s3 $s2
    move $s2 $s1
    li $s1,48
    j doCalculation
pad2:
    move $s3,$s1
    li $s1,48
    li $s2,48
    j doCalculation

doCalculation:
    #Convert from ASCII to decimal
    addi $s1,$s1,-48
    addi $s2,$s2,-48
    addi, $s3,$s3,-48
    li $t1,100
    li $t2,10
    mul $s1,$s1,$t1
    mul $s2,$s2,$t2
    add $s4,$s1,$s2
    add $s4,$s4,$s3

    #add this RGB to the sum of the pixel
    add $s0,$s0,$s4

    #Increase the counter
    addi $t7,$t7,1

    blt $t7,$t6, loopRead

    #get average of the 3 R
    div $s0,$t6
    mfhi $t4 #Remainder to t4
    mflo $s0 #quotient to s4
    li $t6,2
    div $s0,$t6
    mflo $t6
    slt $t5,$t4,$t6
    li $t6,0
    nor $t5,$t5,$t6
    add $s0,$s0,$t5

    #Convert from decimal to ASCII
    div $s0,$t2
    mfhi $t4 #Remainder to t4
    mflo $s0 #quotient to s0

    move $s3,$t4

    div $s0,$t2
    mfhi $t4 #Remainder to t4
    mflo $s0 #quotient to s0

    move $s2,$t4
    move $s1,$s0

    addi $s1,$s1,48
    addi $s2,$s2,48
    addi $s3,$s3,48
    j output

output:
    #zero the counter register
    li $t7,0
    li $t6,3    #The number of bytes to read

    #Write non-padded pixel outputs
    bne,$zero,$s1,writeFirst
    bne,$zero,$s2,writeSecond

    j writeThird

writeFirst:
    #1st byte
    sb $s1,buffer
    li   $v0, 15
    move $a0, $s6
    la $a1, buffer
    li   $a2, 1
    syscall            # write to file

    j writeSecond
writeSecond:     
    #2nd byte
    sb $s2,buffer
    li   $v0, 15
    move $a0, $s6
    la $a1, buffer
    li   $a2, 1
    syscall            # write to file

    j writeThird
writeThird:     #There will always be at least a 1 digit number
    #3rd byte
    sb $s3,buffer
    li   $v0, 15
    move $a0, $s6
    la $a1, buffer
    li   $a2, 1
    syscall            # write to file
    #new line
    sb $t0,buffer
    li   $v0, 15
    move $a0, $s6
    la   $a1, buffer
    li   $a2, 1
    syscall            # write to file
    j loopRead

finishedReading:
    # Close input file 
    li   $v0, 16       # system call for close file
    move $a0, $s7      # file descriptor to close
    syscall            # close file
    
    # Close output file 
    li   $v0, 16       # system call for close file
    move $a0, $s6      # file descriptor to close
    syscall            # close file    

    j exit

exit:
    li $v0, 10
    syscall