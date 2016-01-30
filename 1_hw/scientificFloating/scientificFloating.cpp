#include <iostream>
#include <bitset>

using namespace std;
std::string decToBinary(unsigned int number);
unsigned int mantissa(unsigned int num);
unsigned int exp(unsigned int num);
string printMant(unsigned int num);
bool isNeg(unsigned int float_int);

int main()
{
	float f;
	cout << "Please enter a float: ";
	cin >> f ;
	unsigned int float_int = *((unsigned int*)&f);
	if(float_int == 0) {cout << "0E0" << endl; return 0;}
	if( isNeg(float_int) ) cout << "-";
	cout << "1." << printMant(mantissa(float_int)) << "E" << exp(float_int) << endl;
} //end main

bool isNeg(unsigned int float_int)
{
	return float_int >> 31;
}

unsigned int mantissa(unsigned int num)
{
	num = num << 9;
	return num;
}

unsigned int exp(unsigned int num)
{
		return ((float)(num << 1 >> 24)) - 127;
}

string printMant(unsigned int num)
{
	string mant = "";
	bool noneSet = true;
	for(int i = 0; i < 32; i++)
	{
		if(num%2){ 
			mant = '1' + mant;
			noneSet = false;
		}
		else 
		{
			if(!noneSet) mant = '0' + mant;
		}
		num >>= 1;
	}
	return mant;
}
