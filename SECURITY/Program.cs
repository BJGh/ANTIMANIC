using System;
using System.Collections.Generic;
using System.Linq;

namespace P1
{

    internal class Program
    {
        private static double A;
        private static double B;
        private static double C;
     
        public static void assignVar(double a,double b, double c)
        { A = a; B = b; C = c; }
        public static double CalculateS()
        {
            return (Math.Sqrt(A * B * C)) / (Math.Log2(A));
        }
        static void Main(string[] args)
        {
            Console.WriteLine("Чтение из файла значений A,B,C");
            FileProcessor fp = new FileProcessor();
            string m = fp.readFile();
            Console.WriteLine(m);
            List<double> numstr = m.Split(new char[] {' '},StringSplitOptions.RemoveEmptyEntries)
                                    .Select(double.Parse).ToList();
            assignVar(numstr[0], numstr[1], numstr[2]);

            fp.writeFile(CalculateS().ToString());
        }
    }
}
