/*
unsigned int divide(unsigned int a, unsigned int b);
unsigned int remainder(unsigned int a, unsigned int quotient);

int main(int argc, char *argv[])
{
	char *temp;
	unsigned int dividend,divisor, dividend_cpy, divisor_cpy;
	dividend = strtoul(argv[1], &temp, 10);
	divisor = strtoul(argv[2], &temp, 10);

	unsigned int quotient = 0;
	unsigned int current = 0;

	for(int i = 0; i < 32; i++)
	{
		quotient = quotient << 1;
		current = current << 1;

		if (dividend & 0x80000000) current++;
		if (current >= divisor)
		{
			current = current - divisor;
			quotient++;
		}
		dividend = dividend << 1;
	}

	printf("%s / %s = %u R %u", argv[1], argv[2], quotient , current);
	return 0;
} //end main
*/

.global _start

.data
#unsigned int dividend,divisor
dividend:
	.long 500

divisor:
	.long 10


.text
_start:
	#unsigned int quotient = 0;
	movl $0, %eax
	#unsigned int current = 0;
	movl $0, %edx
	
	movl dividend, %ebx # %ebx = dividend
	movl divisor, %ecx # %ebx = divisor

	movl $0, %esi # i = 0
	# for(int i = 0; i < 32; i++)
	for_start:
		cmpl $32 ,%esi
		jge end_for # break 32 - i <= 0
			#quotient = quotient << 1;
			shl $1, %eax
			#current = current << 1;
			shl $1, %edx
			
			#if (dividend & 0x80000000) current++;
			#if (((dividend - (0x80000000)) >= 0) {
			if_start:
				movl %ebx, %edi
				and $0x80000000, %edi
				cmpl $0, %edi
				jz end_if
					incl %edx
			end_if:
			#if (current >= divisor)
			if_start1:
				cmpl %ecx, %edx
				jl end_if1
					subl %ecx, %edx  # current = current - divisor;
					incl %eax # quotient++;
			end_if1:
			shl $1, %ebx #dividend = dividend << 1;

		incl %esi # i++
		jmp for_start
	end_for:

done:
	movl %eax, %eax
