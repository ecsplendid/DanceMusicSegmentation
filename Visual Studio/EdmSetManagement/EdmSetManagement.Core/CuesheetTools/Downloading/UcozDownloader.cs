using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EdmSetManagement.Core.ConsoleWriter;
using System.Xml.Linq;
using System.IO;
using EdmSetManagement.Core.Settings;
using System.Text.RegularExpressions;
using System.Net;

namespace EdmSetManagement.Core.CuesheetTools.Downloading
{
	public class UcozDownloader
	{
		Regex _notAllowChars = new Regex(@"[\\/:\*\?""\<\>\|]");
		
		public void DownloadLatestCues() {

			UseragentGenerator uag = new UseragentGenerator();
			string referrer = "http://cues.ucoz.ru/news/";

			Output.Write("Downloading http://cues.ucoz.ru/news/rss/");
			
			XDocument doc =
				XDocument.Parse(
					WebDownloader.DownloadUrlVerbose("http://cues.ucoz.ru/news/rss/", referrer, uag.GiveMeOne(), false, false).html
					);
					
			DirectoryInfo cuePath = new DirectoryInfo( Configuration.Default.CuesheetPath);

			/// get all the titles that don't have a cuesheet sitting locally
			var newcues = doc.Descendants("item")
				.Where(el =>
					!File.Exists(
						String.Format(@"{0}\{1}.cue", cuePath.FullName,
							_notAllowChars.Replace( el.Element("title").Value, String.Empty ) )
						))
				.Select(el => new { Guid = el.Element("guid").Value, Title = _notAllowChars.Replace(el.Element("title").Value, String.Empty) })
				.ToList();
				
			Regex cueLink = new Regex(@"(?<="")[^""]+?\.cue", RegexOptions.Singleline );

			if (newcues.Any())
				Output.Write("There are {0} new cuesheets to download from UCoz!", newcues.Count());
			else Output.Write("Can't find any fresh cuesheets.");

			///print them to screen
			Console.ForegroundColor = ConsoleColor.Green;
			newcues.ToList().ForEach(c => Output.Write("\t->{0}", c.Title));
			Console.ResetColor();
			
			foreach( var cue in newcues ) {

				string html = WebDownloader.DownloadUrlVerbose(cue.Guid, referrer, uag.GiveMeOne(), false, false).html;
				
				if( cueLink.IsMatch( html ) ) {

					string link = cueLink.Match(html).Value;
					
					if(!link.StartsWith("http:")) ///relative?
						link = String.Format("http://cues.ucoz.ru/{0}", link);
					
					Output.Write("Found link: {0}", link);

					string cueText = null;
					
					try {
						cueText = WebDownloader.DownloadUrlVerbose(link, referrer, uag.GiveMeOne(), false, false).html;
					}
					
					catch( WebException ) {
						/// we probably got a 404, so we skip this cue
						/// they might put a link up but forget to put the cue there!

						Output.Write("{0} is 404! Skipping...", cue.Title);
					
						continue;
					}
					
					Output.Write("Writing: {0}.cue", cue.Title);

					File.WriteAllText(
						String.Format(@"{0}\{1}.cue", cuePath.FullName, cue.Title),
						cueText, Encoding.Default
						);
				}
			}
			
			Output.Write("Done");
		}
	}
}
