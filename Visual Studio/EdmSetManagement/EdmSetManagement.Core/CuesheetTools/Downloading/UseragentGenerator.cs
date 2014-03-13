using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EdmSetManagement.Core.CuesheetTools.Downloading
{
	public class UseragentGenerator
	{
		Random _random = new Random();
	
		public string GiveMeOne() {
		
			return _userAgents[_random.Next(_userAgents.Length-1)];
		
		}
	
		string[] _userAgents = new string[] { "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.0.2) Gecko/20021120 Netscape/7.01",
								"Opera/9.50 (J2ME/MIDP; Opera Mini/4.1.10781/302; U; en)",
								"Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.0.12) Gecko/2009070611 (BT-redbulls) Firefox/3.0.12 (.NET CLR 3.5",
								"Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2 (.NET CLR 3.5.30729)",
								"Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.2) Gecko/20090803 Ubuntu/9.04 (jaunty) Shiretoko/3.5.2",
								"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.5) Gecko/2008120122 Firefox/3.0.5",
								"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.13) Gecko/2009073022 Firefox/3.0.13",
								"Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2 (.NET CLR 3.5.30729)",
								"Mozilla/5.0 (compatible; Yahoo! Slurp/3.0; http://help.yahoo.com/help/us/ysearch/slurp)",
								"Mozilla/5.0 (X11; U; SunOS i86pc; en-US; rv:1.9.1b3) Gecko/20090429 Firefox/3.1b3",
								"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.13) Gecko/2009080315 Ubuntu/9.04 (jaunty) Firefox/3.0.13",
								"Mozilla/5.Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1 .NET CLR 1.1.4322)",
								"Opera/9.64 (Windows NT 5.1; U; ru) Presto/2.1.1",
								"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2",
								"Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0)",
								"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9) Gecko/2008052906 Firefox/3.0",
								"Mozilla/5.0 (Macintosh; U; Intel Mac OS X; nl; rv:1.8.0.8) Gecko/20081025 Thunderbird/1.5.0.8",
								"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.20) Gecko/20081217 Firefox/2.0.0.20",
								"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.2) Gecko/20090803 Ubuntu/9.04 (jaunty) Shiretoko/3.5.2 GTB5",
								"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090803" };
	
	}
}
