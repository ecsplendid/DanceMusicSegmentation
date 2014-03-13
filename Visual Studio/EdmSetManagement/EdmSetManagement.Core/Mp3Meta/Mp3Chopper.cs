using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using EdmSetManagement.Core.ConsoleWriter;
using EdmSetManagement.Core.Settings;
using System.IO;

namespace EdmSetManagement.Core.Mp3Meta
{
	public class Mp3Chopper
	{
		public bool RedirectStandardOutput = false;
	
		public void ChopMp3( string fileName, string outputFileName, TimeSpan from, TimeSpan to ) {

			FileInfo outputFile = new FileInfo(outputFileName);

			string spl_args = String.Format(@"""{0}"" {1:000}.{2:00}.{3:00} {4:000}.{5:00}.{6:00} -f -n -o ""{7}.mp3""",
				fileName,
				(int)Math.Floor(from.TotalMinutes),
				from.Seconds,
				(int)Math.Floor((((double)from.Milliseconds / 1000) * 100)), ///mp3splt want 0-100 frames
				(int)Math.Floor(to.TotalMinutes),
				to.Seconds,
				(int)Math.Floor((((double)to.Milliseconds / 1000) * 100)), ///mp3splt want 0-100 frames
				outputFile.Name.Replace(".mp3","")
				);

			Process splitProc = new Process();
			splitProc.StartInfo.FileName = Configuration.Default.Mp3SplitPath;
			splitProc.StartInfo.WorkingDirectory = outputFile.Directory.FullName;
			splitProc.StartInfo.Arguments = spl_args;

			Output.Write("Extracting target using mp3splt...");
			Output.Write(@"Calling .\mp3splt {0}", spl_args);

			splitProc.StartInfo.RedirectStandardOutput = RedirectStandardOutput;
			splitProc.StartInfo.RedirectStandardError = RedirectStandardOutput;
			splitProc.StartInfo.UseShellExecute = false;


			Console.ForegroundColor = ConsoleColor.Blue;
			splitProc.Start();
			splitProc.WaitForExit();

			Console.ResetColor();
		}
	}
}
