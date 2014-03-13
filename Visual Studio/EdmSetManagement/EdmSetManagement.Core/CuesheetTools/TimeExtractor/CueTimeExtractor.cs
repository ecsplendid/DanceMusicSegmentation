using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace EdmSetManagement.Core.CuesheetTools.TimeExtractor
{
    public class CueTimeExtractor
    {
		/// <summary>
		/// https://docs.google.com/a/developer-x.com/file/d/0Bz9S4LIuPplkLU5DNnhIRlBnNms/edit
		/// </summary>
		/// <param name="path"></param>
		/// <param name="originalStreamLength"></param>
		/// <param name="prune"></param>
		/// <returns></returns>
		public static CueTimeExtractorResult 
			GetFactorTimes(string path, int originalStreamLength, bool prune = false)
        {
            Regex exclusion = new Regex("outro|intro", 
                            RegexOptions.IgnoreCase | RegexOptions.Singleline );

            Cuesheet cue = new Cuesheet();
            cue.ParseInFromFile(path);

			/// set lengths and original positions (note that anything chopped must be in original space)
			PreprocessTracks(originalStreamLength, cue);

			List<string> factorTimesDescriptions = new List<string>();
			List<double> factorTimes = new List<double>();
			List<int> factorSeconds = new List<int>();

			List<CueTimeExtractorChop> chops = new List<CueTimeExtractorChop>();


			int min_tracklength = 180;

			HandleStartingIllegitimateTracks(exclusion, cue, factorTimesDescriptions, chops, min_tracklength);

			/// we are going to iterate though them backwards
            for( int i=cue.Tracks.Count; i>0; i-- )
			{
				CuesheetTrack t = cue.Tracks[i-1];

				/// figure out back illegitimate tracks
				int back = 0;

				back = CalculateBacks(exclusion, cue, min_tracklength, i, back);

				i = RemoveBacks(cue, factorTimesDescriptions, chops, i, back);
			}

			int newTotalStreamLength = FinalTrackCalculations(cue, ref factorTimes, factorSeconds, ref chops);

			if ( originalStreamLength < newTotalStreamLength )
				throw new InvalidOperationException("Why has the length of the show grown");

			int totalChoppedTime = originalStreamLength - newTotalStreamLength;

			return new CueTimeExtractorResult 
			{ 
				FactorSeconds = factorSeconds.ToArray(),
				FactorTimes = factorTimes.ToArray(), 
				FactorTimesDescriptions = factorTimesDescriptions.ToArray(),
				Chops = chops.ToArray(),
				NewLength = newTotalStreamLength
			};
        }

		private static int FinalTrackCalculations(Cuesheet cue, ref List<double> factorTimes, List<int> factorSeconds, ref List<CueTimeExtractorChop> chops)
		{
			/// how many seconds is the whole show now?
			int updated_totalSeconds = (int)Math.Floor(cue.Tracks.Sum(t => t.Length.TotalSeconds));

			int last_tracklength = 0;

			/// update the factortimes
			for ( int x = 0; x < cue.Tracks.Count-1; x++ )
			{
				int track_length = (int)Math.Floor(cue.Tracks[x].Length.TotalSeconds);

				factorSeconds.Add(track_length + last_tracklength);
				last_tracklength += track_length;
			}

			factorTimes = factorSeconds.Select(t => Convert.ToDouble(t) / (double)last_tracklength).ToList();

			chops = chops.OrderByDescending(s => s.To).ToList();
			return updated_totalSeconds;
		}

		private static int RemoveBacks(Cuesheet cue, List<string> factorTimesDescriptions, List<CueTimeExtractorChop> chops, int i, int back)
		{
			if ( i > 0 && back > 0 )
			{
				var chopFromTrack = cue.Tracks[i - back];
				var chopToTrack = cue.Tracks[i - 1];

				/// add the relevant chop
				CueTimeExtractorChop c =
					new CueTimeExtractorChop
					{
						From = (int)chopFromTrack.OriginalPosition.TotalSeconds,
						To = (int)(chopToTrack.OriginalPosition + chopToTrack.Length).TotalSeconds
					};

				chops.Add(c);

				factorTimesDescriptions.Add(String.Format("<{0} {1} -> {2} [{3}]",
					back, chopFromTrack.GetFullTitle(),
					chopToTrack.GetFullTitle(),
					( c.From - c.To ).ToString()));

				/// physically remove the tracks
				for ( int x = 0; x < back; x++ )
				{
					cue.Tracks.Remove(cue.Tracks[i - back]);
				}

				i -= back;
			}
			return i;
		}

		private static int CalculateBacks(Regex exclusion, Cuesheet cue, int min_tracklength, int i, int back)
		{
			bool endtrack = i == cue.Tracks.Count - 1;
			/// at the end the minimum track length gets uped to 4 mins because we chop out the outro

			int extension_time = 60;
			bool foundLargeEndTrack = false;

			if ( i > 1 )
			{
				/// try to crawl backwards through a potential string of illegitimate tracks
				for ( back = 0; back <= i - 1; )
				{
					int track_minimum = (foundLargeEndTrack || !endtrack) ? min_tracklength : min_tracklength + extension_time;

					bool has_itgotintroutro = exclusion.IsMatch(cue.Tracks[i - back - 1].Artist + cue.Tracks[i - back - 1].TrackTitle);
					bool isittooshort = cue.Tracks[i - back - 1].Length.TotalSeconds < track_minimum;

					if ( endtrack && !isittooshort )
						foundLargeEndTrack = true;

					if ( has_itgotintroutro || isittooshort )
					{
						back++;
						continue;
					}
					else break;
				}
			}
			return back;
		}

		private static void HandleStartingIllegitimateTracks(Regex exclusion, Cuesheet cue, List<string> factorTimesDescriptions, List<CueTimeExtractorChop> chops, int min_tracklength)
		{
			/// handle the first illegitimate tracks as a special case
			/// ASOT sometimes has 2 intro tracks, then maybe with a short one after!

			while ( true )
			{
				var first_track = cue.Tracks.First();

				if ( exclusion.IsMatch(first_track.Artist + first_track.TrackTitle)
					|| first_track.Length.TotalSeconds < min_tracklength )
				{
					TimeSpan interval_removed = first_track.Length;

					CueTimeExtractorChop c =
							new CueTimeExtractorChop
							{
								From = (int)first_track.OriginalPosition.TotalSeconds,
								To = (int)( first_track.OriginalPosition + first_track.Length ).TotalSeconds
							};

					chops.Add(c);

					cue.Tracks.Remove(first_track);

					factorTimesDescriptions.Add(String.Format("!STARTING {0} [{1}]", first_track.TrackTitle, c.To - c.From));

				}

				else break;
			}
		}

		private static void PreprocessTracks(int totalSeconds, Cuesheet cue)
		{
			foreach ( CuesheetTrack t in cue.Tracks )
			{
				t.Position = t.GetTimeSpan();
				t.OriginalPosition = t.Position;
			}

			/// set lengths
			for ( int x = 1; x < cue.Tracks.Count; x++ )
			{
				cue.Tracks[x - 1].Length = cue.Tracks[x].Position - cue.Tracks[x - 1].Position;
			}

			cue.Tracks[cue.Tracks.Count - 1].Length
				= new TimeSpan(0, 0, totalSeconds -
					(int) Math.Floor(cue.Tracks[cue.Tracks.Count - 1].Position.TotalSeconds));
		}
    }

	public class CueTimeExtractorResult
	{
		public string[] FactorTimesDescriptions;
		public double[] FactorTimes;
		public int[] FactorSeconds;
		public CueTimeExtractorChop[] Chops;
		public int NewLength;
	}

	public class CueTimeExtractorChop
	{
		public int From;
		public int To;
	}
}