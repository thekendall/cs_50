/*
 * Kendall Lui
 *
 * Project: 
 * Creation Date : 06-02-2016
 * Last Modified : Sat 06 Feb 2016 05:20:52 PM PST
 * File Name : div.c
 * Description :
 * 
 */

#include <stdio.h>
#include <stdlib.h>

unsigned int divide(unsigned int a, unsigned int b);
unsigned int remainder(unsigned int a, unsigned int quotient);

int main(int argc, char *argv[])
{
	char *temp;
	unsigned int a,b;
	a = strtoul(argv[1], &temp, 10);
	b = strtoul(argv[2], &temp, 10);
	unsigned int quotient = divide(a,b);
	printf("%s / %s = %u R %u", argv[1], argv[2], quotient , remainder(a,quotient*b));
	return 0;
} //end main

unsigned int remainder(unsigned int a, unsigned int quotient){
	return a - quotient;
}

unsigned int divide(unsigned int dividend, unsigned int divisor)
{
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
	return quotient;

}
