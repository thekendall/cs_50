
.global _start

.data
ptr_a:
	.long 0
ptr_b:
	.long 0
a:
	.long 1
	.long 2
	.long 3
b:
	.long -1
	.long -2
	.long -3

.text

_start:
	movl $a, %eax #&a
	#set pointer ptr_a = &a
	movl %eax, ptr_a #&b
	movl $b, %eax 
	movl %eax, ptr_b
	movl ptr_a, %edx
	movl %edx, ptr_b


	movl $1, %edx
	movl (ptr_b), %ecx
	movl (%ecx,%edx,4), %ebx

	
done:
	movl %eax, %eax
