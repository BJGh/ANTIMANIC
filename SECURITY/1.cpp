// Labsmtuci.cpp : Этот файл содержит функцию "main". Здесь начинается и заканчивается выполнение программы.
//

#include <iostream>
#include <math.h>


int main()
{
    setlocale(LC_ALL,"RUS");
    double x1, x2, y1, y2;
    std::cout << "Введите координаты X1,X2,Y1,Y2 через пробел\n";
    std::cin >> x1 >> x2 >> y1 >> y2;
    std::cout << "Расстояние между двумя точками\n";
    std::cout << sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2) * 1.0);
    return 0;
}
