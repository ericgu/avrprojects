using System;
using System.Collections.Generic;
using System.Text;

namespace ColorChangeDriver
{
    class Program
    {
        static void Main(string[] args)
        {
            Program program = new Program();
            program.Output();
            Console.ReadKey();
            program.Run();
        }

        readonly byte[] data = { 
                0xFF, 1, 1, 1,
                0xFF, 0xFF, 0xFF, 0xFF,
                0, 0, 0, 0};

        byte OperationCount;
        byte RedIncrement;
        byte BlueIncrement;
        byte GreenIncrement;

        byte RedBrightness = 0;
        byte BlueBrightness = 0;
        byte GreenBrightness = 0;

        int OpcodeIndex = 0;

        public void Output()
        {
            for (int i = 0; i < data.Length; i += 4)
            {
                Console.WriteLine("\t.DB    {0},\t{1},\t{2},\t{3}", data[i], data[i + 1], data[i + 2], data[i + 3]);
            }
        }

        public void Run()
        {

            RedBrightness = 0;
            GreenBrightness = 0;
            BlueBrightness = 0;

            while (true)
            {

                    // decode the current instruction
                OperationCount = data[OpcodeIndex];
                OpcodeIndex++;

                RedIncrement = data[OpcodeIndex];
                OpcodeIndex++;

                GreenIncrement = data[OpcodeIndex];
                OpcodeIndex++;

                BlueIncrement = data[OpcodeIndex];
                OpcodeIndex++;

                if (OperationCount == 0)
                {
                    OpcodeIndex = 0;
                }
                else
                {
                    for (int i = 0; i < OperationCount; i++)
                    {
                        RedBrightness += RedIncrement;
                        GreenBrightness += GreenIncrement;
                        BlueBrightness += BlueIncrement;

                        Console.WriteLine("RGB: {0} {1} {2}", RedBrightness, GreenBrightness, BlueBrightness);

                    }

                }
            }



        }






    }
}
