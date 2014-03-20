using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace ResultsParser
{
	class Program
	{
		static void Main(string[] args)
		{
			string[] results = File.ReadAllLines("results.txt");

			StringBuilder sb = new StringBuilder();

			string[] pattern_groups = new string[] { "me", "heu", "t", "sy", "co", "su", "ga", "syib", "coib", "suib", "gaib", "bw", "lp", "hp", "ss", "sa" };

			Regex result_pattern = new Regex(
				@"T(?<t>\d{1,2}) SY(?<sy>(\d\.)?\d) CO(?<co>(\d\.)?\d) SU(?<su>(\d\.)?\d) GA(?<ga>(\d\.)?\d) SYIB(?<syib>(\d\.)?\d) COIB(?<coib>(\d\.)?\d) SUIB(?<suib>(\d\.)?\d) GAIB(?<gaib>(\d\.)?\d) BW(?<bw>(\d{1,2}\.)?\d) LP(?<lp>(\d{1,4}\.)?\d) HP(?<hp>(\d{2,3}\.)?\d) SS(?<ss>-?\d) -> mean=(?<me>(\d{1,3}\.)?\d{1,2}), heuristic=(?<heu>(\d{1,3}\.)?\d{1,2}) shiftavg=(?<sa>(-?\d{1,3}\.)?\d)");

			foreach(string line in results)
			{
				Match m = result_pattern.Match(line);

				foreach ( string group_name in pattern_groups )
				{
					sb.AppendFormat("{0}	", m.Groups[group_name].Value);

					Console.WriteLine(line);
				}

				/// take off the trailing tab
				sb.Length -= 1;
				/// stick a new line on the end
				sb.Append("\r\n");
			}

			File.WriteAllText("results_cleaned", sb.ToString());


		}
	}
}
