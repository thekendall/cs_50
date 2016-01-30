#include <iostream>
#include <cmath>
#include <string>
using namespace std;

string changeOfBase(int currBase, int toBase, string number);
unsigned int convertToTens(int currBase, string num);
int getValue(char digi);

const string digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

int main()
{
	int currBase, toBase;
	string number;
	cout << "Please enter the number's base: ";
	cin >> currBase;
	cout << "Please enter the number: ";
	cin >> number;
	cout << "Please enter the new base: ";
	cin >> toBase;
	cout << number << " base " << currBase << " is " << changeOfBase(currBase, toBase, number) << " base " << toBase << endl;
}

string changeOfBase(int currBase, int toBase, string number)
{
	string newNumber = "";
	unsigned int decimal = convertToTens(currBase, number);	
	while(decimal != 0)
	{
		newNumber = digits[decimal%toBase] + newNumber;
		decimal = decimal/toBase;
	}	
	return newNumber;
}

unsigned int convertToTens(int currBase, string num)
{
	unsigned int sum = 0;
	for(int i = 0; i < num.length() ; i++)
	{
		sum += getValue(num[num.length() - i - 1]) * pow(currBase, i);
	}
	return sum;		
}

int getValue(char digi)
{
	return digits.find(digi);
}
