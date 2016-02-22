/*
unsigned int knapsack(int* weights, unsigned int* values, unsigned int num_items, 
              int capacity, unsigned int cur_value){
  solves the knapsack problem
  @weights: an array containing how much each item weighs
  @values: an array containing the value of each item
  @num_items: how many items that we have
  @capacity: the maximum amount of weight that can be carried
  @cur_weight: the current weight
  @cur_value: the current value of the items in the pack
  
  unsigned int i;
  unsigned int best_value = cur_value;
  
  for(i = 0; i < num_items; i++){//for each remaining item
    if(capacity - weights[i] >= 0 ){//if we can fit this item into our pack
      //see if it will give us a better combination of items
      best_value = max(best_value, knapsack(weights + i + 1, values + i + 1, num_items - i - 1, 
                     capacity - weights[i], cur_value + values[i]));
    }//if we can fit this item into our pack   
  }//try to find the best combination of items among the remaining items
  return best_value;


}//knapsack
*/

.global knapsack
.equ wordsize, 4

.text

#max for unsigned int
max:
	#prologue
	push %ebp
	movl %esp, %ebp

	.equ b, 3*wordsize
	.equ a, 2*wordsize

	movl b(%ebp),%eax
	
	cmpl a(%ebp), %eax #(b-a)
	jae end_if_max
		movl a(%ebp), %eax
	end_if_max:

	#epilogue
	movl %ebp, %esp
	pop %ebp
	ret

knapsack:
	#prologue
	push %ebp
	movl %esp, %ebp

	.equ weights, 2*wordsize #int * weights
	.equ values,  3*wordsize #unsigned *values
	.equ num_items, 4*wordsize #unsigned num_items
	.equ capacity, 5*wordsize # capacity
	.equ cur_value, 6*wordsize # cur_value
	
	#locals
	subl $1*wordsize, %esp
	.equ best_value, -2*wordsize #int * weights

	push %ebx
	push %esi

	movl cur_value(%ebp), %ebx
	movl %ebx, best_value(%ebp)

	#START
	#for(i = 0; i < num_items; i++){//for each remaining item
	movl $0, %esi

	for_i:
	cmpl num_items(%ebp), %esi # %esi - num_items
	jae end_for_i
		#if(capacity - weights[i] >= 0 ){
		movl weights(%ebp), %edx #edx has weights
		movl capacity(%ebp), %ecx
		if_1:
		cmpl (%edx,%esi,wordsize), %ecx #capacity - weights[i]
		jl end_if_1
			#result >= 0
			# Call Knapsack
			#knapsack(weights + i + 1, values + i + 1, num_items - i - 1,capacity - weights[i], cur_value + values[i])
			movl cur_value(%ebp), %edx
			movl values(%ebp), %ecx
			addl (%ecx,%esi,wordsize), %edx # cur_value + values[i]
			push %edx # push cur_value + values[i]
			
			#push capacity - weights[i]
			movl capacity(%ebp), %edx
			movl weights(%ebp), %ecx
			subl (%ecx, %esi,wordsize), %edx
			push %edx


			#push num_items - i -1
			movl %esi, %ecx
			#shll $2, %ecx
			movl num_items(%ebp), %edx
			subl %esi, %edx
			subl $1, %edx
			push %edx

			#push values + i + 1
			movl values(%ebp), %edx
			addl %ecx, %edx
			addl $1*wordsize , %edx
			push %edx

			# push weights + i + 1
			movl weights(%ebp), %edx
			addl %ecx, %edx
			addl $1 * wordsize, %edx
			push %edx

			call knapsack 
			addl $5*wordsize, %esp #clean stack

			# call min
			push %eax
			movl best_value(%ebp), %edx
			push %edx
			call max
			addl $2*wordsize, %esp # clean stack

			movl %eax, best_value(%ebp)

		end_if_1:
	
		incl %esi
		jmp for_i
	end_for_i:
		movl best_value(%ebp), %eax

	#epilogue
	pop %esi
	pop %ebx

	movl %ebp, %esp
	pop %ebp
	
	ret

