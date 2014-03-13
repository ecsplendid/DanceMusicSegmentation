using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EdmSetManagement.Core.CuesheetTools.Association.Identifiers
{
	public class DateShowIdentifier : IShowIdentifier
	{
		public string DateFormat;
		public string DateParseRegex;
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
				MustAlsoMatch=value;
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
