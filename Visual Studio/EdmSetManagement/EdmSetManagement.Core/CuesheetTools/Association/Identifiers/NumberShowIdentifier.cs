using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EdmSetManagement.Core.CuesheetTools.Association.Identifiers
{
	public class NumberShowIdentifier : IShowIdentifier
	{
		public string NumberParseRegex;
		public string MustAlsoMatch;
		public string MustNotMatch;

		#region IShowIdentifier Members

		string IShowIdentifier.MustAlsoMatch
		{
			get
			{
				return MustAlsoMatch;
			}
			set
			{
				MustAlsoMatch = value;
			}
		
		}
		
		string IShowIdentifier.MustNotMatch
		{
			get
			{
				return MustNotMatch;
			}
			set
			{
				MustNotMatch = value;
			}
		}

		#endregion
	}
}
