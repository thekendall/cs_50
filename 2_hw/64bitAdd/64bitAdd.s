# Kendall Lui 
# Computer Science 50
# this program computes the sum of two 64bit numbers
# made for a 32 bit machine which is what makes this
# a challenge.

.global _start
.equ wordsize, 4

.data
# Allocating 64 bits to num1
num1:
    .rept 2 # 2
        .long 0 # 4 bytes
    .endr

#Allocating 64 bits to num2
num2:
    .rept 2 # 2*long
        .long 0 # 4 bytes
    .endr


.text
_start:
    #initialize registers
    movl (4)+num1(,%ecx,wordsize), %eax # place num1 into eax
    movl num1, %edx # place num1 second part into edx
    addl num2, %edx # Add second part from num2 to num1 stored in edx
    addl (4)+num2(,%ecx,wordsize), %eax # Add lsbytes to eax 
	jnc done # check to see if the addition above carries
	addl $1, %edx # if it does add 1
	#else jump to done
done:
	movl %eax, %eax

