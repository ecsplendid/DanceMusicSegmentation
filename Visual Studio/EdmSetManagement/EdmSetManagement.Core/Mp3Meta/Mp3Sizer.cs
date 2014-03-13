using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Diagnostics;
using EdmSetManagement.Core.Settings;

namespace EdmSetManagement.Core.Mp3Meta
{
	public class Mp3Sizer
	{
		public TimeSpan GetSizeOfMp3File( string physicalPath ) {
		
			if(!File.Exists(physicalPath) )
				throw new InvalidOperationException("Can't find the MP3 file");

			Process proc = new Process();
			proc.StartInfo.FileName = Configuration.Default.Mp3InfoPath;
			proc.StartInfo.WorkingDirectory = new FileInfo(physicalPath).Directory.FullName;
			proc.StartInfo.Arguments =
				String.Format(@"-p ""%S"" ""{0}""", physicalPath);

			proc.StartInfo.RedirectStandardError = true;
			proc.StartInfo.RedirectStandardOutput = true;
			proc.StartInfo.UseShellExecute = false;

			proc.Start();

            /// the process prints out seconds as an int i.e. 7202 nothing else is output
			TimeSpan ts = new TimeSpan(0, 0, Convert.ToInt32(proc.StandardOutput.ReadToEnd()));

			proc.WaitForExit();

			return ts;
			
		
		}
	
	}
}
