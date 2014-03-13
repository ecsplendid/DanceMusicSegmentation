using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EdmSetManagement.Core.Settings;
using System.IO;
using System.Text.RegularExpressions;
using EdmSetManagement.Core.CuesheetTools.Association.Identifiers;
using EdmSetManagement.Core.ConsoleWriter;
using System.Diagnostics;
using System.Threading;

namespace EdmSetManagement.Core.CuesheetTools.Association
{
	public class HourSplitter
	{
		/// <summary>
		///Same as the associator but when association found, it will split based on "Hour x"
		///For example I use this on Matt Dareys show -- we record it as one 2 hour show
		///but most cue sheets are for hour1 and hour2 seperate -- so we split the main show up and name it
		///with the cuesheet name
		/// </summary>
		/// <param name="assoc"></param>
		/// <param name="artist"></param>
		/// <param name="cuesheetMatchRegex"></param>
		/// <param name="showId"></param>
		public void Split(
			AssociationType assoc,
			string artist,
			string cuesheetMatchRegex,
			IShowIdentifier showId)
		{
			Regex cuesheetRegex = new Regex(cuesheetMatchRegex, RegexOptions.Singleline);
			DirectoryInfo cuePath = new DirectoryInfo(Configuration.Default.CuesheetPath);

			Output.Write("Getting Artist Folder...");

			DirectoryInfo artistFolder = new DirectoryInfo(Configuration.Default.DjSetPath)
				.GetDirectories()
				.Where(d => d.Name.ToLower() == artist.ToLower())
				.First();

			DirectoryInfo artistFolderCuePath =
				new DirectoryInfo(
					String.Format(@"{0}\Cuesheets", artistFolder.FullName));

			Output.Write("Finding Relevant Cuesheets...");

			var cues = cuePath
				.GetFiles()
				.OrderByDescending(f => f.LastWriteTime)
				.Take(1000)
				.Where(f => cuesheetRegex.IsMatch(f.Name))
				.Take(20);

			Output.Write(String.Format("\t->Found {0}", cues.Count()));

			var artistMp3s = artistFolder
				.GetFiles()
				.Where(f => f.Name.ToLower().EndsWith(".mp3"));

			///for every matching cue -- does it have an mp3 associated in the folder

			Regex dateParse = null;
			DateShowIdentifier di = null;
			NumberShowIdentifier ni = null;
			Regex numberParseRegex = null;
			Regex mustAlso = null;

			///chop down the list with the relevant show id patterns
			///when we loop through the cues, we want to assume they are parsable candidates
			if (assoc == AssociationType.DateFormat)
			{
				di = (DateShowIdentifier)showId;
				dateParse = new Regex(di.DateParseRegex);
				cues = cues.Where(f => dateParse.IsMatch(f.Name));
			}
			else if (assoc == AssociationType.ShowNumber)
			{
				ni = (NumberShowIdentifier)showId;
				numberParseRegex = new Regex(ni.NumberParseRegex);
				cues = cues.Where(f => numberParseRegex.IsMatch(f.Name));
			}

			if (showId.MustAlsoMatch != null)
			{
				mustAlso = new Regex(showId.MustAlsoMatch, RegexOptions.Singleline);
				cues = cues.Where(f => mustAlso.IsMatch(f.Name));
			}

			bool anyUpdates = false;

			foreach (FileInfo cue in cues)
			{
				IEnumerable<FileInfo> relevantMp3s = null;

				///extract out the unique id from the cue name
				if (assoc == AssociationType.DateFormat)
				{
					string showIdString =
						DateTime.Parse(
							dateParse.Match(cue.Name).Value
							).ToString(di.DateFormat);

					relevantMp3s = artistMp3s.Where(f => f.Name.Contains(showIdString));
				}

				else if (assoc == AssociationType.ShowNumber)
				{
					string showIdentifier = numberParseRegex.Match(cue.Name).Value;
					relevantMp3s = artistMp3s.Where(f => numberParseRegex.IsMatch(f.Name) && numberParseRegex.Match(f.Name).Value == showIdentifier);
				}

				foreach (var mp3 in relevantMp3s)
				{
					string plainName = cue.Name.Replace(cue.Extension, String.Empty);
					string cueHourName = String.Format("{0}.mp3", plainName);

					///if we dont have a cuesheet for this MP3 already then...
					if (!artistFolder.GetFiles().Any(f => f.Name == cueHourName))
					{
						Process proc = new Process();
						proc.StartInfo.FileName = Configuration.Default.Mp3SplitPath;
						
						if( cueHourName.Contains("Hour 1") ) {
							proc.StartInfo.Arguments = String.Format(@"""{0}"" 0.0 60.0 -f -o ""{1}"" -n -d ""{2}""", mp3.FullName, cueHourName, mp3.Directory.FullName);
							
						}
						else if( cueHourName.Contains("Hour 2") ) {
							proc.StartInfo.Arguments = String.Format(@"""{0}"" 60.0 999.0 -f -o ""{1}"" -n -d ""{2}""", mp3.FullName, cueHourName, mp3.Directory.FullName);
						}
						
						proc.StartInfo.CreateNoWindow = true;
						proc.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
						proc.StartInfo.RedirectStandardError = true;
						proc.StartInfo.UseShellExecute=false;
						proc.Start();
					
						Console.WriteLine("");

						Thread t = new Thread( new ThreadStart( delegate() {

							while (!proc.HasExited) {
								Console.Write(proc.StandardError.ReadToEnd());
								Thread.Sleep(50);
							}
						
						} ) );

						t.Start();						


						Console.WriteLine("");
						
						anyUpdates = true;
					}
				}
			
			}
			
			if (!anyUpdates) Output.Write("No fresh associations found for splitting");
		}
	}
}
