using System;
using System.Collections.Generic;

namespace vcademy
{//create ummutable type
    class ImmutableTypeTriangle
    {
        private readonly int a;
        private readonly int b;
        private readonly int c;

        public int A => a;
        public int B => b;
        public int C => c;

        public ImmutableTypeTriangle(int a_, int b_, int c_)
        {
            a = a_;
            b = b_;
            c = c_;
        }
        public double Square()
        {
            double val = 0;
            if ((a!=0)&& (b != 0) && (c != 0))
            {
                int p =  (a + b + c) / 2;
                val = Math.Sqrt(p * (p - a) * (p - b) * (p - c));
            }
            return val;
        }

    }
}
