using System.IO;
namespace P1
{
    class FileProcessor
    {


        StreamReader sr = new StreamReader("source.txt");
        public string readFile()
        {
            string p="";
            while(!sr.EndOfStream)
            {
                p += sr.ReadLine();
                
            }
            sr.Close();
            return p;
        }
     
        public void writeFile(string messagetype)
        {
           
            string fileName = "result.txt";
            StreamWriter sw = new StreamWriter(fileName);
            sw.WriteLine(messagetype);
            sw.Close();
        }
    
    }
}
