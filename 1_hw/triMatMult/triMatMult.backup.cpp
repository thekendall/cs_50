#include <iostream>
#include <fstream>
#include <string>

using namespace std;
int* multiplyMatrices(int size, int* mat);


int* multiplyMatrices(int size, int* mat)
{
	int SIZE_OFFSET = 0;
	for(int i = 1; i <= size; i ++)
	{
		SIZE_OFFSET += i;
	}
	int* matrix =new int[SIZE_OFFSET]();
	
	int offset = 0;
	for(int r = 0; r < size; r++) {
		int offset2 = 0;
		for(int c = 0; c < (size-r); c++) {
			int elem1 = mat[offset + c];
			for(int s = 0; s < (size-c-r); s++)
			{
				int elem2 = mat[ SIZE_OFFSET + offset2 + s + offset];
				matrix[offset + s + c] += elem1 * elem2;
			}
			offset2 += size-c-r; 
		}
		offset += size-r;
	}
	return matrix;
}

int main(int argc, char **argv)
{
	int matrix_size;
	int array_size;
	try 
	{
		int* matrix;
		//skip first element
		for(int i = 1; i < argc; i++)
		{

			ifstream matrix_file(argv[i]);
			if (matrix_file.is_open())
			{	
				matrix_file >> matrix_size;
				if( i == 1) {	
					array_size = 0;
					for(int a = 1; a <= matrix_size; a++) {
						array_size += a;
					}
					matrix = new int[array_size*2];
				}
				int index = 0;
				int element;
				while ( !matrix_file.eof() )
				{
					matrix_file >> element;
					if(matrix_file.eof()) {break;}
					matrix[(i-1)*(array_size) + index] = element;
					index++;
				}
				matrix_file.close();
			} else { 
				cout << "Invalid File" << endl; 
			}
		}
		int* answer = multiplyMatrices(matrix_size,matrix);
		for(int i = 0; i < array_size; i++) {
			cout << answer[i] << " ";
		}
		cout<<endl;
	} catch (const invalid_argument &e) 
	{
		cout << e.what() << endl;
	}
} //end main

