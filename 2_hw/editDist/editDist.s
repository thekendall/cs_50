
.global _start
.equ wordsize, 4

.data


oldDist_ptr:
	.long 0
currDist_ptr:
	.long 0
#global_vars
string1:
	.rept 100
		.byte 0
	.endr
string2: 
	.rept 100
		.byte 0
	.endr
/*
string1:

	.string "hello"

string2:
	.string "boo!"
*/


str1_len:
	.long 0
str2_len:
	.long 0

oldDist:
	.rept 100
		.long 0
	.endr

currDist:
	.rept 100
		.long 0
	.endr

# variables for swap

.text

# finds the min of b_min and a_min and puts it into return_min
min:
	push %ebx
	movl 8(%esp), %ebx
	movl (12)(%esp), %eax
	cmpl %eax, %ebx # ebx - eax
	jl return_ebx # if ebx - eax > 0 (eax is smallest)
		jmp return_min # eax is already answer
	return_ebx: # else ebx is smallest
		movl %ebx, %eax # ebx is answer so move to eax
	return_min:
		pop %ebx 
		ret

#Calling strlen
#	push $string2
#	call strlen
#	addl $4, %esp
strlen:
	pushl %ecx 
	pushl %ebx 
	movl $0, %ecx # ecx: i = 0
	movl 12(%esp),%ebx #ebx = string
	start_while_strlen:
		cmpb $0 , (%ebx,%ecx) # Compare with null
		jz end_while_strlen # if null char
			incl %ecx
		jmp start_while_strlen
	end_while_strlen:
		movl %ecx, %eax
		pop %ecx
		pop %ebx
	ret
				#swap
				#push currDist_ptr
				#push oldDist_ptr
				#pop currDist_ptr
				#pop oldDist_ptr
	#movl $1, %edx
	#movl (ptr_b), %ecx
	#movl (%ecx,%edx,4), %ebx

_start:
  	# int word1_len = strlen(word1);
	push $string1
	call strlen
	movl %eax, str1_len

  	# int word2_len = strlen(word2);
	push $string2
	call strlen
	movl %eax, str2_len
	
	movl $oldDist, %eax # &oldDist
	#set pointer ptr_a = &oldDist
	movl %eax, oldDist_ptr 
	movl $currDist, %eax # &currDirs 
	movl %eax, currDist_ptr


  	//intialize distances to length of the substrings
  	#for(i = 0; i <= word2_len; i++)
	movl $0, %ecx #int i = 0
	for_start_init:
		cmpl %ecx, str2_len # word2_len - %ecx
		jb end_for_init # i <= word2_len
		movl %ecx, oldDist(,%ecx, wordsize) #oldDist[i] = i;
		movl %ecx, currDist(,%ecx, wordsize) #curDist[i] = i;
		incl %ecx # i++
		jmp for_start_init
	end_for_init:

	#for(i = 1; i <= word1_len; i++)
	movl $1, %esi #i = 1
	for_i_str1_len:
		cmpl %esi, str1_len # i <= word1_len
		jb end_for_i_str1_len
			
			movl (currDist_ptr), %edx # *currDist_ptr
			movl %esi, (%edx) # **currDist_ptr

			#for(j = 1; j <= word2_len; j++){
			movl $1, %edi # j = 1
			for_j_str2_len:
				cmpl %edi, str2_len
				jb end_for_j_str2_len # j <= word2_len

					# if word1[i-1] == word[j-1]
					if_word1_word2:
						movb (string1 - 1)(,%esi), %dl
						movb (string2 - 1)(,%edi), %al
						cmpb %al, %dl
						jnz else_word1_word2 
							# True
							movl (currDist_ptr), %edx # edx = *currDist_ptr
							movl (oldDist_ptr), %ecx # ecx = *oldDist_ptr
							movl (-4)(%ecx,%edi,4), %ebx # ebx = ecx[j-1]
							movl %ebx,(%edx,%edi,4) # edx[j] = ebx = ecx[j-1]
						jmp end_if_word1_word2

						else_word1_word2:
							# else
							movl (currDist_ptr), %edx # edx = *currDist_ptr
							pushl (-4)(%edx,%edi,4) # push edx[edi-1]
							movl (oldDist_ptr), %edx # edx = *oldDist_ptr
							pushl (%edx,%edi,4)
							call min # min (oldDist[j], currDist[j-1])

							pushl %eax #find min of previous min and oldDist - 1 
							movl (oldDist_ptr), %edx # edx = *oldDist_ptr
							pushl (-4)(%edx,%edi,4)
							call min
							incl %eax # min + 1
		
							movl (currDist_ptr), %edx # edx = *currDist_ptr
							movl %eax, (%edx,%edi,4)

						end_if_word1_word2:

				incl %edi #j++
				jmp for_j_str2_len
			end_for_j_str2_len:
				#swap
				push currDist_ptr
				push oldDist_ptr
				pop currDist_ptr
				pop oldDist_ptr

		incl %esi #i++
		jmp for_i_str1_len
	end_for_i_str1_len:
		movl str2_len ,%esi
		movl (oldDist_ptr),%edx
		movl (%edx,%esi,4), %eax


done:
	movl %eax, %eax
