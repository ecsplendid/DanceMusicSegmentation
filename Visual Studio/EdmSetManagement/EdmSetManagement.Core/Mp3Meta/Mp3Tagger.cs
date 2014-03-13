using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using EdmSetManagement.Core.Settings;
using System.IO;
using EdmSetManagement.Core.ConsoleWriter;

namespace EdmSetManagement.Core.Mp3Meta
{
	public class Mp3Tagger
	{
		Process tagProc = new Process();
		
		public Mp3Tagger() {

			tagProc.StartInfo.CreateNoWindow = true;
			tagProc.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
			tagProc.StartInfo.FileName = Configuration.Default.Id3Path;
		}
	
		public void TagMp3( string filename, string artist, string title, string album ) {
			TagMp3( filename, artist, title, album, null  );
		}
	
		public void TagMp3( string filename, string artist, string title, string album, string number  ) {

			if(!File.Exists(filename))
				throw new InvalidOperationException("Can't find the MP3!");

			Output.Write("ID3 Tagging {0}", new FileInfo(filename).Name);

			Output.Write("\t->Title: {0}", title);
			Output.Write("\t->Artist: {0}", artist);
			Output.Write("\t->Album: {0}", album);

			tagProc.StartInfo.Arguments = String.Format(@"-2 -t ""{0}"" ""{1}""", title, filename);
			tagProc.Start();
			tagProc.WaitForExit();

			tagProc.StartInfo.Arguments = String.Format(@"-2 -a ""{0}"" ""{1}""", artist, filename);
			tagProc.Start();
			tagProc.WaitForExit();

			tagProc.StartInfo.Arguments = String.Format(@"-2 -l ""{0}"" ""{1}""", album, filename);
			tagProc.Start();
			tagProc.WaitForExit();

			if( number != null ) {
				tagProc.StartInfo.Arguments = String.Format(@"-2 -n ""{0}"" ""{1}""", number, filename);
				tagProc.Start();
				tagProc.WaitForExit();
			}
		}
		
		public void UnTagMp3( string filename ) {

			if (!File.Exists(filename))
				throw new InvalidOperationException("Can't find the MP3!");

			Output.Write("Removing ID3 tags from {0}", new FileInfo(filename).Name );
			tagProc.StartInfo.Arguments = String.Format(@"-1 -2 -3 -d ""{0}""", filename);
			tagProc.Start();
			tagProc.WaitForExit();
		
		}
	}
}
