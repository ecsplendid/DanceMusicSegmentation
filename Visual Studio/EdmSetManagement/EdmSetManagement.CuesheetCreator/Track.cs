using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CuesheetCreator
{
	public class Track
	{
		private int _number;

		public int Number
		{
			get { return _number; }
			set { _number = value; }
		}


		private string _artist;

		public string Artist
		{
			get { return _artist; }
			set { _artist = value; }
		}
	
		private string _title;

		public string Title
		{
			get { return _title; }
			set { _title = value; }
		}

		private double _position;

		public double Position
		{
			get { return _position; }
			set { _position = value; }
		}

		

	
	}
}
