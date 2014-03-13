using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EdmSetManagement.Core.CuesheetTools
{
	public class CuesheetTrack
	{
		public string Artist;
		
		private string _orig=null;
		
		public string OriginalTrackTitle{
			get{ return _orig != null?_orig:TrackTitle;  }
			set{ _orig = value; }
		}
		public string TrackTitle;
		public int Minutes;
		public int Seconds;
		public int Frames;
		public int Number;
		public Cuesheet Cuesheet = null;
		///used for when dealing with tracks from multiple cuesheets
		public int AbstractNumber;

		public TimeSpan Position;
		public TimeSpan OriginalPosition;
		public TimeSpan Length;

		public string GetFullTitle() {

			if ( Artist.Contains("presents") ) return String.Format("{0} {1}", Artist, TrackTitle);
				else return String.Format("{0} - {1}", Artist, TrackTitle);
		}
		
		public TimeSpan GetTimeSpan() {
		
			return new TimeSpan( 0,0,Minutes,Seconds, (int)(((double)Frames/75)*1000) );
		
		}

		public void ShiftTimeForwards(TimeSpan amount)
		{
			SetTimeSpan( GetTimeSpan() + amount );
		}

		public void SetTimeSpan(TimeSpan value)
		{
			Minutes = (int)Math.Floor( value.TotalMinutes );
			Seconds = (int)value.Seconds;
			Frames = (int) Math.Floor((((double)value.Milliseconds)/1000)*75);

		}
	}
}
