
.global _start
.equ wordsize, 4

.data


oldDist_ptr:
	.long 0
currDist_ptr:
	.long 0
#global_vars
/*
string1:
	.rept 100
		.byte 0
	.endr
string2: 
	.rept 100
		.byte 0
	.endr
*/
string1:
	.string "hello"

string2:
	.string "boo!"

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

	#movl $1, %edx
	#movl (ptr_b), %ecx
	#movl (%ecx,%edx,4), %ebx

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

  	#for(i = 1; i < word1_len + 1; i++)

	movl $1, %ecx #int i = 1
	for_start_alg_i:
		cmpl %ecx, str1_len # word1_len - i
		jb end_for_alg_i # i <= word2_len
			movl (currDist_ptr),%esi
    		movl %ecx, (%esi) #curDist[0] = i;

    		#for(j = 1; j <= word2_len; j++){
			movl $1, %ebx # j = 1
			for_start_alg_j:
				cmpl %ebx, str2_len # word2_len - j (%ebx) COMPARING INT
				jb end_for_alg_j # i <= word2_len
					movb (string1-1)(,%ecx), %dl # edx = word[i-1]
					cmpb (string2-1)(,%ebx), %dl  # if(word1[i-1] == word2[j-1]): COMPARING BYTE
						jnz else_word1_word2
							movl (oldDist_ptr), %esi
							movl %ebx, %edi # j
							decl %edi #j-1

							movl (%esi,%ebx,wordsize), %edx
							movl (currDist_ptr), %esi
							movl %edx, (%esi,%ebx,wordsize) #curDist[j] = oldDist[j - 1];
							incl %ebx #i++
							jmp for_start_alg_j
						else_word1_word2:
							# curDist[j] = min(min(oldDist[j], curDist[j-1]), oldDist[j-1]) + 1;
							movl (oldDist_ptr), %esi
							push (%esi,%ebx,wordsize)
							movl (currDist_ptr), %edi
							movl %ebx, %esi # j
							decl %esi #j-1
							movl (%edi,%esi,wordsize), %edx
							push %edx
	
							call min #min oldDist[j],currDist[j-1]
							push %eax
							movl (oldDist_ptr), %edi
							push (%edi,%esi,wordsize)
							call min #min result oldDist[j-1]
							incl %eax #min +1
							movl %eax,(%edi,%ebx,wordsize)
				incl %ebx #i++
				jmp for_start_alg_j
			end_for_alg_j:
				#swap
				push currDist_ptr
				push oldDist_ptr
				pop currDist_ptr
				pop oldDist_ptr
			incl %ecx #i++
			jmp for_start_alg_i
	end_for_alg_i:
		movl str2_len, %esi 
		movl (oldDist_ptr),%edi
		movl (%edi,%esi,4),%eax
	/*	
    }//for each character in the second word
    swap(&oldDist, &curDist);
  }//for each character in the first word
*/
done:
	movl %eax, %eax
