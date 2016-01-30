#include <iostream>

std::string decToBinary(unsigned int number);
unsigned int mantissaInStandard(unsigned int float_int);
bool isNeg(unsigned int float_int);

int main()
{
	float f;
	std::cout << "Please enter a float: ";
	std::cin >> f;
	unsigned int float_int = *((unsigned int*)&f);
	//std::cout << decToBinary(float_int) << std::endl;
	int exp = ((unsigned int)(float_int<<1>>24)) - 127;
	std::string mantissa = decToBinary(mantissaInStandard(float_int));
	if(isNeg(float_int)) std::cout << "-";
	std::cout << "1." << mantissa << "E" << exp << std::endl;
}

unsigned int mantissaInStandard(unsigned int float_int)
{
	unsigned int mantissa = float_int << 9;
	while(!(mantissa%2))
	{
		mantissa = mantissa/2;
	}
	return mantissa;
}

bool isNeg(unsigned int float_int)
{
	return float_int >> 31;
}

std::string decToBinary(unsigned int number)
{
	std::string newNumber = "";
	bool first = true;
	while(number != 0)
	{
		if(!first) {
		char ascii = '0' + (number%2);
		newNumber = ascii + newNumber;
		}else 
		{
			first = false;
		}
		number = number/2;
	}	
	return newNumber;
}


