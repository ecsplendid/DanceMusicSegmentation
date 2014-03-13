using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using EdmSetManagement.Core.Settings;
using System.Text.RegularExpressions;
using EdmSetManagement.Core.ConsoleWriter;
using EdmSetManagement.Core.Mp3Meta;
using System.Diagnostics;

namespace EdmSetManagement.Core.CuesheetTools.Searching
{
	/// <summary>
	/// search for tracks inside our artist\cuesheet folders, or all cuesheets in the dump folder
	/// there is also an option to extract the matches and generate a winamp pls file + shell execute 
	/// if we have the associated media -- how cool does it get??
	/// </summary>
	public class CueTrackSearcher
	{
		public void Search( string what, bool extract, bool everything ) { 
	
			Regex match = new Regex(what, RegexOptions.Singleline | RegexOptions.Compiled | RegexOptions.IgnoreCase);
			
			Output.Write(@"Searching for ""{0}""...", what);
			
			var artistCues = new DirectoryInfo(Configuration.Default.DjSetPath)
						.GetDirectories() ///all the artist folders
						.Where(d => d.GetDirectories().Any(sd => sd.Name == "Cuesheets")) ///that have a cuesheet folder
						.Select(d => d.GetDirectories().First(sd => sd.Name == "Cuesheets")) ///select it
						.SelectMany(d => d.GetFiles().Where(f => f.Extension == ".cue")); ///grab all the cuesheets

			var recordingCues = new DirectoryInfo(Configuration.Default.DjSetPath)
				.GetDirectories() ///all the artist folders
				.Where(d => d.GetDirectories().Any(sd => sd.Name == "Recordings")) ///that have a cuesheet folder
				.Select(d => d.GetDirectories().First(sd => sd.Name == "Recordings")) ///select it
				.SelectMany( d=>d.GetDirectories() ) ///records are in sub folders
				.SelectMany(d => d.GetFiles().Where(f => f.Name == "master.cue")); ///grab all the cuesheets
			
			List<FileInfo> cues = new List<FileInfo>(artistCues);

			cues.AddRange(recordingCues);

			if (everything)
			{
				var allCues = new DirectoryInfo(Configuration.Default.CuesheetPath)
						.GetFiles()
						.Where(f => f.Extension == ".cue"); ///grab all the cuesheets

				cues.AddRange(allCues);
			}
			
			var matched_tracks =
						cues																
						.Select(f => new { File = f, Cue = new Cuesheet().ParseInFromFile(f.FullName) }) ///parse the cuesheet
						.Where( cs=>cs.Cue.IsValidCueSheet() )
						.Where(cs => everything || File.Exists(cs.Cue.PhysicalMediaPath))
						.SelectMany( cs=>cs.Cue.Tracks )
						.Where( t=> match.IsMatch(t.GetFullTitle()) );

			if( !matched_tracks.Any() ) {
				Output.Write("No matches found in artist cues.");
				return;
			}
			
			foreach( var hit in matched_tracks ) {

				Console.ForegroundColor = ConsoleColor.DarkGray;
				Output.Write( @"[{0}]", hit.Cuesheet.GetFullTitle() );
				Output.Write(@"[{0}]", new FileInfo(hit.Cuesheet.PhysicalMediaPath).Directory.FullName );

				Console.ForegroundColor = ConsoleColor.Green;
				Output.Write( @"Track {1}:{0}",hit.GetFullTitle(), hit.Number );
				
				Console.WriteLine();
				Console.ResetColor();
			}

			if (!extract || everything) return;

			Mp3Chopper mc = new Mp3Chopper();
			mc.RedirectStandardOutput = true;
			Mp3Tagger mt = new Mp3Tagger();
			
			Console.ForegroundColor = ConsoleColor.Yellow;
			Output.Write("Extracting search results...");
			Console.ResetColor();
			
			DirectoryInfo searchResults = 
				new DirectoryInfo(
					String.Format( @"{0}\!SearchResults", Configuration.Default.DjSetPath 
					) );
					
			if(!searchResults.Exists) searchResults.Create();

			FileInfo playlist =
					new FileInfo(
						String.Format(
							@"{0}\{1}.pls",
							searchResults.FullName,
							DateTime.Now.ToString("yyyyMMdd@HHmmss")));
							
			File.AppendAllText(playlist.FullName, String.Format( @"[playlist]
NumberOfEntries={0}
", matched_tracks.Count()));
			
			int num = 1;
			
			foreach( var hit in matched_tracks ) {
			
				FileInfo resultOutput = 
					new FileInfo( 
						String.Format(
							@"{0}\[{2:00}] {1}.mp3", 
							searchResults.FullName,
							hit.GetFullTitle(),
							num));
			
				TimeSpan to = new TimeSpan(0,999,0);

				Console.ForegroundColor = ConsoleColor.Green;
				Output.Write("Writing {0}", resultOutput.FullName);
				Console.ResetColor();
			
				if( hit.Number < hit.Cuesheet.Tracks.Count()-1 )
					to = hit.Cuesheet.Tracks[hit.Number].GetTimeSpan();
			
				///extract track
				mc.ChopMp3( 
					hit.Cuesheet.PhysicalMediaPath, 
					resultOutput.FullName,
					hit.GetTimeSpan(),
					to );

				mt.TagMp3(resultOutput.FullName, hit.Artist, hit.TrackTitle, hit.Cuesheet.GetFullTitle());

				File.AppendAllText(playlist.FullName, String.Format("File{0}={1}\r\n", num++, resultOutput.FullName), Encoding.Default);
			}

			Process play = new Process();
			play.StartInfo.FileName = playlist.FullName;
			play.StartInfo.UseShellExecute = true;
			play.Start();
			
			
			
			
		}
	
	}
}

			
