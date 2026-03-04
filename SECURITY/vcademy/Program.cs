using System;
using vcademy;

namespace vcademy
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
            ImmutableTypeTriangle it_triangle = new ImmutableTypeTriangle(2, 8, 4);
            Console.WriteLine(it_triangle.Square());
        }
    }
}
