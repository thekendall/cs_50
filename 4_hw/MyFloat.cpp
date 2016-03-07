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

	while(copy_1.exponent != copy_2.exponent) {
		if(copy_1.exponent > copy_2.exponent) {
			copy_2.exponent++;
			copy_2.mantissa = copy_2.mantissa >> 1;
		} else {
			copy_1.exponent++;
			copy_1.mantissa = copy_1.mantissa >> 1;
		}
	}
	long int mant1 = (long int)(copy_1.mantissa);
	long int mant2 = (long int)(copy_2.mantissa);
	if(copy_1.sign) mant1*=-1;
	if(copy_2.sign) mant2*=-1;
	long int mantissa = mant1 + mant2;
	if(mantissa < 0) {
		mantissa *= -1;
		copy_1.sign = 1;
	} else {
		copy_1.sign = 0;
	}
	copy_1.mantissa = (unsigned int) mantissa;

	if(copy_1.mantissa >= 0x1000000) {
		copy_1.mantissa >>= 1;
		copy_1.exponent++;
	}
	while(copy_1.mantissa < 0x800000) {
		if(copy_1.mantissa == 0) {
			copy_1.exponent = 0;
			return copy_1;
		}
		copy_1.mantissa <<=1;
		copy_1.exponent--;
	}
	copy_1.mantissa -= 0x800000;
	return copy_1;
}



void MyFloat::unpackFloat(float f) {
	unsigned int f_mod = *((unsigned int *)&f);
	sign = f_mod >> 31;//Sign
//	cout << sign << "\n";

	exponent = f_mod << 1 >> 24;//Sign
//	cout << exponent << "\n";
	
	mantissa = f_mod << 9 >> 9;//Sign
//	cout << mantissa << "\n";


}//unpackFloat

float MyFloat::packFloat() const{
  //returns the floating point number represented by this
  float f = 0;

  unsigned int f_mod = ((sign << 31) + (exponent << 23) + (mantissa));
  f = *((float *)&f_mod);
  return f;
}//packFloat
//
//


int main()
{
	float x;
	cin >> x;
	MyFloat a = MyFloat(x);
	MyFloat b = MyFloat(1.2222222222221);
	cout << (a - b) << endl;
}

