using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace CuesheetStatistics
{
	class Program
	{
		/// <summary>
		/// @trs 16/06/2014
		/// some basic analysis on how much different humans disagree with each other
		/// based on the dump of cuesheets we got from lindmik
		/// </summary>
		/// <param name="args"></param>
		static void Main(string[] args)
		{
			string asot_file = "asoterror.txt";
			string asot_showhistogram = "asot_showhistogram.txt";

			if ( File.Exists(asot_file) ) File.Delete(asot_file);
			if ( File.Exists(asot_showhistogram) ) File.Delete(asot_showhistogram);

			Console.WindowWidth = 170;

			string cue_path = @"../../asot";

			Regex is_relevantshow = new Regex(
					@"[_\- ](?<showcode>\d{3})[\(._\- ]");

			var relevant = new DirectoryInfo(cue_path)
				.GetFiles()
				.Where(f => is_relevantshow.IsMatch(f.Name))
				.Select( f => 
						new { File = f, Code = is_relevantshow
							.Match( f.FullName )
							.Groups["showcode"].Value } );

			var unique_codes = relevant
					.Select( r => r.Code )
					.Distinct();

			Regex cue_time = new Regex(
				@"(?<minutes>\d{2,3}):(?<seconds>\d{2}):\d{2}", 
				RegexOptions.Singleline);

			foreach ( var c in unique_codes )
			{
				/// find all the shows with that code, if there are more than 1
				var shows = relevant.Where(r => r.Code == c).ToList();

				if( shows.Count() > 1 )
				{
					/// data structure (jagged array) where we store the times, might not be a matrix
					/// because for all we know they have different number of tracks
					List<int[]> time_matrix = new List<int[]>(shows.Count());

					for ( int x = 0; x < shows.Count(); x++ )
					{
						var times = cue_time
							.Matches( File.ReadAllText(shows[x].File.FullName) )
							.OfType<Match>()
							.Select( m => ( Convert.ToInt32(m.Groups["minutes"].Value) * 60 ) +
											Convert.ToInt32(m.Groups["seconds"].Value ) )
							.ToArray();

						if ( times.Any() && times.First() == 0 )
						{
							time_matrix.Add(times);
						}
					}

					/// We are only interested if the time_matrix is square
					/// that it to say they all have the same number of tracks

					/// can we remove any of them?
					/// * are some shifted or direct copies of each other?
					/// easy way to figure this out is to take the mean average difference over
					/// tracks 2..n and see if the result is a whole integer -1,0,1,2, etc 

					int num_tracks = time_matrix[0].Length;
					int num_shows = time_matrix.Count();

					/// some of the cuesheets for 10 track shows (half shows) 
					/// for early asots don't work or are very inaccurate, 
					/// let's discard them

					if ( num_tracks < 15 ) continue;

					List<int> discard_dupe = new List<int>();

					if ( time_matrix.Any()
							&& time_matrix.All(t => t.Length == num_tracks) )
					{
						Console.WriteLine("Code: {0} Shows: {1}", c, num_shows);

						for ( int s1 = 1; s1 < num_shows; s1++ )
						{
							for ( int s2 = 0; s2 < s1; s2++ )
							{
								var di =
									Enumerable
									.Range(0, num_tracks)
									.Select(t => time_matrix[s1][t] - time_matrix[s2][t])
									.Sum();

								/// if the differences are all the same value
								/// we assume they are shifted copies
								var shifted =
									( Enumerable
									.Range(1, num_tracks - 1) /// skip first track
									.Select(t => time_matrix[s1][t] - time_matrix[s2][t])
									.Distinct()
									.Count() == 1 );

								if ( di == 0 || shifted )
								{
									/// add the first show to the dupe list (logic error?)
									discard_dupe.Add(s1-1);

									Console.WriteLine("[X]{1}	-> {0}", di, shifted && di != 0 ? "[S]" : "");
								}

								else Console.WriteLine( "	-> {0}", di );
							}
						}
					}

					int[] legit_shows =
						Enumerable
						.Range(0, num_shows)
						.Where(i => !discard_dupe.Contains(i)) /// not a dupe sheet
						.ToArray();

					int legitshows_howmany = legit_shows.Length;

					/// we want at least 3 legit human authors
					if ( legitshows_howmany > 2
							&& time_matrix.Any() 
							&& time_matrix.All(t => t.Length == num_tracks) )
					{
					
						/// now for each track we find the median and average the distance from it from
						/// all (skip the first track, it's assumed to be zero)
						for ( int t = 1; t < num_tracks; t++ )
						{
							int[] set = legit_shows
								.Select( i => time_matrix[ i ][ t ] ).ToArray();

							var orderedPersons = set.OrderBy(p => p);
							float median = 1f / 2 * ( orderedPersons.ElementAt(legitshows_howmany / 2) +
											orderedPersons.ElementAt(( legitshows_howmany - 1 ) / 2) );

							List<float> diffs = set.Select(s => (float)(s - median) ).ToList();

							foreach( float diff in diffs )
							{
								File.AppendAllText(asot_file, String.Format("{0}	{1}\r\n", diff, legitshows_howmany));
							}
						}

						File.AppendAllText(asot_showhistogram, String.Format("{0}	{1}\r\n", c, legitshows_howmany));
						Console.WriteLine("Code: {0} UniqueCues: {1} Tracks: {2}", c, legitshows_howmany, num_tracks);
					}
				}
			}

			Console.WriteLine(unique_codes.Count());
		}

		
	}
}
