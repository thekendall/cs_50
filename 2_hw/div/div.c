/*
 * Kendall Lui
 *
 * Project: 
 * Creation Date : 06-02-2016
 * Last Modified : Sat 06 Feb 2016 06:09:47 PM PST
 * File Name : div.c
 * Description :
 * 
 */

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	char *temp;
	unsigned int dividend,divisor;
	dividend = strtoul(argv[1], &temp, 10);
	divisor = strtoul(argv[2], &temp, 10);

	unsigned int quotient = 0;
	unsigned int current = 0;

	for(int i = 0; i < 32; i++)
	{
		quotient = quotient << 1;
		current = current << 1;

		if ((int)(dividend - (0x80000000)) >= 0) {
			current++;
		}
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


