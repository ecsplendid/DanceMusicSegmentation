using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
using EdmSetManagement.Core.ConsoleWriter;
using System.Xml.Linq;
using EdmSetManagement.Core.Settings;
using System.Text.RegularExpressions;

namespace EdmSetManagement.Core.CuesheetTools.Downloading
{
	public class CueNationDownloader
	{
		Regex _notAllowChars = new Regex(@"[\\/:\*\?""\<\>\|]");
	
		/// <summary>
		/// 1: get http://lindmik.sjoholm.dk/cues/feed.php
		/// 2: download any cues that we don't already have
		/// erm simple :)
		/// </summary>
		public void DownloadLatestCues() {

			UseragentGenerator uag = new UseragentGenerator();
			string referrer = "http://cuenation.com/cues/?page=tracklist&folder=anjunabeats&filename=...";

			Output.Write("Downloading http://cuenation.com/feed.php");
			XDocument doc = 
				XDocument.Parse(
					WebDownloader.DownloadUrl("http://cuenation.com/feed.php", referrer, uag.GiveMeOne()) 
					);

			DirectoryInfo cuePath = new DirectoryInfo(Configuration.Default.CuesheetPath);
			
			string d_template = "http://cuenation.com/cues/download.php?type=cue&folder={0}&filename={1}";
			
			/// get all the titles that don't have a cuesheet sitting locally
			var newcues = doc.Descendants("item")
				.Where( el => 
					!File.Exists(
						String.Format(@"{0}\{1}.cue", cuePath.FullName, _notAllowChars.Replace( el.Element("title").Value, String.Empty ) ) 
						) )
				.Select(el => new { Guid = el.Element("guid").Value, Title = _notAllowChars.Replace(el.Element("title").Value, String.Empty) })
				.ToList();
				
			if(newcues.Any())
				Output.Write("There are {0} new cuesheets to download from Cuesite!", newcues.Count());
			else Output.Write("Can't find any fresh cuesheets.");
			
			///print them to screen
			Console.ForegroundColor = ConsoleColor.Green;
			newcues.ToList().ForEach( c=>Output.Write("\t->{0}", c.Title ) );	
			Console.ResetColor();
			
			var withUrls = newcues.Select( s => 
				new { 
					Url=String.Format( d_template, s.Guid.Split('/')[0], s.Guid.Split('/')[1] ), 
					Guid=s.Guid, 
					Title=s.Title } );
				
			foreach( var cuesheet in withUrls ) {

				string path = String.Format(@"{0}\{1}.cue", cuePath.FullName, cuesheet.Title );

				Output.Write("Writing {0}.cue", cuesheet.Title);

				///he messed up his feed, he will probably correct this in the near future so 
				///might not be needed for long (04/12/2009)
				string url = cuesheet.Url.Replace("/cues/", "/");

				Console.WriteLine(url);

				File.WriteAllText(
					path, 
					WebDownloader.DownloadUrlVerbose(
						url, 
						referrer, 
						uag.GiveMeOne(),
						false,
						true
						).html, Encoding.Default );
			}
			
			Output.Write("Done");
		}

		///download link
		///http://lindmik.sjoholm.dk/cues/download.php?type=cue&folder=anjunabeats&filename=01-Oliver_Smith_-_Anjunabeats_Worldwide_136.cue
		//<rss version="2.0"> 
		//  <channel> 
		//    <title>Cuesite V1 | Newest Cuesheets</title> 
		//    <link>http://lindmik.sjoholm.dk/cues/</link> 
		//    <language>en-us</language> 
		//    <pubDate>Tue, 18 Aug 2009 21:15:16 +0000</pubDate> 
		//    <item> 
		//      <title>Agnelli &amp; Nelson - Solaris International 172 (2009-08-17) (including Vadim Zhukov Guestmix) [Podcast]</title> 
		//      <link>http://lindmik.sjoholm.dk/cues/?page=tracklist&amp;folder=solaris&amp;filename=01+Solaris+International+__+Episode+172.cue</link> 
		//      <category>Solaris International</category> 
		//      <guid>solaris/01 Solaris International __ Episode 172.cue</guid> 
		//      <pubDate>Tue, 18 Aug 2009 21:15:16 +0000</pubDate> 
		//      <description><![CDATA[

	}
}
