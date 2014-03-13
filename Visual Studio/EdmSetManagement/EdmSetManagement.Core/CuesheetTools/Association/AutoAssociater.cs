using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EdmSetManagement.Core.Settings;
using System.IO;
using System.Text.RegularExpressions;
using EdmSetManagement.Core.CuesheetTools.Association.Identifiers;
using EdmSetManagement.Core.ConsoleWriter;

namespace EdmSetManagement.Core.CuesheetTools.Association
{
	public class AutoAssociater
	{
		/// <summary>
		///1: get cuesheets in the main cuesheet folder with matching name
		///2: for each one -- try to associate it with an MP3 in our artist folder
		///3: foreach association -- does it already have an associated cuesheet?
		///4: if not -- associate it
		///5: parse source cuesheet and emit in .\Cuesheets with updated path etc
		/// </summary>
		/// <param name="assoc"></param>
		/// <param name="artist"></param>
		/// <param name="cuesheetMatchRegex"></param>
		/// <param name="showId"></param>
		public void Associate( 
			AssociationType assoc, 
			string artist, 
			string cuesheetMatchRegex,
			IShowIdentifier showId ) 
		{
			Regex cuesheetRegex = new Regex( cuesheetMatchRegex, RegexOptions.Singleline | RegexOptions.IgnoreCase );
			DirectoryInfo cuePath = new DirectoryInfo( Configuration.Default.CuesheetPath );
			
			Output.Write( "Getting Artist Folder..." );
			
			DirectoryInfo artistFolder = new DirectoryInfo( Configuration.Default.DjSetPath )
				.GetDirectories()
				.Where(d => d.Name.ToLower() == artist.ToLower() )
				.First();
				
			if( !artistFolder.Exists ) {
				Output.Write("Can't find artist folder. Aborting.");
				return;
			}
				
			DirectoryInfo artistFolderCuePath = 
				new DirectoryInfo( 
					String.Format( @"{0}\Cuesheets", artistFolder.FullName ) );

			Output.Write("Finding Relevant Cuesheets...");
			
			var cues = cuePath
				.GetFiles()
				.OrderByDescending( f=>f.LastWriteTime )
				//.Take(1000)
				.Where( f=>cuesheetRegex.IsMatch(f.Name) )
				//.Take(100)
				.Where( f=>new Cuesheet().ParseInFromFile(f.FullName).IsValidCueSheet() );

			Output.Write( String.Format("\t->Found {0}", cues.Count() ) );
			
			if(!cues.Any()) return;
			
			var artistMp3s = artistFolder
				.GetFiles()
				.Where( f=>f.Name.ToLower().EndsWith(".mp3") );
			
			///for every matching cue -- does it have an mp3 associated in the folder

			Regex dateParse = null;
			DateShowIdentifier di = null;
			NumberShowIdentifier ni = null;
			Regex numberParseRegex = null;
			Regex mustAlso = null;
			Regex mustNot = null;
			
			///chop down the list with the relevant show id patterns
			///when we loop through the cues, we want to assume they are parsable candidates
			if( assoc == AssociationType.DateFormat ) {
				di = (DateShowIdentifier) showId;
				dateParse = new Regex(di.DateParseRegex);
				cues = cues.Where(f => dateParse.IsMatch( f.Name ) );

			}
			else if( assoc == AssociationType.ShowNumber ) {
				ni = (NumberShowIdentifier) showId;
				numberParseRegex = new Regex(ni.NumberParseRegex);
				cues = cues.Where(f => numberParseRegex.IsMatch(f.Name));
			}

			if (showId.MustAlsoMatch != null)
			{
				mustAlso = new Regex(showId.MustAlsoMatch, RegexOptions.Singleline);
				cues = cues.Where(f => mustAlso.IsMatch(f.Name));
			}
			
			if (showId.MustNotMatch != null) {

				mustNot = new Regex(showId.MustNotMatch, RegexOptions.Singleline);
				cues = cues.Where(f => !mustNot.IsMatch(f.Name));
			
			}
			
			bool anyUpdates = false;

			foreach( FileInfo cue in cues ) {
			
				IEnumerable<FileInfo> relevantMp3s = null;
			
				///extract out the unique id from the cue name
				if( assoc == AssociationType.DateFormat ) {
					
					string showIdString = 
						DateTime.Parse(  
							dateParse.Match( cue.Name ).Value 
							).ToString( di.DateFormat );
					
					relevantMp3s = artistMp3s.Where( f=>f.Name.Contains(showIdString) );
				}
				
				else if( assoc == AssociationType.ShowNumber ) {
				
					string showIdentifier = numberParseRegex.Match(cue.Name).Value;
					relevantMp3s = artistMp3s.Where(f => numberParseRegex.IsMatch(f.Name) && numberParseRegex.Match(f.Name).Value == showIdentifier );
				}

				///some secondary matching criteria
				if (showId.MustAlsoMatch != null)
				{
					string secondaryMatch = mustAlso.Match(cue.Name).Value;
					relevantMp3s = relevantMp3s.Where(f => f.Name.Contains(secondaryMatch));
				}
				
				foreach (var mp3 in relevantMp3s)
				{
					string plainName = mp3.Name.Replace(mp3.Extension, String.Empty);
					string cueName = String.Format("{0}.cue", plainName);

					///if we dont have a cuesheet for this MP3 already then...
					if (!artistFolderCuePath.GetFiles().Any(f => f.Name == cueName))
					{
						anyUpdates = true;
					
						Output.Write( String.Format( "Found a fresh MP3/Cue association... ({0})", mp3.Name ));

						///emit the cuesheet in .\Cuesheets with an association back
						Cuesheet cueSheet = new Cuesheet();

						Output.Write("Parsing Cuesheet...");
						cueSheet.ParseInFromFile(cue.FullName);
						cueSheet.MediaPath = mp3.FullName;

						string cueOutputFullName =
							String.Format(@"{0}\{1}",
								artistFolderCuePath.FullName, cueName);

						Output.Write(String.Format("Writing new cuesheet to {0}...", cueOutputFullName));
						cueSheet.WriteOutToFile(cueOutputFullName, true);
						
						///set the dates on the output cue to be same as cuedump

						Output.Write(String.Format("Updating Timestamp: {0}...", cueOutputFullName));
						FileInfo newCue = new FileInfo(cueOutputFullName);
						newCue.LastWriteTime = cue.LastWriteTime;
						newCue.CreationTime = cue.CreationTime;
					}
				}
			}
			if (!anyUpdates) Output.Write("No fresh associations found");
		}
	}
	

}
