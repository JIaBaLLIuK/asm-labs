#include <iostream>

using namespace std;

extern "C" float FindSin(float);

int main()
{
	float* array;
	int arraySize;
	cout << "Enter size of the array:" << endl;
	cin >> arraySize;
	array = new float[arraySize];
	for (int i = 0; i < arraySize; i++)
	{
		cout << "Array [" << i << "]:" << endl;
		cin >> array[i];
	}
	
	for (int i = 0; i < arraySize; i++)
	{
		cout << "Sin(Array[" << i << "]) = " << FindSin(array[i]) << endl;
	}

	return 0;
}
