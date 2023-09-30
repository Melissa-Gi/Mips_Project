#Assignemnt Question 1
#Melissa Githinji 09/2023

.data
    # filename for reading (created outside the program)
    fin:   .asciiz "Users//melissagithinji//Desktop//UCT//CompSci 2002S//Architecture//myrepo//Mips_imageProcessing//sample_images//tree_64_in_ascii_lf.ppm"
    fout:   .asciiz "Users//melissagithinji//Desktop//UCT//CompSci 2002S//Architecture//myrepo//Mips_imageProcessing//output_image.ppm"
    buffer: .space 3  
    header: .asciiz "P3\n# Hse\n64 64\n255\n"
    originalAvg: .asciiz "Average pixel value of the original image:\n"
    brightAvg: .asciiz "\nAverage pixel value of new image:\n"
    oAvg: .float 0.0
    bAvg: .float 0.0

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
    li   $a2, 19       # hardcoded buffer length
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
    li   $a2, 19       # hardcoded buffer length
    syscall            # read file

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

    add $s0,$s0,$s4 #Add to original total
    #plus 10
    addi $s4,$s4,10
    add $s5,$s5,$s4 #Add to new total

    #branch to change number to 255 in larger
    li $t3,255
    bge, $s4, $t3, tooBig

    #Convert from decimal to ASCII
    div $s4,$t2
    mfhi $t4 #Remainder to t4
    mflo $s4 #quotient to s4

    move $s3,$t4

    div $s4,$t2
    mfhi $t4 #Remainder to t4
    mflo $s4 #quotient to s4

    move $s2,$t4
    move $s1,$s4

    addi $s1,$s1,48
    addi $s2,$s2,48
    addi $s3,$s3,48

    j output

output:

    #Write non-padded pixel outputs
    li $t3,48
    bne,$t3,$s1,writeFirst
    bne,$t3,$s2,writeSecond

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

tooBig:
    li $s1,50
    li $s2,53
    li $s3,53

    j output

finishedReading:
    li $t5,3133440
    #Average of original image
    li $v0,4
    la $a0, originalAvg
    syscall
    #Floating point division
    li $v0, 2
    mtc1 $s0, $f1
    mtc1 $t5, $f2
    div.s $f12,$f1,$f2
    syscall
    #Average of brightened image
    li $v0,4
    la $a0, brightAvg
    syscall
    #Floating point division
    li $v0,2
    mtc1 $s5, $f1
    div.s $f12,$f1,$f2
    syscall

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