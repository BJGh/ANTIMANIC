#include <iostream>

int main() 
{
	setlocale(LC_ALL, "RUS");
	std::cout << "��������������� ������ X[75]\n";
	int x[75],i,sum=0;
	
	srand(time(0));
	for (i = 0; i < 75; i++) 
	{
		x[i] = 1 + rand() % 5;
		std::cout << x[i] << ' ';

	}
	for (i = 0; i < 75; i++)
	{
		sum += x[i];
	}
	
	std::cout << "����� ������� X[75]" << std::endl;
	std::cout << sum<<std::endl;
	if (sum % 2 == 0) {
		std::cout << "YES";
	}
	else { std::cout << "NO"; }
	return 0;


}
