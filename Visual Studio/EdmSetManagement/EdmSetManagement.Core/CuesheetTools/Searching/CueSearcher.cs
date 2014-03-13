using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using EdmSetManagement.Core.Settings;
using System.Text.RegularExpressions;
using EdmSetManagement.Core.ConsoleWriter;

namespace EdmSetManagement.Core.CuesheetTools.Searching
{
	public class CueSearcher
	{
		public void Search(string what) {
	
			if(what==String.Empty) what = ".";
	
			Regex pattern = new Regex(what, RegexOptions.Singleline | RegexOptions.IgnoreCase );

			Output.Write(@"Searching for ""{0}""...", what);

			Console.WriteLine();

			var allCues = new DirectoryInfo(Configuration.Default.CuesheetPath)
						.GetFiles()
						.Where( f => f.Extension == ".cue" ) ///grab all the cuesheets
						.Where( f => pattern.IsMatch( f.Name )  )
						.OrderByDescending( f=>f.LastWriteTime )
						.ToList();


			if (!allCues.Any())
			{
				Output.Write("No cues found in artist cues.");
				return;
			}
			
			Console.ForegroundColor = ConsoleColor.Green;
			
			int num=1;
			allCues
				.Take(30)
				.ToList()
				.ForEach( f=>Output.Write("[{0:00}]> {1}", num++, f.Name) );

			Console.ResetColor();

			if (allCues.Count() > 30)
			{
				Output.Write("More than 30 results... <snipping>");
				return;
			}
		
		}
	
	}
}
