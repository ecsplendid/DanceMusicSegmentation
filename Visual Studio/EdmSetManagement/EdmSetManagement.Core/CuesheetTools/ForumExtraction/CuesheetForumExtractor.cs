using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EdmSetManagement.Core.CuesheetTools.Downloading;
using System.Text.RegularExpressions;
using System.Net;
using EdmSetManagement.Core.ConsoleWriter;
using System.Web;
using System.IO;


namespace EdmSetManagement.Core.CuesheetTools.ForumExtraction
{
	public class CuesheetForumExtractor
	{
		StringBuilder _html;
		List<TimeSpan> _properTimes;
		Regex _htmlPattern = new Regex("<[^>]+?>", RegexOptions.Singleline);

		public void ExtractAhForum(string baseurl, string mediapath, string cuepath, int nudge_seconds) 
		{
			Extract( 
				baseurl,
				@"open content container .+?/ message",
				@"\.html$",
				"-{0}.html",
				@"(?<=^)\d{2}(?=[\.:])",	
				@"^\d{2}[\.:][^<$\n\r]+",
				@"\d{2}-\d{2}-\d{4}, \d{2}:\d{2} (AM|PM)",
				@"\d{2}[\.:]\s?(?<artist>.+?)\s?-\s?(?<title>.+)\s?",
				mediapath,
				cuepath,
				nudge_seconds
				);
		}

		/// <summary>
		/// Generate a cuesheet from a forum thread about a liveset
		/// </summary>
		/// <param name="baseurl">http://forum.ah.fm/livesets-ah-fm/19235-20-08-2009-markus-schulz-presents-gdjb-super-8-tab-guestmix.html</param>
		/// <param name="message">open content container .+?/ message</param>
		/// <param name="replacewhat">\.html$</param>
		/// <param name="replacewith">-{0}.html</param>
		/// <param name="tracknumber">(?<=^)\d{2}(?=\.)</param>
		/// <param name="trackmatch">^\d{2}\.[^<$\n\r]+</param>
		/// <param name="datematch">\d{2}-\d{2}-\d{4}, \d{2}:\d{2} (AM|PM)</param>
		public void Extract(
			string baseurl,
			string message,
			string replacewhat, 
			string replacewith,
			string tracknumber, 
			string trackmatch, 
			string datematch,
			string tracksplit_pattern,
			string mediapath,
			string cuepath,
			int nudge_seconds ) 
		{
			DownloadHtml(baseurl, replacewhat, replacewith);

			///now split the content into individual messages

			Regex trackPattern = new Regex(trackmatch, RegexOptions.IgnoreCase | RegexOptions.Multiline );
			Regex trackNumber = new Regex(tracknumber, RegexOptions.IgnoreCase | RegexOptions.Multiline);
			Regex datematchPattern = new Regex(datematch, RegexOptions.IgnoreCase | RegexOptions.Multiline );
			Regex trackDatePattern =
				new Regex(
					String.Format("({0})|({1})", trackmatch, datematch),
					RegexOptions.Multiline | RegexOptions.IgnoreCase);

			Regex messagePattern = new Regex(message, RegexOptions.Singleline);
			var messages = messagePattern
				.Matches(_html.ToString())
				.OfType<Match>()
				.Select(m => FixNumbering(m.Value, trackNumber))
				.Select(s => RemoveHtml(s) )
				.ToArray();

			string finalHtml = String.Join(",", messages);

			int num = 0;
			var matches = trackDatePattern
				.Matches(finalHtml)
				.OfType<Match>()
				.Select( m=>new { Text=m.Value, Number=num++ } )
				.ToList();
			
			var times = 
				matches
					.Where( m=>datematchPattern.IsMatch( m.Text ) )
					.Select( m=>new { Date=DateTime.Parse(m.Text), Number=m.Number } );
			
			///now we have everything we need to know
			///the time metadata for WHEN the track starts, and the last occurance for the most accurate name
			
			var tracks = 
				matches
					.Where( m=>trackNumber.IsMatch( m.Text ) )
					.Select( m => new { TrackNo=Convert.ToInt32( trackNumber.Match( m.Text ).Value ), Text=m.Text, AbstractNumber=m.Number } );

			///heuristic here is that we go from the start of the hour of the first match 
			///sometimes these threads were started days before. cute or what :)
			var firstTime = 
					times.Where(
						t => t.Number < tracks.First().AbstractNumber
						).Last().Date;

			_properTimes = times
				.Select( t => t.Date - firstTime)
				.ToList();
			
			///reset back to the hour (shows always start on the hour)
			///firstTime = new DateTime(firstTime.Year, firstTime.Month, firstTime.Day, firstTime.Hour, 0, 0);
					
			List<TempTrack> finalList = 
				tracks
					.DistinctBy( m=>m.TrackNo  )
					.OrderBy( m=>m.TrackNo )
					.Select(m => new TempTrack
									{
									///heuristic -- take the time at the first occurance
									TimeSpan = 
											times
												.Where(t => t.Number < m.AbstractNumber)
												.Last()
												.Date - firstTime + new TimeSpan(0,0,30 + nudge_seconds),
									///heuristic -- take the most common instance i.e. re-enforcement strategy
									Title = tracks
										.Where(t => t.TrackNo == m.TrackNo)
										.GroupBy( f=>f.Text )
										.OrderBy( g=>g.Count() )
										.Last()
										.Key
									} )
					.ToList();

			Regex tracksplit = new Regex( tracksplit_pattern, RegexOptions.Singleline | RegexOptions.IgnoreCase );
			
			///if we have nudges time backwards, we get negatives. So the first one we may want to keep
			if( finalList.Any( t=>t.TimeSpan.TotalMilliseconds < 0 ) ) {
				finalList.Last(t => t.TimeSpan.TotalMilliseconds < 0).TimeSpan = new TimeSpan(0,0,0);
			}
			
			int tno = 1;
			var cueTracks = 
				finalList
				.Where( t=>t.TimeSpan.TotalMilliseconds >= 0 )
				.Select( m=>
					new CuesheetTrack {
						Artist = HttpUtility.HtmlDecode(tracksplit.Match(m.Title).Groups["artist"].Value.Trim() ),
						TrackTitle = HttpUtility.HtmlDecode(tracksplit.Match(m.Title).Groups["title"].Value.Trim() ),
						Position = m.TimeSpan,
						Number = tno++ } )
						.ToList();
						
			foreach(CuesheetTrack cst in cueTracks ) {
			
				if( cst.Artist == String.Empty )
					cst.Artist = "ID";

				if (cst.TrackTitle == String.Empty)
					cst.TrackTitle = "ID";
			
			}
			
			
			Cuesheet cs = new Cuesheet();
			cs.MediaPath=mediapath;
			cs.Tracks = cueTracks;
			cs.WriteOutToFile(cuepath, false);


			Console.ForegroundColor = ConsoleColor.Yellow;
			cueTracks.ForEach( t=>Output.Write("[{0}] {1}",t.Position, t.GetFullTitle() ));
			Console.ResetColor();
		
			Output.Write("Cuesheet written to {0}", cuepath);
		}

		private string RemoveHtml(string s)
		{
			return _htmlPattern.Replace(s,String.Empty);
		}

		private string FixNumbering(string s, Regex number)
		{
			int num = 1;
			return number.Replace( s, m=> String.Format( "{0:00}", num++ )  );
		}

		private void DownloadHtml( string baseurl, string replacewhat, string replacewith )
		{
			Console.ForegroundColor = ConsoleColor.Green;
			_html = new StringBuilder();

			UseragentGenerator ug = new UseragentGenerator();
			Regex replacewhatPattern = new Regex(replacewhat, RegexOptions.Singleline | RegexOptions.IgnoreCase);
			Regex referrerPattern = new Regex("http://[^/]+?/");
			string referrer = referrerPattern.Match(baseurl).Value;

			Output.Write("Downloading {0}...", baseurl);

			WebDownloader.WebDownloaderResult result =
				WebDownloader.DownloadUrlVerbose(
					baseurl,
					referrer,
					ug.GiveMeOne(),
					true,
					false
					);

			_html.Append(result.html);

			int page = 2;

			while (result.Code == HttpStatusCode.OK  )
			{
				string pageurl = replacewhatPattern.Replace(baseurl, String.Format(replacewith, page++));
				Output.Write("Downloading {0}...", pageurl);
				
				result =
					WebDownloader.DownloadUrlVerbose(
						pageurl,
						referrer,
						ug.GiveMeOne(),
						false,
						false
						);

				_html.Append(result.html);
			}
			
			Console.ResetColor();
		}
	}
}




