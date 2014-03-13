using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using EdmSetManagement.Core.Settings;
using System.Diagnostics;
using EdmSetManagement.Core.ConsoleWriter;
using System.Threading;
using System.Text.RegularExpressions;
using EdmSetManagement.Core.CuesheetTools;
using EdmSetManagement.Core.Mp3Meta;
using System.Reflection;
using EdmSetManagement.Core.CuesheetTools.Chopping;

namespace EdmSetManagement.Core.Recording
{
	public class ShowRecorder
	{
		Mp3Tagger _tagger = new Mp3Tagger();
		Mp3Chopper _chopper = new Mp3Chopper();
		DirectoryInfo _artistFolder = null;
		string _recordingJobCode;
		string _recordingName;
		DirectoryInfo _recordingsFolder;
		FileInfo _mainOutputFile;
		FileInfo _masterOutputConcatFile;
		FileInfo _mainCueFile;
		List<CuesheetTrack> _allTracks;
		string _extractionTarget;
		List<FileInfo> _allChunks;
		List<FileInfo> _mp3s;
		List<FileInfo> _cues;
		bool _isContigousRip=true;
		string _premadeRecordingLocation;
		string _url;
		string _urlMasked;
		string _masterCueSheetPath = null;
		bool _extractionTargetProvided = false;
		bool _extractionTargetsFound = false;
		bool _targetExtractedSucessfully = false;
	
		/// <summary>
		/// the default overload -- see other one for desc
		/// </summary>
		/// <param name="url"></param>
		/// <param name="artist"></param>
		/// <param name="howlong"></param>
		/// <param name="extractionTarget"></param>
		public void RecordGeneric( 
			string url, 
			string artist,
			int minutes, 
			string extractionTarget ) {

				RecordGeneric(url, artist, minutes, extractionTarget, null);
		}

		public void RecordGeneric(
		string url,
		string artist,
		int minutes)
		{

			RecordGeneric(url, artist, minutes, null, null);
		}
	
		/// <summary>
		/// 1: do we have an artist and recordings folder? if not create them
		/// 2: create a recording file name rec_dateinfo.mp3
		/// 3: kick off the recording
		/// 4: if the connection got interupted we need to:
		/// 4a	->binary concat the mp3s back together
		/// 4b	->gather all the tracks together from all cues, removing overlap dupes
		/// 4c	->nudge forward the times of the cue sheets to take into account the length of previous ones
		/// 5: find the target track/show and exract it using a clever heuristic to avoid provider metadata splitting it up
		/// 6: move the finished product back to the artist folder
		/// 7: generate a filtered cuesheet and output it to support the recording
		/// 8: write out some logging data for diagnostics
		/// </summary>
		/// <param name="url"></param>
		/// <param name="artist"></param>
		public void RecordGeneric( 
		string url, 
		string artist, 
		int minutes, 
		string extractionTarget,
		string premadeRecordingLocation ) {

			_extractionTarget = extractionTarget;	
			
			_extractionTargetProvided = _extractionTarget != String.Empty && _extractionTarget != null;
				
			TimeSpan howlong = new TimeSpan(0,minutes,0);
			_premadeRecordingLocation = premadeRecordingLocation;
			_url = url;

			///resolve aliases throw exception if blatently not a URL
			url = ResolveUrl(url);
			
			

			SetArtistFolder(artist);
			SetRecordingFolder();

			///this is mainly for testing purposes -- you can run all the stuff on a previous recording
			///everything here is repeatable and you can run it again and again to clarify the process
			///you can even use this feature for "unfucking" old broken streamripper rips
			if( premadeRecordingLocation != null )
				_recordingsFolder = new DirectoryInfo(premadeRecordingLocation);
			else CallStreamRipper(url, howlong);
		
			SetMainOutputFiles();
			GatherStreamRipperChunksTogether();

			///non contig rip scenario -- binary concat the individual mp3s together
			BinaryConcatChunks( _mp3s );
			
			PopulateTracksFromCues(_cues);
			WriteTracksOut();
			
			///in the non-contigous rip scenario -- nudge the tracks forward on sucessive cuesheets
			NudgeTracksForward(_allTracks);

			///remove duplicate tracks i.e. for every pair of adjacent dupes, remove the first
			///then reset abstract numbers
			RemoveAdjacentDuplicates();
		
			///find target track and extract it, move it to artist folder
			ExtractTargets();

			///dump everything that got logged
			//Output.DumpLog(String.Format(@"{0}\log.txt", _recordingsFolder.FullName));
			
			///write out a cuesheet anyway
			WriteMasterCuesheet();
			
			///if canvassing, auto chop now
			AutoChopIfNoExtractionTarget();

			///delete unnessecary MP3 files
			DeleteUnnessecaryFiles();
			
			Output.Write("Updating modified date stamp on artist folder to now.");
			try{
				_artistFolder.LastWriteTime = DateTime.Now;
			}catch{}
			
			Output.Write("Done!");
		}

		private void AutoChopIfNoExtractionTarget()
		{
			if (!_extractionTargetProvided)
			{
				Output.Write("As probably canvassing -- auto chopping this rip for easy accessibility");
				ChoppyTag ct = new ChoppyTag();
				ct.AutoChopCuesheet(_masterOutputConcatFile.FullName, _masterCueSheetPath);
			}
		}

		/// <summary>
		/// currently in testing phase
		/// </summary>
		private void DeleteUnnessecaryFiles()
		{
			
			Console.ForegroundColor = ConsoleColor.Cyan;
		
			_mp3s.Remove(_masterOutputConcatFile);

			if (_mp3s.Any()) Output.Write("Cleaning up split chunks that were concatenated anyway");
			_mp3s.ForEach(f => {Output.Write("DELETED: \t->{0}", f.Name);f.Delete();});
			
			
			Console.ResetColor();
		
		}

		private void RemoveAdjacentDuplicates()
		{
			if (_allTracks.Count <= 1) return;
		
			Console.ForegroundColor = ConsoleColor.Cyan;
		
			Output.Write("Removing adjacent duplicates...");
		
			///remove duplicate tracks i.e. for every pair of adjacent dupes, remove the SECOND
			///this might happen after a stitched recording comes together
			///we always leave the first track otherwise we may lose information -- this may fuck up on us but better safe and retrofix
			///then reset abstract numbers
			
			///first delete any tracks where the *prev* track is has the same title
			///exclude the first + last track -- we never want to lose the first track
			var dupes 
				= _allTracks
					.Where( t => t != _allTracks.Last() && t != _allTracks.First() )
					.Where( t => t.GetFullTitle() == _allTracks[t.AbstractNumber-2].GetFullTitle() )
					.ToList();
			
			///at this point we may still have adjacent duplicates i.e. track 1+2 
			///so in this scenario we add track 2 to the list of dupes
			if (_allTracks.Count > 1 &&  _allTracks.First().GetFullTitle() == _allTracks[1].GetFullTitle() )
				dupes.Add(_allTracks[1]);

			if (dupes.Any())
			{
				Output.Write("\t->{0} dupes found!", dupes.Count());

				dupes.ForEach(t => Output.Write("\t\t->[{0:00}] {1} @ {2}", t.AbstractNumber, t.GetFullTitle(), t.GetTimeSpan()));

				_allTracks.RemoveAll(t => dupes.Contains(t));
				int new_abstractnumber = 1;
				
				Output.Write("\t->Resetting abstract numbers on remaining tracks" );
				_allTracks.ForEach(t => t.AbstractNumber = new_abstractnumber++);
			}
			
			else Output.Write("\t->No dupes found");
			
			Console.ResetColor();
		}

		/// <summary>
		/// turn an alias like di_trance into a proper URL using a supplied text file
		/// </summary>
		/// <param name="url"></param>
		/// <returns></returns>
		private string ResolveUrl(string url)
		{
			if (!url.StartsWith("http:"))
			{
				var urls = File.ReadAllLines( Configuration.Default.StationsList )
					.Where(l => l.Contains("\t"))
					.Where(l => l.Split('\t')[0] == url)
					.Select(l => l.Split('\t')[1]);

				_urlMasked =  Regex.Replace( _url, @"\?.+", "?*****...");

				if (urls.Any())
				{
					Output.Write("Resolved \"{0}\" to URL {1}", url, _urlMasked);
					url = urls.First();
				}
				else throw new InvalidOperationException("Not a valid URL and I can't find an alias matching it...");
			}
			return url;
		}

		/// <summary>
		/// populate the _mp3s, _cues and _allChunks -- resultant outputs from streamripper
		/// </summary>
		private void GatherStreamRipperChunksTogether()
		{
			///OK now we have finished recording. 
			///if the connection was not interupted, we will have one output file and one cuesheet
			///if it was interupted we will have an output file (corresponding to the last chunk)
			///and chunks with associated cuesheets for every section i.e. 

			//Mode                LastWriteTime     Length Name
			//----                -------------     ------ ----
			//-a---        17/08/2009     15:56        359 tester (1).cue
			//-a---        17/08/2009     15:56   13574144 tester (1).mp3
			//-a---        17/08/2009     16:05        249 tester (2).cue
			//-a---        17/08/2009     16:04   16506880 tester (2).mp3
			//-a---        17/08/2009     16:06        135 tester (3).cue
			//-a---        17/08/2009     16:05    1802240 tester (3).mp3
			//-a---        17/08/2009     16:06        128 tester.cue
			//-a---        17/08/2009     16:08    3899392 tester.mp3
		
			Regex _chunkCode = new Regex(@"\((?<code>\d+)?\)\.(mp3|cue)", RegexOptions.Singleline);

			_mp3s = new List<FileInfo>();
			_cues = new List<FileInfo>();

			_allChunks = _recordingsFolder
				.GetFiles()
				.Where(f => _chunkCode.IsMatch(f.Name))
				.Select(f => new { File = f, Code = Convert.ToInt32(_chunkCode.Match(f.Name).Groups["code"].Value) })
				.OrderBy(no => no.Code)
				.Select(no => no.File)
				.ToList();

			_mp3s.Add(_mainOutputFile);
			_cues.Add(_mainCueFile);
			_isContigousRip = !_allChunks.Any();
			_mp3s.InsertRange(0, (_allChunks.Where(f => f.Extension == ".mp3")));

			///now we have one big master file, even if the rip wasn't contigous
			///what remains is for us to figure out a picture of the track indexes for the rip
			_cues.InsertRange(0, _allChunks
				.Where(f => f.Extension == ".cue"));
		}

		private void WriteTracksOut()
		{
			Output.Write("Tracks in the cuesheet(s):");
			_allTracks.ToList().ForEach(t =>
				Output.Write(
					"\t->C{3:00}T{2:00}_{1}: {0}",
					t.GetFullTitle(),
					Cuesheet.TimespanToCueTimeString(t.GetTimeSpan()),
					t.AbstractNumber,
					t.Cuesheet.AbstractNumber
					));
		}

		/// <summary>
		/// take out all the tracks and set the abstract numbers
		/// so from any cue or track we can see where it fits in the
		/// larger picture
		/// </summary>
		/// <param name="cues"></param>
		private void PopulateTracksFromCues(List<FileInfo> cues)
		{
			///parse all the cues and get all the tracks from all of them
			_allTracks = cues
				.Select(f => new Cuesheet().ParseInFromFile(f.FullName))
				.SelectMany(cs => cs.Tracks)
				.ToList();

			var first = _allTracks.First();

			///even though the tracks are for disparate cue sheets, number them all with AbstractNumber
			int tr_number = 1;
			int cue_number = 1;
			_allTracks.ForEach(tr => tr.AbstractNumber = tr_number++);
			_allTracks.Select(tr => tr.Cuesheet)
				.Distinct()
				.ToList()
				.ForEach(cs => cs.AbstractNumber = cue_number++);
		}

		private void SetMainOutputFiles()
		{
			_mainOutputFile =
				new FileInfo(
					String.Format(
						@"{0}\{1}.mp3",
						_recordingsFolder.FullName,
						_recordingName
						));

			Output.Write("Main output file: {0}", _mainOutputFile.FullName);

			_mainCueFile =
				new FileInfo(
					String.Format(
						@"{0}\{1}.cue",
						_recordingsFolder.FullName,
						_recordingName
						));
						
			if( !_mainOutputFile.Exists || !_mainCueFile.Exists ) {
				throw new InvalidProgramException("Looks like StreamRipper didn't output anything!");
			}
		}

		private void SetRecordingFolder()
		{
			_recordingJobCode =
				String.Format(
					"job_{0:00}{1:00}_{4:00}{2:00}{3:00}",
					DateTime.Now.Day,
					DateTime.Now.Month,
					DateTime.Now.Minute,
					DateTime.Now.Second,
					DateTime.Now.Hour);

			_recordingName = "show";

			_recordingsFolder =
				new DirectoryInfo(
					String.Format(@"{0}\Recordings\{1}",
						_artistFolder.FullName,
						_recordingJobCode));

			Output.Write("Recording directory is {0}", _recordingsFolder.FullName);

			/// we expect this to be unique - so delete if exists now
			/// we also assume this will create the underlying Recordings folder
			/// so if you are here in a debugger thinking wtf, hat tip :)
			if( _premadeRecordingLocation == null ) {
				if (_recordingsFolder.Exists) _recordingsFolder.Delete();
				_recordingsFolder.Create();
			}
		}

		private void SetArtistFolder(string artist)
		{
			_artistFolder =
				new DirectoryInfo(
					String.Format(@"{0}\{1}",
						Configuration.Default.DjSetPath,
						artist));
			if (!_artistFolder.Exists) _artistFolder.Create();

			Output.Write("Artist directory is {0}", _artistFolder.FullName);
		}

		private void WriteMasterCuesheet()
		{
			Cuesheet masterParsed = new Cuesheet();
			masterParsed.MediaPath = _masterOutputConcatFile.FullName;
			masterParsed.Title = String.Format( "Rip from {0} on {1}", _urlMasked, DateTime.Now.ToString("dddd MMMM dd yyyy") );
			masterParsed.Tracks = _allTracks;
			_masterCueSheetPath = String.Format(@"{0}\master.cue", _recordingsFolder.FullName);
			masterParsed.WriteOutToFile(_masterCueSheetPath, false);
		}

		
		/// <summary>
		/// now we have the golden list of relevant tracks
		/// we need to find the target track and extract it
		/// the ideal scenario is that only one track will match the target
		/// on DI.FM this will be the case
		/// however AH.FM pollutes shit into the metadata -- sometimes random ads or appending
		/// the track name with "On Air:" etc. 
		/// our strategy is to join the first and last occurance of the match to be one big track
		/// that way we dont need to be concerned about trying to filter shitty metadata which isn't a robust solution
		/// we will always take the FIRST occurance to be the official name as AH.FM usually gives you one clean one first
		/// </summary>
		/// <param name="extractionTarget"></param>
		/// <param name="artistFolder"></param>
		/// <param name="recordingsFolder"></param>
		/// <param name="masterOutputFile"></param>
		/// <param name="relevantTracks"></param>
		private void ExtractTargets()
		{
			if (!_extractionTargetProvided) {
				Output.Write("No extraction target provided -- as this is probably a canvassing session");
				
				return;
			}
		
			Output.Write("Searching for extraction target ({0})", _extractionTarget);

			Regex extractionTargetRegex = new Regex(_extractionTarget, RegexOptions.Singleline | RegexOptions.IgnoreCase);

			var targets = _allTracks.Where(tr => extractionTargetRegex.IsMatch(tr.GetFullTitle()));

			_extractionTargetsFound = targets.Any();

			if (!_extractionTargetsFound)
			{
			
				Output.Write("The requested target wasn't found in any of the tracks -- no extraction to perform.");
				
				return;
			}
			
			TimeSpan startPoint = targets.First().GetTimeSpan();

			Output.Write("Found suitable target:  {0} @ {1} ({2})", 
				targets.First().GetFullTitle(), 
				Cuesheet.TimespanToCueTimeString(startPoint),
				startPoint );
				
			if(targets.Count() > 1) {
			
				Output.Write("More than one target was found though (AH.FM recording?):");
				Console.ForegroundColor = ConsoleColor.Green;
				targets.ToList().ForEach( ct=>Output.Write("\t->Track {1}: {0}",ct.GetFullTitle(), ct.AbstractNumber ) );
				Output.Write("We will take all these matches and in between as one match");
				Console.ResetColor();
			}

			///two cases here. if the last index is the last track then we split to the end of the media file
			///i.e. the sum of all the chunks
			///otherwise we split to the index of the next track
			int lastIndex = _allTracks.FindIndex(tr => tr == targets.Last());

			///so MP3 split will cap it at the length of the MP3 anyway so 999 works good
			TimeSpan endPoint = new TimeSpan(0, 999, 0);

			if (lastIndex < _allTracks.Count() - 1)
			{
				endPoint = _allTracks[lastIndex+1].GetTimeSpan();

				Output.Write("There is another track after our target, so setting end index to {0}", endPoint);
			}

			else Output.Write("Target is the ending track so splitting to the end of media.");

			string extractionTarget = 
				String.Format(@"{1}\{0}.mp3", 
				PurifyExtractionTarget(targets.First().GetFullTitle(), true),
				_recordingsFolder.FullName );

			_chopper.ChopMp3(
				_masterOutputConcatFile.FullName,
				extractionTarget,
				 startPoint,
				 endPoint);
			
			FileInfo extractionTargetFile =
				new FileInfo(extractionTarget);

			/// mp3splt litters the output file with garbage ID3 metadata (even with the -n option). FAIL.
			_tagger.UnTagMp3(extractionTargetFile.FullName);

			///change 09 jan 2010 -- use the MP3 file as the album tag in the ID3 instead of the "Recording Target"
			///usually the file name is already descriptive
			_tagger.TagMp3(
				extractionTargetFile.FullName,
				PurifyExtractionTarget( targets.First().Artist, false ),
				PurifyExtractionTarget( targets.First().TrackTitle, false ),
				extractionTargetFile.Name.Replace(extractionTargetFile.Extension, String.Empty)
				 );

			///let's move our extracted file out to the main artist folder
			if (extractionTargetFile.Exists)
			{
				_targetExtractedSucessfully = true;
			
				Output.Write("Moving target to artist folder.");

				string newLocation = String.Format(
						@"{0}\{1}",
						_artistFolder.FullName,
						extractionTargetFile.Name);
			
				if (!File.Exists(newLocation)) 
					extractionTargetFile.MoveTo(newLocation);
				else Output.Write("The output target already exists in the artist folder, I'll keep our fresh one in the recordings folder");
			}

			else Output.Write("Can't find the extraction target -- mp3split failed?");
		}

		/// <summary>
		/// as this will be saved to the file system, remove illegal chars
		/// also strip away any shitty metadata that we don't like i.e. "On Air:..." from AH.FM
		/// </summary>
		/// <param name="name"></param>
		/// <returns></returns>
		private string PurifyExtractionTarget(string name, bool file_system)
		{
			Regex stripStationMeta = 
				new Regex( 
					Configuration.Default.StationMetaStrip, 
					RegexOptions.IgnoreCase | RegexOptions.Singleline );

			///chars not allowed in file names
			Regex _notAllowChars = new Regex(@"[\\/:\*\?""\<\>\|]");
			
			name = stripStationMeta.Replace( name, String.Empty );
			
			if(file_system) name = _notAllowChars.Replace( name, String.Empty );
			
			return name;
		}
		


		/// <summary>
		/// if the streamripper connection got interupted -- we need to stick the pieces together
		/// </summary>
		/// <param name="mp3s"></param>
		private void BinaryConcatChunks( List<FileInfo> mp3s )
		{
			if(_isContigousRip) {
				_masterOutputConcatFile = _mainOutputFile;
				return; ///no need to continue here!
			}

			Console.ForegroundColor = ConsoleColor.Yellow;
			///now we have the files in order
			///lets binary concatenate them
			Output.Write("Rip non-contigous. Binary concatting files together:");

			/// the process is that we binary concatenate the files together (numbers first, then the last one)
			/// i.e. cmd copy /b "rec_2209_205901 (1).mp3"+"rec_2209_205901 (2).mp3"+"rec_2209_205901.mp3"
			/// then we merge the cuesheets: (1) remove the 00:00:00 tracks from 2..n sheets (not first) 
			/// then (2) increment the times on tracks to include length of previous mp3s

			string cmd_args = String.Format(@"/c copy /b {0} concat.mp3",
					String.Join("+", mp3s.Select(f => "\"" + f.Name + "\"").ToArray()));

			Output.Write("\t-> cmd /c {0}", cmd_args);
			Console.ResetColor();

			Process proc = new Process();
			proc.StartInfo.FileName = "cmd.exe";
			proc.StartInfo.WorkingDirectory = _recordingsFolder.FullName;
			proc.StartInfo.Arguments = cmd_args;

			proc.StartInfo.RedirectStandardError = false;
			proc.StartInfo.StandardOutputEncoding = Encoding.Default;
			proc.StartInfo.RedirectStandardOutput = true;
			proc.StartInfo.UseShellExecute = false;

			Console.ForegroundColor = ConsoleColor.Blue;
			proc.Start();
			proc.PriorityClass = ProcessPriorityClass.AboveNormal;
			proc.WaitForExit();
			Console.ResetColor();

			_masterOutputConcatFile =
				new FileInfo(
					String.Format(
						@"{0}\concat.mp3",
						_recordingsFolder.FullName
						));

			_tagger.UnTagMp3(_masterOutputConcatFile.FullName);
		}

		/// <summary>
		/// now we have this little problem that the times are wrong. the times need to be incremented with the 
		/// cumulative times of the previous section rips
		/// </summary>
		/// <param name="relevantTracks"></param>
		private void NudgeTracksForward(IEnumerable<CuesheetTrack> relevantTracks)
		{
			if (_cues.Count() <= 1) return;
			
			Output.Write("Nudging tracks forward...");
		
			TimeSpan previousCost = TimeSpan.Zero;
			Cuesheet previousCuesheet = relevantTracks.First().Cuesheet;

			foreach (CuesheetTrack ct in relevantTracks)
			{
				if (ct.Cuesheet != previousCuesheet)
				{
					previousCost += previousCuesheet.GetMediaLength();

					Output.Write("Nudging tracks >={0} + {1}", 
						ct.AbstractNumber, 
						Cuesheet.TimespanToCueTimeString( previousCost ) );
					
					previousCuesheet = ct.Cuesheet;
				}

				ct.ShiftTimeForwards(previousCost);
			}

			WriteTracksOut();
		}

		private void CallStreamRipper(string url, TimeSpan howlong)
		{
			Output.Write(
				String.Format(@"Calling Streamripper. Recording to {0}\{1}.mp3",
					_recordingsFolder.FullName, _recordingName
					));

			Output.Write(@"calling .\streamripper {0}", GetSrArgs(url, howlong, true));

			Process proc = new Process();
			proc.StartInfo.FileName = Configuration.Default.StreamRipperPath;
			proc.StartInfo.Arguments = GetSrArgs(url, howlong, false);
			proc.StartInfo.RedirectStandardOutput = true;
			proc.StartInfo.UseShellExecute = false;

			proc.Start();
			Console.ForegroundColor = ConsoleColor.Blue;
			proc.PriorityClass = ProcessPriorityClass.AboveNormal;
			
			StringBuilder sr_output = new StringBuilder();

			while (!proc.StandardOutput.EndOfStream)
			{
				string line = proc.StandardOutput.ReadLine();
				string date_line = String.Format( "{1}> {0}", line, DateTime.Now.ToString("HH:mm:ss") );
				sr_output.AppendLine(date_line);

				if (line.Contains("ripping...")) Console.SetCursorPosition(0, Console.CursorTop-1);
				
				Console.WriteLine(date_line);
			} 
			
			Output.Write(@"Writing streamripper log file - check this if the recording fucked up!");
			File.WriteAllText(
				String.Format(@"{0}\streamripper_output.log", _recordingsFolder.FullName),
				sr_output.ToString() );
			
			Console.ResetColor();
		}

		private string GetSrArgs(string url, TimeSpan howlong, bool masked)
		{
			string sr_args = String.Format(@"""{3}"" -r -d ""{0}"" -a ""{1}"" -l {2}  -u ""NSPlayer/8.0.0.4477"" -s -k 0 -A -R 0",
				masked ? "(recordings folder)" : _recordingsFolder.FullName,
				_recordingName,
				howlong.TotalSeconds,
				masked ? "(url)" : url);
			return sr_args;
		}
	}
}
