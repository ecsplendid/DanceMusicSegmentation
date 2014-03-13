using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EdmSetManagement.Core.Settings;
using System.IO;
using System.Text.RegularExpressions;
using System.Diagnostics;
using EdmSetManagement.Core.ConsoleWriter;
using System.Threading;
using EdmSetManagement.Core.Mp3Meta;

namespace EdmSetManagement.Core.CuesheetTools.Chopping
{
	/// <summary>
	/// tools for chopping cuesheets, tagging, autochop etc
	/// </summary>
	public class ChoppyTag
	{
		/// <summary>
		/// 1: load in every cuesheet on record
		/// 2: check file association (delete if broken)
		/// 3: check parses OK else delete
		/// </summary>
		public void CleanUpCuesheets() 
		{
			var invalid_cuesheets = new DirectoryInfo(Configuration.Default.DjSetPath)
						.GetDirectories() ///all the artist folders
						.Where(d => d.GetDirectories().Any(sd => sd.Name == "Cuesheets")) ///that have a cuesheet folder
						.Select(d => d.GetDirectories().First(sd => sd.Name == "Cuesheets")) ///select it
						.SelectMany(d => d.GetFiles().Where(f => f.Extension == ".cue")) ///grab all the cuesheets
						.Select(f => new { File = f, Cue = new Cuesheet().ParseInFromFile(f.FullName) }) ///parse the cuesheet
						.Where( new_obj => !new_obj.Cue.IsValidCueSheet()
									|| !File.Exists( new_obj.Cue.PhysicalMediaPath ) ); ///no associated media

			foreach ( var cue_pair in invalid_cuesheets ) {

				Console.ForegroundColor= ConsoleColor.Red;
				Output.Write("Removing invalid artist cuesheet: {0}", cue_pair.File.FullName);
				
				string destFileName = 
					String.Format(
						@"{0}\{1}",
						Configuration.Default.CuesheetPath,
						cue_pair.File.Name );

				if (!File.Exists(destFileName)) cue_pair.File.MoveTo(destFileName);
				else cue_pair.File.Delete();
				
				Console.ResetColor();
			}
		}
	
		/// <summary>
		/// 1: Go through all the recent (T-15 days) cuesheets in the artist/cuesheet folders
		/// 2: If they haven't already been split in D:\chop\month then chop it
		/// 3: chop + tag into destination folder (same name as cue, date keyed on cue)
		/// </summary>
		public void AutoChopLatestSets() {

			Output.Write("Looking for new cuesheets to chop!");

			var cuesheets = new DirectoryInfo( Configuration.Default.DjSetPath )
				.GetDirectories() ///all the artist folders
				.Where( d => d.GetDirectories().Any( sd=>sd.Name=="Cuesheets" ) ) ///that have a cuesheet folder
				.Select( d => d.GetDirectories().First( sd=>sd.Name=="Cuesheets" ) ) ///select it
				.SelectMany( d => d.GetFiles().Where( f=>f.Extension==".cue" ) ) ///grab all the cuesheets
				.Where( f => f.CreationTime > DateTime.Now.Subtract( new TimeSpan( 15,0,0,0,0 ) ) ) ///that are less than 15 days old
				.Select( f=>new {File=f, Cue=new Cuesheet().ParseInFromFile( f.FullName ) }) ///parse the cuesheet
				.Where( f => CueNeedsGenerating(f.File, f.Cue) ) ///doesn't have a corresponding output in chop folder or chop create date -lt cue mod date
				.Where( new_obj => new_obj.Cue.IsValidCueSheet() ) ///is it a valid cuesheet i.e. not empty etc
				.Where( new_obj => File.Exists( new_obj.Cue.PhysicalMediaPath ) ) ///does the associated media file exist?
				.ToList();
					
			if( !cuesheets.Any() )
				Output.Write("No new ones found. They must be associated, valid etc!");
					
			if (!Directory.Exists( Configuration.Default.ChopFolder )) 
				throw new InvalidOperationException("Where is the chop folder?");
			
			foreach( var cue_pair in cuesheets ) {

				string mp3File = cue_pair.Cue.PhysicalMediaPath;
				FileInfo cueFile = cue_pair.File;
				Cuesheet cueSheet = cue_pair.Cue;

				AutoChopCuesheet(mp3File, cueFile, cueSheet);
			}
		}

		public void AutoChopCuesheet(string cueFile) {
			Cuesheet c = new Cuesheet().ParseInFromFile(cueFile);

			AutoChopCuesheet(c.PhysicalMediaPath, new FileInfo(cueFile), c);
		}

		public void AutoChopCuesheet(string mp3File, string cueFile)
		{
			AutoChopCuesheet(mp3File, new FileInfo(cueFile), new Cuesheet().ParseInFromFile(cueFile));
		}

		/// <summary>
		/// chop up a cuesheet into the chop folder -- all automatically baby
		/// </summary>
		/// <param name="mp3File"></param>
		/// <param name="cueFile"></param>
		/// <param name="cueSheet"></param>
		public void AutoChopCuesheet(string mp3File, FileInfo cueFile, Cuesheet cueSheet)
		{
			Output.Write(String.Format("Extracting {0}", cueFile.Name));

			string cueNewPath = GetChopDirectoryForCuesheet(cueFile, cueSheet);

			DirectoryInfo di = new DirectoryInfo(cueNewPath);
			if (!di.Exists) di.Create();
			di.CreationTime = DateTime.Now;

			cueNewPath = FixCuesheetLongFileNamePath(cueFile, cueSheet, cueNewPath, mp3File);

			///we do a before and after thing in case there are other files in there
			///over kill for this application but I already implemented elsewhere and
			///am stealing code
			var filesBefore = di.GetFiles();

			Process proc = new Process();
			proc.StartInfo.FileName = Configuration.Default.Mp3SplitPath;
			proc.StartInfo.Arguments =
				String.Format(@"-a -p gap=0 -f -d ""{0}"" -c ""{1}"" -o ""[@n] @p - @t"" ""{2}""",
					cueNewPath, cueFile.FullName, mp3File);

			Output.Write(String.Format("Splitting MP3 into chunks from {0}...", mp3File));

			proc.StartInfo.RedirectStandardError = false;
			proc.StartInfo.UseShellExecute = false;

			Console.ForegroundColor = ConsoleColor.Yellow;
			proc.Start();
			proc.PriorityClass = ProcessPriorityClass.BelowNormal;

			proc.WaitForExit();
			Console.ResetColor();
			var filesAfter = di.GetFiles();
			var intersection = filesAfter.Intersect(filesBefore);
			var outputFiles = filesAfter.Where(f => !intersection.Contains(f));

			Regex trackNumber = new Regex(@"(?<=\[)\d+(?=\])", RegexOptions.Singleline);

			int track = 0;

			Regex _notAllowChars = new Regex(@"[\\/:\*\?""\<\>\|]");

			foreach (var file in
				outputFiles
					.Where(f => f.Extension == ".mp3")
					.Where(f => trackNumber.IsMatch(f.Name))
					.OrderBy(f => Convert.ToInt32(trackNumber.Match(f.Name).Value)))
			{
				///mp3splt can't be trusted with text encoding i.e. "schössow"
				///also this will ensure double digit formatting on track numbers
				string file_newpath =
					String.Format(
						@"{0}\[{1:00}] {2} - {3}.mp3",
						file.Directory.FullName,
						track + 1,
						_notAllowChars.Replace(cueSheet.Tracks[track].Artist, String.Empty),
						_notAllowChars.Replace(cueSheet.Tracks[track].TrackTitle, String.Empty));

				///maybe the file is already perfect and in "situ"
				if (! File.Exists( file_newpath ) )
					file.MoveTo(file_newpath);

				Mp3Tagger mt = new Mp3Tagger();
				///mp3split kindly litters the file with ID3 garbage (including the comment field...)
				mt.UnTagMp3(file.FullName);

				mt.TagMp3(
					file.FullName,
					cueSheet.Tracks[track].Artist,
					cueSheet.Tracks[track].OriginalTrackTitle,
					cueSheet.GetFullTitle(),
					String.Format("{0:00}", cueSheet.Tracks[track].Number));

				track++;
			}
		}

		private string FixCuesheetLongFileNamePath(FileInfo cueFile, Cuesheet cueSheet, string cueNewPath, string mp3File)
		{
			///bear in mind we have a 255 char limit on paths
			///sometimes the combination of the extraction path, the show name and the 
			///file name will exceed this. we need to address it because it will cause 
			///mp3splt to bomb out
			
			///bear in mind we take ".mp3" to be 4 chars, so calculations have 4 taken away straight away
			///we also drop another one for the last trailing backslash
			var illegals = cueSheet.Tracks.Where(t => (t.GetFullTitle().Length + cueNewPath.Length) >= 251);

			if( !illegals.Any() ) return cueNewPath;

			Output.Write("Found {0} track(s) with an illegally long file name (>255 chars). Attempting to fix.", illegals.Count() );

			string[] befores = illegals.Select(t=>t.TrackTitle).ToArray();
			
			foreach (CuesheetTrack illegal_track in illegals)
			{
				illegal_track.OriginalTrackTitle = illegal_track.TrackTitle;
			
				///heuristic 1 == remove anything in square brackets like [Global Selection Winner]
				illegal_track.TrackTitle = Regex.Replace(illegal_track.TrackTitle, @"\[[^\]]+?\]", String.Empty);

				if (illegal_track.TrackTitle.Length + cueNewPath.Length < 251) continue;

				///heuristic 2 == remove anything in parenthesis like  (Aurosonic Remix)
				illegal_track.TrackTitle = Regex.Replace(illegal_track.TrackTitle, @"\([^\)]+?\)", String.Empty);

				if (illegal_track.TrackTitle.Length + cueNewPath.Length < 251) continue;

				///heuristic 3 == trim right as far as is nessecary
				int needtosave = cueNewPath.Length + illegal_track.TrackTitle.Length - 256;
				illegal_track.TrackTitle = illegal_track.TrackTitle.Substring(0, illegal_track.TrackTitle.Length - needtosave);

				if (illegal_track.TrackTitle.Length + cueNewPath.Length < 251) continue;

				///all else has failed, we have a situation where the show title is just too long, 
				///this is rare and we will now chop away from that in the same way -- this will affect
				///the extracted location

				///square brackets in the cuesheet title
				cueSheet.Title = Regex.Replace(cueSheet.Title, @"\[[^\]]+?\]", String.Empty);
				cueNewPath = GetChopDirectoryForCuesheet(cueFile, cueSheet);
				Output.Write("Changing cuesheet title to {1} (removing squares)", cueSheet.Title);

				if (illegal_track.TrackTitle.Length + cueNewPath.Length < 251) continue;

				///round brackets in the cuesheet title
				cueSheet.Title = Regex.Replace(cueSheet.Title, @"\([^\)]+?\)", String.Empty);
				cueNewPath = GetChopDirectoryForCuesheet(cueFile, cueSheet);
				Output.Write("Changing cuesheet title to {1} (removing round brackets)", cueSheet.Title);
			}

			string[] afters = illegals.Select(t => t.TrackTitle).ToArray();

			///write out the conversions
			Enumerable.Range(0,befores.Length)
				.ToList()
				.ForEach( i=>Output.Write( "\t{0} --> {1}", befores[i], afters[i] ) );

			///rewrite out the edited cuesheet
			cueSheet.WriteOutToFile(cueFile.FullName, true);
			return cueNewPath;
		}

		private bool CueNeedsGenerating(FileInfo f, Cuesheet cue)
		{
			DirectoryInfo chopDir = new DirectoryInfo( GetChopDirectoryForCuesheet(f, cue) );
		
			return 
				!chopDir.Exists ///doesn't have a corresponding output in chop folder
					|| chopDir.CreationTime < f.LastWriteTime; ///the cue sheet has been subsequently updated
		}

		private string GetChopDirectoryForCuesheet(FileInfo cuefile, Cuesheet cue)
		{
			Regex month = new Regex("[a-zA-Z]+", RegexOptions.Singleline);
			
			string destDir =
				String.Format(
					@"{3}\{0} {1}\{2}",
					month.Match(cuefile.LastWriteTime.ToLongDateString()).Value,
					cuefile.LastWriteTime.Year,
					cue.GetFullTitle(),
					Configuration.Default.ChopFolder);

			return destDir;
		}
	}
}
