
.global _start

.data
# variables for min
a_min:
	.long 0

b_min:
	.long 0

return_min:
	.long 0

a_swap:
	.rept 5
		.long 1
	.endr

b_swap:
	.rept 5
		.long 1
	.endr
# variables for swap

.text
min:
	movl b_min,%edx
	cmpl a_min, %edx # b - a
	jl return_b_min # if b - a < 0 (b is smallest)  
		movl a_min, %edx #else
		jmp return
	return_b_min: # if
		movl b_min, %edx
	return:
		movl %edx, return_min # move from edx to return_min
		ret

swap:

_start:

# finds the min of b_min and a_min and puts it into return_min
# uses %edx for temp storage and calculations

done:
	movl %eax, %eax




/*
void swap(int** a, int** b){
  int* temp = *a;
  *a = *b;
  *b = temp;
}
*/
# swap swaps pointer of a and b
# uses %edx as a temp


/*
int editDist(char* word1, char* word2){

  int word1_len = strlen(word1);
  int word2_len = strlen(word2);
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
