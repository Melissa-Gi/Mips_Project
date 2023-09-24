#Assignemnt Question 1
#Melissa Githinji 09/2023

.data
    fin:   .asciiz "sample_images/house_64_in_ascii_cr.ppm"      # filename for reading (created outside the program)
    fout:   .asciiz "Users//melissagithinji//Desktop//UCT//CompSci 2002S//Architecture//myrepo//Mips_imageProcessing//output_image.ppm"
    buffer: .asciiz "The quick brown fox jumps over the lazy dog."
.text
.globl main
main:
    # Open input file for reading
    li   $v0, 13       # system call for open file
    la   $a0, fin     # output file name
    li   $a1, 0        # Open for writing (flags are 0: read, 1: write)
    li   $a2, 0        # mode is ignored
    syscall            # open a file (file descriptor returned in $v0)
    move $s6, $v0      # save the file descriptor 
    
    # Write to file just opened
    li   $v0, 14       # system call for write to file
    move $a0, $s6      # file descriptor 
    la   $a1, buffer   # address of buffer from which to write
    li   $a2, 5000       # hardcoded buffer length
    syscall            # read file
    
    #read loop

    # Close input file 
    li   $v0, 16       # system call for close file
    move $a0, $s6      # file descriptor to close
    syscall            # close file

################################################
#Do calculations
################################################

    # Open output file to write the changes
    li   $v0, 13       # system call for open file
    la   $a0, fout     # output file name
    li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
    li   $a2, 0        # mode is ignored
    syscall            # open a file (file descriptor returned in $v0)
    move $s6, $v0      # save the file descriptor 
    
    # Write to file just opened
    li   $v0, 15       # system call for write to file
    move $a0, $s6      # file descriptor 
    la   $a1, buffer   # address of buffer from which to write
    li   $a2, 5000       # hardcoded buffer length
    syscall            # write to file
    
    # Close input file 
    li   $v0, 16       # system call for close file
    move $a0, $s6      # file descriptor to close
    syscall            # close file

    j exit

exit:
    li $v0, 10
    syscall