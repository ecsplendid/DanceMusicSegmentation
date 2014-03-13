using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using EdmSetManagement.Core.CuesheetTools.Association;
using EdmSetManagement.Core.CuesheetTools.Association.Identifiers;
using EdmSetManagement.Core.CuesheetTools.Chopping;
using EdmSetManagement.Core.Recording;
using EdmSetManagement.Core.CuesheetTools.Downloading;
using EdmSetManagement.Core.CuesheetTools.Searching;
using EdmSetManagement.Core.ConsoleWriter;
using System.IO;
using EdmSetManagement.Core.Settings;
using EdmSetManagement.Core.CuesheetTools.ForumExtraction;
using EdmSetManagement.Core.CuesheetTools;
using EdmSetManagement.Core.CuesheetTools.TimeExtractor;
using EdmSetManagement.Core.Mp3Meta;
using System.Text.RegularExpressions;
using System.Diagnostics;

namespace EdmSetManagement.ConsoleApplication
{
	class Program
	{
		static void Main(string[] args)
		{
			//  args = new string[] { "--showextract", @"F:\MP3\!DJMixes\Markus Schulz\Recordings\job_2807_070000" };


#if(DEBUG)
			//Console.WriteLine("DEBUG MODE -- ERRORS WILL WON'T BE LOGGED");

			RunAllRoutines(args);
#else
            Console.WriteLine("PRODUCTION MODE -- ERRORS WILL BE LOGGED");

			RunAllRoutinesCatchException(args);
#endif
		}

		/// <summary>
		/// recursively set all modiofied dates on folders and files to be the creation date 
		/// useful if you just copied a directory somewhere else and your dates got fried
		/// </summary>
		private static void ResetDatesOnDirectory(string dir)
		{
			Console.WriteLine(dir);

			DirectoryInfo d = new DirectoryInfo(dir);

			d.GetFiles().ToList().ForEach(f => f.LastWriteTime = f.CreationTime);
			d.GetDirectories().ToList().ForEach(di => { di.LastWriteTime = di.CreationTime; ResetDatesOnDirectory(di.FullName); });

		}

		private static void RunAllRoutinesCatchException(string[] args)
		{
			try
			{
				RunAllRoutines(args);
			}

			catch ( Exception ex )
			{
				string path =
					String.Format(
						@"{0}\!Exceptions\exp_{1}.log",
						Configuration.Default.DjSetPath,
						DateTime.Now.ToString("yyyyMMdd@HHmm")
						);

				FileInfo f = new FileInfo(path);
				if ( !f.Directory.Exists ) f.Directory.Create();

				File.WriteAllText(path, ex.ToString());

				Console.ForegroundColor = ConsoleColor.Red;
				Console.WriteLine(ex.ToString());
				Console.ResetColor();
			}

			finally
			{
				Console.ResetColor();
				Console.ForegroundColor = ConsoleColor.White;

				string path =
					String.Format(
						@"{0}\!Exceptions\log_{1}.log",
						Configuration.Default.DjSetPath,
						DateTime.Now.ToString("yyyyMMdd@HHmm")
						);

				//Output.DumpLog(path);
			}
		}

		private static void RunAllRoutines(string[] args)
		{
			DefaultInformation(args);
			ExtractCueTimes(args);
			CreateCueIndexFiles(args);
			ExtractCuePath(args);
			AutoChopLatest(args);
			HourSplitShows(args);
			CueSyncAll(args);
			CleanCuesheets(args);
			ShowRecorder(args);
			GetCues(args);
			CueSearchPlay(args);
			CueSearchAll(args);
			CueFinder(args);
			CuesheetForumExtract(args);
			ShowExtractor(args);
			DoEverything(args);
			AutoChopCuesheet(args);
			CreateCueIndexSecondsFiles(args);
		}

		private static void CreateCueIndexSecondsFiles(string[] args)
		{
			string directoryPath = ".";

			directoryPath = @"C:\Users\tim_000\Google Drive\Dennis Music Dataset\Magic Island - Music for Balearic People";

			if ( true || args.Any() && args.First() == "--createindexesseconds" )
			{
				foreach ( var f in new DirectoryInfo(directoryPath)
					.GetFiles()
					.Where(f => f.Extension.ToLower() == ".cue")
					

					
					)
				{
					Cuesheet c = new Cuesheet()
						   .ParseInFromFile(f.FullName);

					/// assume that the media path in the cue sheet is actually 
					/// just a file name
					string physicalMediaPath =
						   string.Format("{0}\\{1}", directoryPath, c.PhysicalMediaPath);

					Debug.Assert( 
						!Regex.IsMatch( c.PhysicalMediaPath, @"\\|:", RegexOptions.Singleline ), 
							"We expect the media path in the cue sheet just to be a file name and have no / : in it." );

					if ( !File.Exists(physicalMediaPath) )
						continue;

					string outputSecondsFilePath = f.Name.Replace(".cue", ".ind.txt");
					string outputChopsFilePath = f.Name.Replace(".cue", ".chops.txt");
					string outputChopsDescFilePath = f.Name.Replace(".cue", ".chopsdesc.txt");

					Console.WriteLine("Writing... {0}", c.PhysicalMediaPath);

					Mp3Sizer mps = new Mp3Sizer();

					int secs = (int)mps.GetSizeOfMp3File(physicalMediaPath).TotalSeconds;

					var res = CueTimeExtractor.GetFactorTimes(f.FullName, secs, prune: true);

					string filecont = String.Join("\r\n",
						res.FactorSeconds
						.Where( i=>i>0 ) /// goes without saying we start from 0, remove it
						.Select(d => Convert.ToString(d)).ToArray());

					File.WriteAllText(String.Format(@"{0}\{1}", directoryPath, outputSecondsFilePath), filecont);

					File.WriteAllText(String.Format(@"{0}\{1}", directoryPath, outputChopsDescFilePath), String.Join("\r\n",
						res.FactorTimesDescriptions
						.Select(s => s).ToArray()));
					
					
					
					string chopsPhysicalPath = String.Format(@"{0}\{1}", directoryPath, outputChopsFilePath);

					/// delete the old chops file if it exists
					if ( File.Exists(chopsPhysicalPath) )
					{
						File.Delete(chopsPhysicalPath);
					}

					/// write out the chops
					foreach( CueTimeExtractorChop chop in res.Chops )
					{
						File.AppendAllText(
							chopsPhysicalPath, 
							String.Format("{0}	{1}\r\n", chop.From, chop.To)
							);
					}

					/// what if chop file empty
					if ( !res.Chops.Any() )
					{
						File.AppendAllText(
							   chopsPhysicalPath,
							   "0	0"
							   );

					}

					Console.WriteLine(outputSecondsFilePath);
				}
			}
		}

		private static void CreateCueIndexFiles(string[] args)
		{
			if ( args.Any() && args.First() == "--createindexes" )
			{
				foreach ( var f in new DirectoryInfo(".")
						.GetFiles()
						.Where(f => f.Extension.ToLower() == ".cue")
						.Select(f => new { C = new Cuesheet().ParseInFromFile(f.FullName), F = f })
						.Where(f => File.Exists(f.C.PhysicalMediaPath)) )
				{

					Cuesheet c = new Cuesheet();
					c.ParseInFromFile(f.F.FullName);

					string path = c.PhysicalMediaPath.Replace(".mp3", ".ind.txt");

					Console.WriteLine("Writing... {0}", c.PhysicalMediaPath);

					Mp3Sizer mps = new Mp3Sizer();

					int secs = (int)mps.GetSizeOfMp3File(c.PhysicalMediaPath).TotalSeconds;

					string filecont = String.Join("\r\n",
						CueTimeExtractor
						.GetFactorTimes(f.F.FullName, secs, true).FactorTimes
						.Select(d => Convert.ToString(d)).ToArray());

					File.WriteAllText(path, filecont);

				}
			}
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="args"></param>
		private static void ExtractCueTimes(string[] args)
		{
			if ( args.Any() && args.First() == "--extractcuetimes" )
			{
				string path = args[1];
				int seconds = Convert.ToInt32(args[2]);

				foreach ( double d in CueTimeExtractor.GetFactorTimes(path, seconds, true).FactorTimes )
				{
					Console.WriteLine(d);

				}
			}

		}

		private static void ExtractCuePath(string[] args)
		{
			if ( args.Any() && args.First() == "--extractcuepath" )
			{
				string path = args[1];


				Cuesheet c = new Cuesheet();
				c.ParseInFromFile(path);
				Console.WriteLine(c.PhysicalMediaPath);
			}

		}


		private static void CuesheetForumExtract(string[] args)
		{
			if ( args.Length == 5 && args.First() == "--extract_ahcue" )
			{
				CuesheetForumExtractor ce = new CuesheetForumExtractor();

				ce.ExtractAhForum(args[1], args[2], args[3], Convert.ToInt32(args[4]));
			}
		}



		private static void CueFinder(string[] args)
		{
			if ( args.Length > 0 && args.First() == "--findcue" )
			{
				CueSearcher cs = new CueSearcher();
				cs.Search(args.Length > 1 ? args[1] : String.Empty);
			}
		}

		private static void CueSearchPlay(string[] args)
		{
			if ( args.Length > 1 && args.First() == "--search" )
			{
				CueTrackSearcher cs = new CueTrackSearcher();
				cs.Search(args[1], args.Length > 2 ? true : false, false);
			}
		}

		private static void CueSearchAll(string[] args)
		{
			if ( args.Length > 1 && args.First() == "--searchall" )
			{
				CueTrackSearcher cs = new CueTrackSearcher();
				cs.Search(args[1], false, true);
			}
		}

		private static void DoEverything(string[] args)
		{
			if ( args.Length > 0 && args.First() == "--doeverything" )
			{
				CueNationDownloader cs = new CueNationDownloader();
				cs.DownloadLatestCues();

				UcozDownloader uc = new UcozDownloader();
				uc.DownloadLatestCues();

				HourSplitShowsImplementation();
				CueSyncAllImplementation();

				ChoppyTag ct = new ChoppyTag();
				ct.CleanUpCuesheets();
				ct.AutoChopLatestSets();
			}
		}

		private static void GetCues(string[] args)
		{
			if ( args.Length > 0 && args.First() == "--getlatestcues" )
			{
				CueNationDownloader cs = new CueNationDownloader();
				cs.DownloadLatestCues();

				UcozDownloader uc = new UcozDownloader();
				uc.DownloadLatestCues();
			}
		}

		private static void ShowExtractor(string[] args)
		{
			if ( args.Length > 0 && args.First() == "--showextract" && args.Length >= 2 )
			{
				ShowRecorder sr = new ShowRecorder();
				sr.RecordGeneric(
					"di_trance",
					new DirectoryInfo(args[1]).Parent.Parent.Name,
					100,
					args.Length > 2 ? args[2] : null,
					args[1]);
			}
		}

		private static void ShowRecorder(string[] args)
		{
			if ( args.Length > 0 && args.First() == "--recordshow" && args.Length >= 3 )
			{
				ShowRecorder sr = new ShowRecorder();
				sr.RecordGeneric(
					args[1],
					args[2],
					Convert.ToInt32(args[3]),
					args.Length > 4 ? args[4] : null,
					args.Length > 5 ? args[5] : null);
			}
		}

		/// <summary>
		/// auto associate cues from the cuesheet main dump folder and our sets
		/// </summary>
		/// <param name="args"></param>
		private static void CueSyncAll(string[] args)
		{
			if ( args.Length > 0 && args.First() == "--cuesync_all" )
			{
				CueSyncAllImplementation();
			}
		}

		private static void CueSyncAllImplementation()
		{
			AutoAssociater auto_assoc = new AutoAssociater();

			Output.Write("\r\nAuto cue-associating Corstens Countdown!", "");

			auto_assoc.Associate(
				AssociationType.ShowNumber,
				"Ferry Corsten",
				"Corsten.+?Countdown",
				new NumberShowIdentifier
				{
					NumberParseRegex = @"\d{3}\s"
				});

			Output.Write("\r\nAuto cue-associating Aly & Fila!");

			auto_assoc.Associate(
				AssociationType.ShowNumber,
				@"Aly & Fila",
				"Future Sound of Egypt",
				new NumberShowIdentifier
				{
					NumberParseRegex = @"\d{3}\s"
				});

			Output.Write("\r\nAuto cue-associating Global DJ Broadcast!");

			auto_assoc.Associate(
				AssociationType.DateFormat,
				"Markus Schulz",
				"Global DJ Broadcast",
				new DateShowIdentifier
				{
					DateFormat = @"d MMMM yyyy",
					DateParseRegex = @"\d{4}-\d{2}-\d{2}"
				});

			Output.Write("\r\nAuto cue-associating A State Of Trance!");

			auto_assoc.Associate(
				AssociationType.ShowNumber,
				"Armin Van Buuren",
				"A State of Trance",
				new NumberShowIdentifier
				{
					NumberParseRegex = @"\s\d{3}"
				});

			Output.Write("\r\nAuto cue-associating Trance Around The World!");

			auto_assoc.Associate(
				AssociationType.ShowNumber,
				@"Above & Beyond",
				"Trance Around The World",
				new NumberShowIdentifier
				{
					NumberParseRegex = @"\d{3}\s"
				});

			Output.Write("\r\nAuto cue-associating Tone Diary!");

			auto_assoc.Associate(
				AssociationType.ShowNumber,
				"Marcus Schossow",
				"Tone Diary",
				new NumberShowIdentifier
				{
					NumberParseRegex = @"\s\d{2,3}\s"
				});

			Output.Write("\r\nAuto cue-associating Roger Shah!");

			auto_assoc.Associate(
				AssociationType.ShowNumber,
				"Roger Shah",
				"Music for Balearic People",
				new NumberShowIdentifier
				{
					NumberParseRegex = @"\s\d{3}"
				});

			Output.Write("\r\nAuto cue-associating Sander Van Doorn!");

			auto_assoc.Associate(
				AssociationType.DateFormat,
				"Sander Van Doorn",
				"Sander van Doorn.+?Identity",
				new DateShowIdentifier
				{
					DateFormat = @"d MMMM yyyy",
					DateParseRegex = @"\d{4}-\d{2}-\d{2}"
				});

			Output.Write("\r\nAuto cue-associating Tiesto!");

			auto_assoc.Associate(
				AssociationType.ShowNumber,
				"Tiesto",
				"Club Life",
				new NumberShowIdentifier
				{
					NumberParseRegex = @"\s\d{3}"
				});

			Output.Write("\r\nAuto cue-associating Nocturnal!");

			Output.Write("Hour 1s");

			auto_assoc.Associate(
				AssociationType.DateFormat,
				"Matt Darey",
				"Matt Darey.+?Nocturnal",
				new DateShowIdentifier
				{
					DateFormat = @"yyyy-MM-dd",
					DateParseRegex = @"\d{4}-\d{2}-\d{2}",
					MustAlsoMatch = @"Hour 1" ///the cue, not the mp3
				});

			Output.Write("Hour 2s");

			auto_assoc.Associate(
				AssociationType.DateFormat,
				"Matt Darey",
				"Matt Darey.+?Nocturnal",
				new DateShowIdentifier
				{
					DateFormat = @"yyyy-MM-dd",
					DateParseRegex = @"\d{4}-\d{2}-\d{2}",
					MustAlsoMatch = @"Hour 2" ///the cue, not the mp3
				});


			Output.Write("Entire show (if available)");
			///WANT: Matt Darey - Nocturnal 210 (2009-08-15) (including Jose Amnesia Guestmix) [iRUSH]
			///WANT: Matt Darey presents Nocturnal (15 August 2009)
			///DONT WANT: Matt Darey - Nocturnal 207 (2009-07-25) (Hour 1) (TALiON)

			auto_assoc.Associate(
				AssociationType.DateFormat,
				"Matt Darey",
				"Matt Darey.+?Nocturnal",
				new DateShowIdentifier
				{
					DateFormat = @"d MMMM yyyy",
					DateParseRegex = @"\d{4}-\d{2}-\d{2}",
					MustNotMatch = @"Hour \d" ///the cue, not the mp3
				});

			Output.Write("\r\nAuto cue-associating Sied van Riel!");

			auto_assoc.Associate(
				AssociationType.ShowNumber,
				"Sied van Riel",
				"Rielalistic|Rielastic", ///people on ucoz got spelling wrong lol
				new NumberShowIdentifier
				{
					NumberParseRegex = @"\s\d{3}[^\d]"
				});

		}

		/// <summary>
		/// split our 2 hour renditions of nocturnal into 1 hour chunks 
		/// as matched with relevant cuesheets
		/// </summary>
		/// <param name="args"></param>
		private static void HourSplitShows(string[] args)
		{
			if ( args.Length > 0 && args.First() == "--hoursplit_shows" )
			{
				HourSplitShowsImplementation();
			}
		}

		private static void HourSplitShowsImplementation()
		{
			Output.Write("\r\nSplitting Nocturnal Show into hourly chunks!");

			HourSplitter hs = new HourSplitter();
			hs.Split(
					AssociationType.DateFormat,
					"Matt Darey",
					"Matt Darey.+?Nocturnal",
					new DateShowIdentifier
					{
						DateFormat = @"d MMMM yyyy",
						DateParseRegex = @"\d{4}-\d{2}-\d{2}",
						MustAlsoMatch = @"Hour 1"
					});

			hs.Split(
					AssociationType.DateFormat,
					"Matt Darey",
					"Matt Darey.+?Nocturnal",
					new DateShowIdentifier
					{
						DateFormat = @"d MMMM yyyy",
						DateParseRegex = @"\d{4}-\d{2}-\d{2}",
						MustAlsoMatch = @"Hour 2"
					});


		}

		/// <summary>
		/// look at recent cue sheets associated with sets and chop them up 
		/// into chop folder
		/// </summary>
		/// <param name="args"></param>
		private static void AutoChopLatest(string[] args)
		{
			if ( args.Length > 0 && args.First() == "--auto_chop_latest" )
			{
				ChoppyTag ct = new ChoppyTag();
				ct.AutoChopLatestSets();
			}
		}
		private static void AutoChopCuesheet(string[] args)
		{
			if ( args.Length > 0 && args.First() == "--auto_chop_cuesheet" )
			{
				ChoppyTag ct = new ChoppyTag();

				if ( args.Length > 2 ) ct.AutoChopCuesheet(args[2], args[1]);
				else ct.AutoChopCuesheet(args[1]);
			}
		}


		/// <summary>
		/// look at recent cue sheets associated with sets and chop them up 
		/// into chop folder
		/// </summary>
		/// <param name="args"></param>
		private static void CleanCuesheets(string[] args)
		{
			if ( args.Length > 0 && args.First() == "--clean_cues" )
			{
				ChoppyTag ct = new ChoppyTag();
				ct.CleanUpCuesheets();
			}
		}

		private static void DefaultInformation(string[] args)
		{
			if ( args.Length != 0 ) return;

			Assembly execAssembly = Assembly.GetCallingAssembly();
			AssemblyName name = execAssembly.GetName();

			Console.WriteLine(String.Format("Version {0}.{1}.{2}",
						name.Version.Major.ToString(),
						name.Version.Minor.ToString(), name.Version.MinorRevision));

			Console.Write(@"
Welcome to the Edm Set Management Console Application Tim Scarfe (c) 2010

[Searching]
--findcue <what>	Search the cuedump for matching cue sheets (regex)
--search <what> play?	Search for something (regex) in cue records eg. --search ""armin"" true play will extract and play results in !SearchResults
--searchall			Search all the cue sheets (regex) -- even the ones in the cue dump

[Cuesheets]
--doeverything		Calls getlatestcues, clean_cues, hoursplit_shows, cuesync_all
--getlatestcues		Download the latest cuesheets from providers, dump them in cuesheets folder
--auto_chop_cuesheet <cuesheet> <mp3file> chop up the cuesheet into the chop folder + tags everything etc
--auto_chop_latest	Chop all the latest cues into the chop folder (they must be associated and valid)
--clean_cues		Goes through all artist cues in artist\cuesheet. Delete any invalid, or nonassoc. Rewrite out fresh.
--cuesync_all		To Auto Cuesheet Associate Everything
--hoursplit_shows	Split our 2 hour Nocturnal/Tiesto etc recording into 1 hour chunks, because cuesheets are Hour1/Hour2...
--extract_ahcue <forumurl> <mediapath> <cuepath> <nudgeallseconds>	Goto After hours forum base URL and extract a cuesheet based on ""community intelligence""

[Recording]
--recordshow		*[url|alias] *artist *minutes extraction_pattern (*=mandatory)
			Record a show from a URL.
			example: .\edmm --recordshow di_trance ""Armin Van Buuren"" 125 ""A State Of Trance""
--showextract		*recording_path extraction_pattern	joins the recording together, optionally extract a target show to the artist folder
			Example: .\edmm --showextract ""F:\MP3\!DJMixes\DI.FM Canvassing\Recordings\job_2008_020436"" ""Alex Rubio""

[TOOLS]
--extractcuetimes <cue> <totalseconds> extract track times as a factor of completion on the [0,1] interval
--extractcuepath <cue> get cue media path
--createindexes for-each cues in current folder, dump a .ind file with indexes adjacent to linked media file in cuesheet
");
		}
	}
}
