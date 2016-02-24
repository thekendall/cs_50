/*
 int** get_combs(int* items, int k, int len)
 {
 	int combs = num_combs(len, k);
 	int** result = (int**)malloc(combs*sizeof(int));
	int index = 0;
	while(len > k)
	{
		if(k == 1){
			int i;
			for(i = 0; i < len; i++)
			{
				result[i] = (int*)malloc(k*sizeof(int));
				result[i][0] = items[i];
			}
			return result;
		}
		int first = items[0];
		items = items + 1;
		len--;
		int** last = get_combs(items, k-1,len);
		int num_last = num_combs(len,k-1);
		int y;
		for(y = 0; y < num_last; y++)
		{
			result[index] = (int*)malloc(k*sizeof(int));
			result[index][0] = first;
			int x;
			for(x = 0; x < k-1; x++)
			{
				result[index][x+1] = last[y][x];
			}
			index++;
		} 
	}
	result[index] = (int*)malloc(k*sizeof(int));
	int i;
	for(i = 0; i < k; i++)
	{
		result[index][i] = items[i];
	}	
	return result;
 }
 */

.global get_combs
.equ wordsize, 4

.text

get_combs:
	#prologue
	push %ebp
	movl %esp, %ebp

	.equ items, (2*wordsize) #(%ebp) int* items
	.equ k, (3*wordsize) #(%ebp) int k
	.equ len, (4*wordsize) #(%ebp) int len

	#locals
	subl $6*wordsize, %esp
	.equ index,(-1*wordsize) #%ebp int index
	.equ combs,(-2*wordsize) # %ebp int combs
	.equ result,(-3*wordsize) # %ebp int combs
	.equ last,(-4*wordsize) # %ebp int combs
	.equ num_last,(-5*wordsize) # %ebp int combs
	.equ first,(-6*wordsize) # %ebp int combs

	push %ebx
	push %ecx
 	
	//int combs = num_combs(len, k);
	movl k(%ebp), %edx
	push %edx
	movl len(%ebp), %edx
	push %edx
	call num_combs
	addl $2*wordsize, %esp
	movl %eax, combs(%ebp)

 	//int** result = (int**)malloc(combs*sizeof(int))
	shll $2, %eax
	push %eax
	call malloc
	addl $1*wordsize, %esp
	
	movl %eax, result(%ebp)
	movl result(%ebp), %eax

	//int index = 0;
	movl $0, %eax
	movl %eax, index(%ebp)

	
	debug2:
	movl len(%ebp), %eax
	
	
	#while(len > k)
	while_loop:
	movl k(%ebp), %edx
	cmpl %edx, len(%ebp) # len - k
	jle end_while
		#if(k == 1){
		if_k_1:
		cmpl $1, %edx
		jnz end_if_1	
			movl $0, %esi
			# for(i = 0; i < len; i++)
			for_i:
			cmpl len(%ebp), %esi
			jge end_for_i
				# result[i] = (int*)malloc(k*sizeof(int));
				movl k(%ebp), %edx
				shll $2, %edx
				push %edx
				call malloc
				addl $1*wordsize, %esp
				movl result(%ebp), %edx
				movl %eax, (%edx, %esi, wordsize) #result[i] = malloc pointer
				
				#result[i][0] = items[i];
				movl result(%ebp), %edx
				movl (%edx,%esi,wordsize), %edx
				movl items(%ebp), %ecx
				movl (%ecx,%esi,wordsize), %ecx
				movl $0, %ebx
				movl %ecx, (%edx, %ebx, wordsize)
			
			incl %esi
			jmp for_i
			end_for_i:
				jmp return_ep
	
		end_if_1:
		#int first = items[0];
		movl $0, %ebx
		movl items(%ebp), %edx #items is %edx
		movl (%edx), %edx
		movl %edx, first(%ebp)
 
		#items = items + 1;
		movl items(%ebp), %edx
		addl $1*wordsize, %edx
		movl %edx, items(%ebp)


		#len--;
		movl len(%ebp), %ebx
		decl %ebx
		movl %ebx, len(%ebp)
		

		#int** last = get_combs(items, k-1,len);
		push len(%ebp)
		#k-1
		movl k(%ebp), %ebx # k is now %ebx
		decl %ebx
		push %ebx
		
		#items
		push %edx #push items
		call get_combs 
		addl $3*wordsize, %esp
		movl %eax, last(%ebp)

		#int num_last = num_combs(len,k-1);
		#k-1
		movl k(%ebp), %ebx # k is now %ebx
		decl %ebx
		push %ebx
		push len(%ebp)
		call num_combs
		addl $2*wordsize, %esp
		movl %eax, num_last(%ebp)

		movl $0, %esi #y = 0
		#for(y = 0; y < num_last; y++)
		for_y:
			cmpl num_last(%ebp), %esi
			jge end_for_y
			#result[index] = (int*)malloc(k*sizeof(int));
			movl k(%ebp), %edx
			shll $2, %edx
			push %edx
			call malloc
			addl $1*wordsize, %esp

			movl result(%ebp), %edx
			movl index(%ebp), %ecx #index = %ecx
			movl %eax, (%edx,%ecx,wordsize) #result[i] = malloc pointer

			movl (%edx,%ecx,wordsize), %eax #result[index]
				
		#	result[index][0] = first;
			push %edx
			movl first(%ebp), %edx
			push %ebx
			movl $0, %ebx
			movl %edx, (%eax,%ebx,wordsize)
			pop %ebx
			pop %edx


		#	int x;
			movl $0, %ecx
		
		#	for(x = 0; x < k-1; x++)
			for_x:
			movl k(%ebp), %edx
			subl $1, %edx # k-1
			cmpl %edx, %ecx # (x -(k-1))
			jge end_for_x
		#		result[index][x+1] = last[y][x];
				movl last(%ebp), %edx
				movl (%edx,%esi,wordsize), %edx

				movl (%edx,%ecx,wordsize), %edx
				movl %edx, wordsize(%eax,%ecx,wordsize) # 1*4 + x 
			incl %ecx
			jmp for_x
			end_for_x:

			#index++
			movl index(%ebp) ,%ecx
			incl %ecx
			movl %ecx, index(%ebp)
		incl %esi
		jmp for_y
		end_for_y:


 	jmp while_loop
	end_while:
	#result[index] = (int*)malloc(k*sizeof(int));
	movl k(%ebp), %ebx
	shll $2, %ebx
	push %ebx #k *size of
	call malloc
	addl $1*wordsize, %esp

	movl index(%ebp) ,%ecx #index
	movl result(%ebp),%ebx #result[]
	movl %eax, (%ebx, %ecx, wordsize) #result[index] = %eax
	movl (%ebx,%ecx,wordsize), %ebx #result[index]

	#esi
	movl $0, %esi
	#for(i = 0; i < k; i++)
	for_:
	##################
		movl k(%ebp),%edx
		#decl %edx
	##################
		cmpl %edx, %esi # (x -(k-1))
		jge end_for_

		#result[index][i] = items[i];
		movl items(%ebp), %edx
		movl (%edx, %esi,wordsize), %edx
		movl %edx, (%ebx,%esi, wordsize)

		incl %esi
		jmp for_
	end_for_:


	return_ep:
	movl result(%ebp), %eax

	#epilogue
	pop %esi
	pop %ebx

	movl %ebp, %esp
	pop %ebp

	ret


	
