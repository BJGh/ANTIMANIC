#include <iostream>

int main()
{
	setlocale(LC_ALL, "RUS");
	std::cout << "��������������� ������ X[10][20]\n";
	int x[10][20], i, j, max = 0, Y[20];
	srand(time(0));
	for (i = 0; i < 9; i++)
	{
		for (j = 0; i < 19; i++)
		{

			x[i][j] = 1 + rand() % 5;
			std::cout << x[i][j];
			printf("\n");
		}

	}
	for (i = 0; i <10; i++)
	{
		if (x[i][0] > max)
		{
			max = x[i][0];
		}
		Y[i] = max;
		std::cout << Y[i];
	}
}
