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
    movl (4)+num1(,%ecx,wordsize), %eax
    movl num1, %edx
    addl (4)+num2(,%ecx,wordsize), %eax
    addl num2, %edx
	# if %eax < num1[1] || %eax < num2[1]
	cmp 4+num1(,%ecx,wordsize), %eax # if %eax < num1[1]
	jl if_statement_true
	cmp 4+num2(,%ecx,wordsize), %eax # if %eax < num2[1]
	jl if_statement_true
	jmp else #else
	if_statement_true:
		addl $1, %edx
	else:

done:
	movl %eax, %eax

