using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EdmSetManagement.Core.CuesheetTools.Association
{
	public interface IShowIdentifier
	{

		string MustAlsoMatch{get;set;}
		string MustNotMatch { get; set; }
	}
}
