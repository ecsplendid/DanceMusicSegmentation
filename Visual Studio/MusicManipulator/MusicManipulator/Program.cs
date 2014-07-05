using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace MusicManipulator
{
	class Program
	{
		/// <summary>
		/// purpose of this is to look for duplicates, generate a matlab script and sox
		/// </summary>
		/// <param name="args"></param>
		static void Main(string[] args)
		{
			//MagicExtended();

			//ASOT();

			CreateSoxScript();
			//TATW();
		}

		private static void MagicExtended()
		{
			string[] folders = new string[]{
			@"C:\Users\tim_000\Google Drive\Dennis Music Dataset\Magic Island - Music for Balearic People",
			};

			string header = "magic_shows = { ";
			string footer = "}";

			StringBuilder sb = new StringBuilder();

			int count = 0;

			List<string> completed = new List<string>();

			Dictionary<string, string> AsBefore = new Dictionary<string, string>();

			Regex codepattern = new Regex("\\d{3}", RegexOptions.Singleline);

			foreach ( string folder in folders )
			{
				foreach ( string file in Directory.GetFiles(folder).Where(s => s.EndsWith(".cue")) )
				{
					FileInfo f = new FileInfo(file);

					string code = codepattern.Match(f.Name).Value;

					if ( completed.Contains(code) )
					{
						Console.WriteLine("Duplicate Detected {0}", code);
						continue;
					}

					completed.Add(code);


					WriteOutLine(sb, file.Replace(".cue", ""));

					count++;



				}
			}

			Console.WriteLine(count);

			File.WriteAllText("magic_script_extended.m", String.Format("{0}{1}{2}", header, sb.ToString(), footer));
		}

		private static void ASOT()
		{
			string[] folders = new string[]{
			@"C:\Users\tim_000\Google Drive\Dennis Music Dataset\A State of Trance",
			};

			string header = "asot_shows = { % note 338 dupe for consistency with first paper\r\n";
			string footer = "}";

			StringBuilder sb = new StringBuilder();

			int count = 0;

			List<string> completed = new List<string>();

			Dictionary<string, string> AsBefore = new Dictionary<string, string>();

			Regex codepattern = new Regex("\\d{3}", RegexOptions.Singleline);

			foreach ( string folder in folders )
			{
				foreach ( string file in Directory.GetFiles(folder).Where(s => s.EndsWith(".mp3")) )
				{
					FileInfo f = new FileInfo(file);

					string code = codepattern.Match(f.Name).Value;

					if ( completed.Contains(code) )
					{
						Console.WriteLine("Duplicate Detected {0}", code);
						continue;
					}

					completed.Add(code);


					WriteOutLine(sb, file.Replace(".mp3", ""));

					count++;



				}
			}

			Console.WriteLine(count);

			File.WriteAllText("asot_script_extended.m", String.Format("{0}{1}{2}", header, sb.ToString(), footer));
		}

		private static void TATW()
		{
			string[] folders = new string[]{
			@"C:\Users\tim_000\Google Drive\Dennis Music Dataset\Trance Around The World",
			@"C:\Users\tim_000\Google Drive\Dennis Music Dataset\Trance Around The World\different filenaming"
			};

			string[] safelist = File.ReadAllLines("tatw.txt");

			int was = safelist.Count();

			safelist = safelist.Distinct().ToArray();

			//Debug.Assert(safelist.Count() == was);

			string header = "tatw_shows = { % note 338 dupe for consistency with first paper\r\n";
			string footer = "}";

			StringBuilder sb = new StringBuilder();

			Regex codepattern = new Regex("349\\.5|\\d{3}", RegexOptions.Singleline);

			int count = 0;

			List<string> completed = new List<string>();

			Dictionary<string, string> AsBefore = new Dictionary<string, string>();

			foreach ( string folder in folders )
			{
				foreach ( string file in Directory.GetFiles(folder).Where(s => s.EndsWith(".mp3")) )
				{
					FileInfo f = new FileInfo(file);

					string code = codepattern.Match(f.Name).Value;

					if ( completed.Contains(code) )
					{
						Console.WriteLine("Duplicate Detected {0}", code);
						continue;
					}

					completed.Add(code);

					if ( safelist.Contains(code) )
					{
						string fn = file.Replace(".mp3", "");

						WriteOutLine(sb, fn);

						if ( code == "338" ) WriteOutLine(sb, fn);

						count++;
					}

				}
			}

			Console.WriteLine(count);

			File.WriteAllText("tatw_script_extended.m", String.Format("{0}{1}{2}", header, sb.ToString(), footer));
		}

		private static void WriteOutLine(StringBuilder sb, string fn)
		{
			sb.AppendFormat("show('{0}.wav','{1}.ind.txt','{2}.chops.txt'),...\r\n", fn, fn, fn);
		}

		private static void CreateSoxScript()
		{
			Console.BufferWidth = 400;

			string[] paths = new string[] {
				@"E:\Music"
			};

			foreach ( string path in paths )
			{
				string batchFilePath = String.Format("{0}\\soxscript.bat", path);

				if ( File.Exists(batchFilePath) )
					File.Delete(batchFilePath);

				DirectoryInfo folder = new DirectoryInfo(path);

				foreach ( var mp3 in folder.GetFiles().Where(f => f.Extension == ".mp3") )
				{
					File.AppendAllText(
						batchFilePath,
						String.Format("sox \"{0}\" -b 8 -r 4000 --norm -c 1 \"{1}\" -S -G\r\n", mp3.Name, mp3.Name.Replace(".mp3", ".wav")));

				}

			}
		}
	}
}
