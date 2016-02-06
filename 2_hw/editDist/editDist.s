
.global _start
.equ wordsize, 4

.data


oldDist_ptr:
	.long 0
newDist_ptr:
	.long 0
#global_vars
string1:
	.string "What up?"
string2: 
	.string "What was that?"

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


  	//intialize distances to length of the substrings
  	#for(i = 0; i <= word2_len; i++)
	movl $0, %ecx #int i = 0
	for_start_init:
		cmpl %ecx, str2_len # word2_len - %ecx
		jbe end_for_init # i <= word2_len
		movl %ecx, oldDist(,%ecx, wordsize) #oldDist[i] = i;
		movl %ecx, currDist(,%ecx, wordsize) #curDist[i] = i;
		incl %ecx # i++
		jmp for_start_init
	end_for_init:

  	#for(i = 1; i < word1_len + 1; i++)

	movl $1, %ecx #int i = 1
	for_start_alg_i:
		cmpl %ecx, str1_len # word1_len - i
		jbe end_for_alg_i # i <= word2_len
    		movl %ecx, currDist #curDist[0] = i;

    		#for(j = 1; j <= word2_len; j++){
			movl $1, %ebx # j = 1
			for_start_alg_j:
				cmpl %ebx, str2_len # word2_len - j (%ebx) COMPARING INT
				jbe end_for_init # i <= word2_len
					movb (string1-1)(,%ecx), %dl # edx = word[i-1]
					cmpb (string2-1)(,%ebx), %dl  # if(word1[i-1] == word2[j-1]): COMPARING BYTE
						jnz else_word1_word2
							oldDist
							movl currDist(,%ebx,wordsize) #curDist[j] = oldDist[j - 1];
						else_word1_word2:
        					#curDist[j] = min(min(oldDist[j], //deletion
        					#curDist[j-1]), //insertion
                          	#oldDist[j-1]) + 1; //subtitution
							
				incl %ebx # j++
			end_for_alg_j:
			
			incl %ecx #i++
	end_for_alg_i:
	/*	
    }//for each character in the second word
    swap(&oldDist, &curDist);
  }//for each character in the first word
*/
done:
	movl %eax, %eax


/*
int editDist(char* word1, char* word2){

  int* oldDist = (int*)malloc((word2_len + 1) * sizeof(int));
  int* curDist = (int*)malloc((word2_len + 1) * sizeof(int));

  int i,j,dist;

  //intialize distances to length of the substrings
  for(i = 0; i < word2_len + 1; i++){
    oldDist[i] = i;
    curDist[i] = i;
  }

  for(i = 1; i < word1_len + 1; i++){
    curDist[0] = i;
    for(j = 1; j < word2_len + 1; j++){
      if(word1[i-1] == word2[j-1]){
        curDist[j] = oldDist[j - 1];
      }//the characters in the words are the same
      else{
        curDist[j] = min(min(oldDist[j], //deletion
                          curDist[j-1]), //insertion
                          oldDist[j-1]) + 1; //subtitution
      }
    }//for each character in the second word
    swap(&oldDist, &curDist);
  }//for each character in the first word

  dist = oldDist[word2_len];//using oldDist instead of curDist because of the last swap
  free(oldDist);
  free(curDist);
  return dist;

}
*/
/*
void swap(int** a, int** b){
  int* temp = *a;
  *a = *b;
  *b = temp;
}
*/
# swap swaps pointer of old_ptr and new_ptr
# uses eax and edx
/*
swap:
	mov old_ptr, %edx # store the pointer stored in old_ptr in edx
	mov new_ptr, %eax # store the pointer stored in new_ptr in eax
	movl %eax, old_ptr # swap pointers
	movl %edx, new_ptr # swap pointers
	ret
*/
