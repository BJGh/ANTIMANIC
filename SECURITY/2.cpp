#include <iostream>
using namespace std;

int main()
{
    setlocale(LC_ALL, "RUS");
    double x, y, R;
    cout << "R=";
    cin >> R;
    cout << "Coordinates x0,y0:\n";
    cin >> x >> y;

    if (x * x + y * y <= R * R) cout << "YES\n";
    else cout << "NO\n";

    system("pause");
    return 0;
}
