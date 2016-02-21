/*
Kendall Lui 999232413
*/

.global matMult
.equ wordsize, 4

.text

matMult:
	#prologue
	pushl %ebp
	movl %esp, %ebp

	subl $5*wordsize,%esp #allocate stack for locals see Below

	# Argument Indexing Variables in relation to %ebp
	# use var(%ebp)
	.equ a, 2*wordsize # int **a 
	.equ num_rows_a, 3*wordsize  #int num_rows_a
	.equ num_cols_a, 4*wordsize # int num_cols_a
	.equ b, 5*wordsize #int **b
	.equ num_rows_b, 6*wordsize # int num_rows_b
	.equ num_cols_b, 7*wordsize # int num_cols_b

	# local Variables
	.equ result, -1*wordsize #int **result
	.equ rowA, -2*wordsize # int rowA
	.equ colB, -3*wordsize #int colB
	.equ colA, -4*wordsize #int colA
	.equ dotSum, -5*wordsize # int dotSum

	push %ebx 
	push %esi

	# int** result = (int**) malloc(num_rows_a * sizeof(int*));
	movl num_rows_a(%ebp), %ebx
	shll $2, %ebx # num_rows_a *sizeof(int) clever shift is same as multiple *4
	push %ebx # malloc arguments
	call malloc
	addl $1*wordsize, %esp # remove malloc's arguments
	movl %eax, result(%ebp) # save pointer from malloc to result

	# for(rowA = 0; rowA < num_rows_a; rowA++) 
	movl $0, %esi #rowA

	for_rowA:
		cmpl num_rows_a(%ebp), %esi #esi - num_row_A
		jge end_for_rowA

		movl %esi, rowA(%ebp) #store rowA (Using ESI unecessary)

		#result[rowA] = (int*) malloc(num_cols_b*sizeof(int*)); 
		movl num_cols_b(%ebp), %eax
		shll $2, %eax #num_cols*sizeof(int)
		push %eax
		call malloc
		addl $1*wordsize, %esp

		movl result(%ebp), %edx #**result is now edx
		movl rowA(%ebp), %esi # restore rowA unecessary

		movl %eax, (%edx, %esi, wordsize) # save pointer from malloc into result

		movl %edx, %eax #eax has result

		#for(colB = 0; colB < num_cols_b; colB++) 
		movl $0, %ebx # colB = %ebx
		for_colB:
			cmpl num_cols_b(%ebp),%ebx # %ebx - num_cols_b
			jge end_for_colB

			movl $0, %edx #int dotSum = 0;
			movl %ebx, colB(%ebp) #store index colB
			
			#for(colA = 0; colA < num_cols_a; colA++)
			movl $0, %ecx #colA
			for_colA:
				cmpl num_cols_a(%ebp),%ecx
				jge end_for_colA
					push %ebx
					push %eax

					#int valA = a[rowA][colA];
					movl a(%ebp), %eax
					movl (%eax, %esi, wordsize), %eax
					movl (%eax, %ecx, wordsize), %eax

					push %edx
					movl colB(%ebp), %edx
					#int valB = b[colA][colB];
					movl b(%ebp), %ebx
					movl (%ebx, %ecx, wordsize), %ebx
					movl (%ebx, %edx, wordsize), %ebx

					#int multiply = valA * valB;
					mull %ebx # ebx * eax
					pop %edx
					addl %eax, %edx #dotSum += multiply;  

					pop %eax # Has Result
					pop %ebx
				incl %ecx
				jmp for_colA
			end_for_colA:
					push %eax
					# result[rowA][colB]= dotSum
					movl (%eax, %esi, wordsize), %eax
					movl %edx, (%eax, %ebx, wordsize)
					pop %eax

			incl %ebx
			jmp for_colB
		end_for_colB:
		
		incl %ecx #rowA++
		jmp for_rowA #loop
	end_for_rowA:
		movl result(%ebp), %eax


	#epilogue
	pop %esi
	pop %ebx
	movl %ebp, %esp
	pop %ebp

	ret


/*
int** matMult(int **a, int num_rows_a, int num_cols_a, int** b, int num_rows_b, int num_cols_b)
{
	int** result = (int**) malloc(num_rows_a * sizeof(int*)); //Allocate an Array of Integer pointers
	int rowA; 
	for(rowA = 0; rowA < num_rows_a; rowA++) // For loop iterates through all rows in A
	{
		result[rowA] = (int*) malloc(num_cols_b*sizeof(int*)); // We create a new row of integers in result
		int colB; 
		for(colB = 0; colB < num_cols_b; colB++) { // We iterate through all columns in B
			int colA;
			int dotSum = 0;
			for(colA = 0; colA < num_cols_a; colA++) // Each Column in row will recieve a DotProduct 
			{
				int valA = a[rowA][colA];
				int valB = b[colA][colB];
				int multiply = valA * valB;
				dotSum += multiply;  // colA is the same as rowB due to matrix multiplication rules
			}
			result[rowA][colB] = dotSum; // RowA, ColB is set to dotSum
		}
	}
	return result;

}
*/
