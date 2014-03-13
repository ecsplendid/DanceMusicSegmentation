using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;
using EdmSetManagement.Core.Settings;
using System.Diagnostics;
using EdmSetManagement.Core.Mp3Meta;

namespace EdmSetManagement.Core.CuesheetTools
{
	public class Cuesheet
	{
		public string Artist;
		public string Title;
		public List<CuesheetTrack> Tracks;
		public string MediaPath;
		public string PhysicalMediaPath;
		private bool _finishedParsing = true;
		public string CuePath;
		public int AbstractNumber;

		Regex _notAllowChars = new Regex(@"[\\/:\*\?""\<\>\|]");
		
		public string GetFullTitle( ) {

			if (Artist != String.Empty && Title != String.Empty)
				return _notAllowChars.Replace( String.Format("{0} - {1}", Artist, Title), "_" );
			
			if( Title != String.Empty )
				return _notAllowChars.Replace( Title, "_" );
				
			if( Artist != String.Empty )
				return _notAllowChars.Replace( Artist, "_" );
			
			return new FileInfo(CuePath).Name.Replace(".cue",String.Empty);
		}
	
		public bool IsValidCueSheet() {

			return _finishedParsing && Artist != null && Title != null && MediaPath != null && Tracks != null && Tracks.Count() > 0;
		}
		
		public TimeSpan GetMediaLength( ) {
		
			Mp3Sizer ms = new Mp3Sizer();
			
			///maybe its a relative link...
			///so we make it relative to the location of the cuesheet
			if(! File.Exists(PhysicalMediaPath) )
				PhysicalMediaPath = 
					String.Format( 
						@"{0}\{1}",
						new FileInfo(CuePath).Directory.FullName,
						MediaPath
					);
		
			return ms.GetSizeOfMp3File( PhysicalMediaPath );
		}

		public void WriteOutToFile( string cuePath, bool oneStepBackRelative )
		{
			if (!File.Exists(MediaPath)) 
				throw new InvalidOperationException("No media found at MediaPath");

			if (Tracks == null)
				throw new InvalidOperationException("No tracks detected");
				
			StringBuilder cuesheet = new StringBuilder();

			FileInfo f = new FileInfo(MediaPath);
			string relativeFilePath = String.Format("..\\{0}", f.Name);
			string mediaFileType = "MP3";

			if (f.Extension.ToLower().Contains("wav")) mediaFileType = "WAVE";

			cuesheet.AppendFormat(@"PERFORMER ""{0}""
TITLE ""{1}""
FILE ""{2}"" {3}
",
			Artist,
			Title,
			oneStepBackRelative ? relativeFilePath : MediaPath,
			mediaFileType);

			foreach (CuesheetTrack t in Tracks)
			{
				
				cuesheet.AppendFormat(@"  TRACK {2:00} AUDIO
    PERFORMER ""{0}""
    TITLE ""{1}""
    INDEX 01 {3:00}:{4:00}:{5:00}
", t.Artist, t.TrackTitle, t.Number, t.Minutes, t.Seconds, t.Frames);

			}

			File.WriteAllText(cuePath, cuesheet.ToString(), Encoding.Default);
		}

		public static string TimespanToCueTimeString( TimeSpan t ) {

			return 
				String.Format("{0:00}:{1:00}:{2:00}", 
					(int) Math.Floor(t.TotalMinutes), t.Seconds, (int) Math.Floor(((double)t.Milliseconds/1000)*75));
		
		}

		public Cuesheet ParseInFromFile(string cuePath)
		{
			_finishedParsing = false;
			
			CuePath = cuePath;
		
			if(!File.Exists(cuePath) || !cuePath.ToLower().EndsWith(".cue")) 
				return this;
				
			string cueText = File.ReadAllText(cuePath, Encoding.Default);
			
			if( cueText.Length < 10 )
				return this;
			
			FileInfo cueFileInfo = new FileInfo(cuePath);
			
			Regex performer = new Regex( @"PERFORMER\s+?""(?<performer>[^""]*?)""", RegexOptions.Singleline );
			Regex title = new Regex( @"TITLE\s+?""(?<title>[^""]*?)""", RegexOptions.Singleline );
			Regex file = new Regex(@"FILE\s+?""(?<filename>[^""]+?)""\s+?(MP3|WAVE)", RegexOptions.Singleline);
			
			if( cueText.IndexOf("TRACK") == -1 )
				throw new InvalidOperationException("Doesn't look like cuesheet");
			
			string[] main_sheet_array = File.ReadAllLines(cuePath, Encoding.Default);
			string main_sheet_only = String.Join( "\r\n", Enumerable.Range(3,main_sheet_array.Length-3).Select( i=>main_sheet_array[i] ).ToArray() );

			Regex re_performer = new Regex(@"PERFORMER ""(?<perf>.*?)""", RegexOptions.Singleline);
			Regex re_title = new Regex(@"TITLE ""(?<tit>.*?)""", RegexOptions.Singleline);
			Regex re_index = new Regex(@"INDEX \d{2} (?<mins>\d{1,3}):(?<secs>\d{2}):(?<frames>\d{2})", RegexOptions.Singleline);

			var re_performer_matches = re_performer.Matches(main_sheet_only);
			var re_title_matches = re_title.Matches(main_sheet_only);
			var re_index_matches = re_index.Matches(main_sheet_only);

			Debug.Assert( re_performer_matches.Count > 0 
				&& re_performer_matches.Count == re_title_matches.Count 
				&& re_performer_matches.Count == re_index_matches.Count
				&& re_index_matches.Count == re_title_matches.Count, String.Format("invalid cue ({0})", cuePath));

			if( title.IsMatch( cueText ) )
				Title = title.Match(cueText).Groups["title"].Value;
				
			if (file.IsMatch(cueText)) {
				MediaPath = file.Match(cueText).Groups["filename"].Value;

				PhysicalMediaPath = MediaPath;

				if (MediaPath.StartsWith(@"..\"))
					PhysicalMediaPath = 
						Regex.Replace(
							MediaPath, @"^\.\.(?=\\)", 
							new FileInfo(cuePath).Directory.Parent.FullName 
							, RegexOptions.Singleline );
			}
			
			if (performer.IsMatch(cueText))
				Artist = performer.Match(cueText).Groups["performer"].Value;

			Tracks = new List<CuesheetTrack>();

			for( int t = 0; t<re_performer_matches.Count;t++)
			{
				CuesheetTrack track = new CuesheetTrack
				{
					Number = t + 1,
					Artist = re_performer_matches[t].Groups["perf"].Value,
					TrackTitle = re_title_matches[t].Groups["tit"].Value,
					Minutes = Convert.ToInt32(re_index_matches[t].Groups["mins"].Value),
					Seconds = Convert.ToInt32(re_index_matches[t].Groups["secs"].Value),
					Frames = Convert.ToInt32(re_index_matches[t].Groups["frames"].Value),
					Cuesheet = this
				};

				Tracks.Add(track);
			}


			_finishedParsing = true;
			
			return this;
		}
	}
}
