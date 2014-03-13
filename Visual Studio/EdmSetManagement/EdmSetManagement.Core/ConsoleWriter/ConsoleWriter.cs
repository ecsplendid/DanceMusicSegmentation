using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EdmSetManagement.Core.ConsoleWriter
{
   public  static class Output
    {   
       public static void Write( string what, params object[] args )
       {
           Console.WriteLine( String.Format( what, args ) );
       }


    }
}
