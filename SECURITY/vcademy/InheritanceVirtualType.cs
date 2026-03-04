using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace vcademy
{//try to imitate inheritance and reassing of virtual method using structure
    //not tested
    class InheritanceVirtualType
    {
        class Base
        {
            public virtual string GetInfo()
            {
                return "Base class";
            }
        }
        class A : Base
        {
            public override string GetInfo()
            {
                return "A Class";
            }
        }
        struct S
        {
            public string str { get; }
           public S(string s)
            {
                Base b = new A();
                s = b.GetInfo();
                str = s;
                str = "yeld";
            }
            public override string ToString()
            {
                return str;

            }
            //public string structInfo()
            //{return b.GetInfo(); }
        }
    }
}
