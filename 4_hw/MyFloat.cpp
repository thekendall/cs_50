#include "MyFloat.h"

MyFloat::MyFloat(){
  sign = 0;
  exponent = 0;
  mantissa = 0;
}

MyFloat::MyFloat(float f){
  unpackFloat(f);
}

MyFloat::MyFloat(const MyFloat & rhs){
	sign = rhs.sign;
	exponent = rhs.exponent;
	mantissa = rhs.mantissa;
}

ostream& operator<<(std::ostream &strm, const MyFloat &f){
	strm << f.packFloat();
	return strm;
}

//comparison
bool MyFloat::operator==(const float rhs) const {
	MyFloat f_cmp = MyFloat(rhs);
	if( this->sign == f_cmp.sign && this->exponent == f_cmp.exponent && this->mantissa == f_cmp.mantissa) return true;
	return false;
}

MyFloat MyFloat::operator-(const MyFloat& rhs) const{
	MyFloat copy = MyFloat(rhs);
	copy.sign = !(bool)(copy.sign);
	return *this + copy;
}

MyFloat MyFloat::operator+(const MyFloat& rhs) const{
	MyFloat copy_1 = MyFloat(*this);
	MyFloat copy_2 = MyFloat(rhs);

	copy_1.mantissa += 0x800000;
	copy_2.mantissa += 0x800000;
	int count = 0;
	while(copy_1.mantissa < 0x1000000 && copy_2.mantissa < 0x1000000) 
	{
		count++;
		copy_1.mantissa <<= 1;
		copy_2.mantissa <<= 1;
		copy_2.exponent--;
		copy_1.exponent--;
	}

	while(copy_1.exponent != copy_2.exponent) {
		if(copy_1.exponent > copy_2.exponent) {
			copy_2.exponent++;
			copy_2.mantissa = copy_2.mantissa >> 1;
		} else {
			copy_1.exponent++;
			copy_1.mantissa = copy_1.mantissa >> 1;
		}
	}

	// Assign signs and do maths
	if(copy_1.sign == copy_2.sign) 
	{
		copy_1.mantissa += copy_2.mantissa;
		copy_1.sign = copy_1.sign;
	} else if (copy_1.sign < copy_2.sign) {
		if(copy_1.mantissa > copy_2.mantissa) {
			copy_1.mantissa -= copy_2.mantissa;
			copy_1.sign = 0;
		} else {
			copy_1.mantissa = copy_2.mantissa - copy_1.mantissa;
			copy_1.sign = 1;
		}
	} else {
		if(copy_1.mantissa > copy_2.mantissa) {
			copy_1.mantissa -= copy_2.mantissa;
			copy_1.sign = 1;
		} else {
			copy_1.mantissa = copy_2.mantissa - copy_1.mantissa;
			copy_1.sign = 0;
		}
		
	}

	while(copy_1.mantissa >= 0x1000000) {
		copy_1.mantissa >>= 1;
		copy_1.exponent++;
	}
	while(copy_1.mantissa < 0x800000) {
		if(copy_1.mantissa == 0) {
			copy_1.exponent = 0;
			copy_1.sign = 0;
			return copy_1;
		}
		copy_1.mantissa <<=1;
		copy_1.exponent--;
	}
	copy_1.mantissa -= 0x800000;
	return copy_1;
}



void MyFloat::unpackFloat(float f) {
	//unsigned int f_mod = *((unsigned int *)&f);
	__asm__(
		//sign = f_mod >> 31
		"shr $31, %%eax;" 		
		
		//exponent = f_mod << 1 >> 24;//Sign
		"shl $1, %%ebx;"
		"shr $24, %%ebx;"

		//mantissa = f_mod << 9 >> 9;//Sign
		"shl $9, %%ecx;"
		"shr $9, %%ecx":

		"=a" (sign), "=b" (exponent), "=c" (mantissa):
		"a" (f), "b" (f), "c" (f):
		"cc"
	);

	


}//unpackFloat

float MyFloat::packFloat() const{
  //returns the floating point number represented by this
  //unsigned int f_mod = ((sign << 31) + (exponent << 23) + (mantissa));
  float f = 0;
  __asm__(
  	"shl $31, %%ebx;"
	"shl $23, %%ecx;"
	"movl $0, %%eax;"
	"addl %%ecx, %%eax;"
	"addl %%ebx, %%eax;"
	"addl %%edx, %%eax":
	"=a" (f):
	"b" (sign), "c" (exponent), "d" (mantissa):
	"cc"
  );
  return f;
}//packFloat
//
//

/*
int main()
{
	float x;
	cin >> x;
	MyFloat a = MyFloat(x);
	MyFloat b = MyFloat(1.2222222222221);
	cout << (a - b) << endl;
}
*/
