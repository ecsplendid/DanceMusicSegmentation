using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Microsoft.DirectX.AudioVideoPlayback;
using System.Threading;
using System.Text.RegularExpressions;
using System.IO;
using System.Diagnostics;
using System.Windows.Forms.Integration;
using EdmSetManagement.Core.Mp3Meta;


namespace CuesheetCreator
{


	public partial class FormMain : Form
	{
	
		Timeline _timeLine = null;
		
		public FormMain()
		{
			InitializeComponent();
			FormResized();
		
			_timeLine = timeline1;

		}

		private void FocusTimeline()
		{
			_timeLine.IsEnabled = true;
			_timeLine.Focusable = true;
			_timeLine.Focus();
			//_timeLine.CaptureMouse();
			_timeLine.TabIndex = 1;
		}

		void _timeLine_Scrubbing(object sender, EventArgs args)
		{
			RenderTimeInformation();
			CuesheetPreview();
		}

		List<Track> _tracks = null;

		private void aboutCuesheetCreatorToolStripMenuItem_Click(object sender, EventArgs e)
		{
			MessageBox.Show("Copyright Tim Scarfe 2009\r\nhttp://www.developer-x.com", "Cuesheet Generator", MessageBoxButtons.OK);
		}

		private void buttonParseTracklist_Click(object sender, EventArgs e)
		{
			if( !File.Exists(textBoxMp3File.Text) ) return;

			_timeLine.LoadAudioFile(textBoxMp3File.Text);
		
			string tracklist = textBoxTracklist.Text;
			
			Regex track = new Regex(@"(#?\s?\d{1,2}\.?\s?)?(?<artist>.+?)\s?[-–]\s?(?<track>.+)\s?",RegexOptions.Singleline);
			Regex track_onlyTitle = new Regex(@"(#?\s?\d{1,2}\.?\s?)?(?<track>.+)\s?", RegexOptions.Singleline);

			string[] lines = textBoxTracklist.Text
				.Split( new string[]{ "\r\n" }, StringSplitOptions.RemoveEmptyEntries );
			
			int tn = 1;
			
			_tracks = lines
				.Where(s => track.IsMatch(s) || track_onlyTitle.IsMatch(s) )
				.Select(s => track.IsMatch(s) ? track.Match(s) : track_onlyTitle.Match(s))
				.Select(m => new Track { Artist = m.Groups["artist"].Value, Title = m.Groups["track"].Value, Number = tn++ })
				.ToList();

			LoadInTracks();
		}

		private void LoadInTracks()
		{
			if( _tracks.Count() == 0 ) return;
			
			string[] lines = textBoxTracklist.Text
				.Split(new string[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries);
		
			for (int x = 0; x < _tracks.Count(); x++)
			{
				Track t = _tracks[x];
				///some heuristic stuff
				if (t.Artist == String.Empty) t.Artist = "ID";

				_tracks[x].Position =  ( (double)1 / _tracks.Count() ) * (x);
			}

			trackBindingSource.DataSource = _tracks;
		
			tabControlCuesheet.SelectTab(tabPageParsedInput);

			//panelSliderContainer.Visible = true;
			
			_timeLine.LoadTracks( _tracks );
			
		}

		

		RadioButton _currentChecked = null;

		/// <summary>
		/// when a radiobox gets clicked
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		void RadioBox_CheckedChanged(object sender, EventArgs e)
		{
			RadioButton rb = (RadioButton) sender;
			
			if( !rb.Checked ) return;
			
			_currentChecked = rb;

			_dontChangePositions = true;
			///trackBarRadioShow.Value = Math.Max(0, (int)(((Track)rb.Tag).Position * trackBarRadioShow.Maximum) );
			_dontChangePositions = false;


			
		}

		bool _dontChangePositions = false;

		private void RenderTimeInformation()
		{
			if (_timeLine.Backmusic == null) return;
		
			StringBuilder timeInfo = new StringBuilder();

			for (int x = 0; x < _tracks.Count(); x++)
			{
				Track t = _tracks[x];
				int track_no = x + 1;

                TimeSpan ts = new TimeSpan(0, 0, 0, 0, (int)(t.Position * duration * 1000));

				double tnext_pos = (x == _tracks.Count() - 1) ? 1 : _tracks[x + 1].Position;
                TimeSpan ts_next = new TimeSpan(0, 0, (int)(tnext_pos * duration));
				TimeSpan ts_dur = ts_next - ts;

				timeInfo.AppendFormat("[{3:000}:{4:00}:{7:00}] {0:00}. {1} - {2} ({5:00}:{6:00})\r\n",
					track_no, t.Artist, t.Title, 
					Math.Floor(ts.TotalMinutes), ts.Seconds,
					Math.Floor(ts_dur.TotalMinutes), 
						ts_dur.Seconds, Math.Floor((((double)ts.Milliseconds / 1000) * 74)) );

					
					
			}
			
			///take off last crlf
			timeInfo.Length -=2;
			textBoxTimeInformation.Text = timeInfo.ToString();
			SetHeightTimeInfoScrollbar();
			
			textBoxTimeInformation.Select(0,0);
		}

		private void FormMain_Resize(object sender, EventArgs e)
		{
			FormResized();
		}

		private void FormResized()
		{
			

			SetHeightTimeInfoScrollbar();
			SetHeightCuesheetInfoScrollbar();
			ResetScrollbars();
		}

		private void ResetScrollbars()
		{
			///reset time scrollbar
			textBoxTimeInformation.Top += vScrollBarTimeInformation.Value;
			vScrollBarTimeInformation.Value = 0;
			///reset cue scrollbar
			textBoxCuesheetPreview.Top += vScrollBarCuesheet.Value;
			vScrollBarCuesheet.Value = 0;
		}

		private void buttonSaveCueAs_Click(object sender, EventArgs e)
		{
			saveFileDialog1.FileName = String.Format( "{0} - {1}.cue", textBoxArtist.Text, textBoxTitle.Text );
			
			if( saveFileDialog1.ShowDialog() != DialogResult.OK ) return;
			
			if( saveFileDialog1.FileName == null || saveFileDialog1.FileName == String.Empty ) return;
			
			string filename = saveFileDialog1.FileName;

			WriteCuesheet(filename);
			MessageBox.Show(String.Format("Cuesheet written to \r\n{0}", filename));
		}

		private void WriteCuesheet(string filename) {
			WriteCuesheet(filename,false);
		}

		private string GetCuesheet(bool relativePath) 
		{
			if (!File.Exists(textBoxMp3File.Text)) return String.Empty;

			if (_tracks == null) return String.Empty;
		
			StringBuilder cuesheet = new StringBuilder();

			FileInfo f = new FileInfo(textBoxMp3File.Text);
			string relativeFilePath = String.Format("..\\{0}", f.Name);
			string mediaFileType = "MP3";

			if (f.Extension.ToLower().Contains("wav")) mediaFileType = "WAVE";

			cuesheet.AppendFormat(@"PERFORMER ""{0}""
TITLE ""{1}""
FILE ""{2}"" {3}
",
			textBoxArtist.Text,
			textBoxTitle.Text,
			relativePath ? relativeFilePath : textBoxMp3File.Text,
			mediaFileType);

			foreach (Track t in _tracks)
			{
                TimeSpan ts = new TimeSpan(0, 0, 0, 0, (int)(t.Position * duration * 1000));

				cuesheet.AppendFormat(@"  TRACK {2:00} AUDIO
    PERFORMER ""{0}""
    TITLE ""{1}""
    INDEX 01 {3:00}:{4:00}:{5:00}
", t.Artist, t.Title, t.Number, Math.Floor(ts.TotalMinutes), ts.Seconds, (((double)ts.Milliseconds / 1000) * 74));

			}

			return cuesheet.ToString();
		}

		private void WriteCuesheet(string filename, bool relativePath)
		{
			File.WriteAllText(filename, GetCuesheet(relativePath), Encoding.Default);
		}

		private void buttonTestCuesheet_Click(object sender, EventArgs e)
		{
			string fn = Path.GetTempFileName().Replace("tmp","cue");
			WriteCuesheet(fn);
			System.Diagnostics.Process proc = new System.Diagnostics.Process();
			proc.StartInfo.FileName = fn;
			proc.StartInfo.UseShellExecute = true;
			proc.Start();
		}

		private void FormMain_FormClosing(object sender, FormClosingEventArgs e)
		{
			_timeLine.IsQuitting = true;
		}

		private void buttonRelativeSave_Click(object sender, EventArgs e)
		{
			FileInfo f = new FileInfo( textBoxMp3File.Text );

			///create a .\cuesheets directory
			string dir = String.Format( "{0}\\CueSheets\\", f.Directory.FullName );
			if(!Directory.Exists(dir)) Directory.CreateDirectory(dir);
			
			string cue_location = String.Format( "{0}{1} - {2}.cue", dir, textBoxArtist.Text, textBoxTitle.Text  );
			
			///now save the file in there
			WriteCuesheet( cue_location, true );

			MessageBox.Show( String.Format( "Cuesheet written to \r\n{0}", cue_location ) );
		}

		private void buttonOpenCuesheet_Click(object sender, EventArgs e)
		{
			openFileDialogCueSheets.ShowDialog();
			textBoxCueSheetPath.Text = openFileDialogCueSheets.FileName;
		}

		private void buttonOpenMP3File_Click(object sender, EventArgs e)
		{
			openFileDialogMp3.ShowDialog();
			textBoxMp3File.Text = openFileDialogMp3.FileName;
		}

		/// <summary>
		/// allowing user to drag drop mp3+cue files onto the form
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void FormMain_DragEnter(object sender, DragEventArgs e)
		{
			if (e.Data.GetDataPresent(DataFormats.FileDrop))
				e.Effect = DragDropEffects.Copy;
			else
				e.Effect = DragDropEffects.None;
		}

		/// <summary>
		/// allowing user to drag drop mp3+cue files onto the form
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void FormMain_DragDrop(object sender, DragEventArgs e)
		{
			Array a = (Array)e.Data.GetData(DataFormats.FileDrop);

			if (a != null)
			{
				string s = a.GetValue(0).ToString();
				
				FileInfo f = new FileInfo(s);
				if(f.Extension.ToLower()==".cue") {
					textBoxCueSheetPath.Text = s;
				}
				else if(f.Extension.ToLower()==".mp3") {
					textBoxMp3File.Text = s;
				}
			}
		}

		/// <summary>
		/// save the current cue in place
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void buttonSaveOverride_Click(object sender, EventArgs e)
		{
			WriteCuesheet(textBoxCueSheetPath.Text);
			MessageBox.Show(String.Format("Cuesheet written to \r\n{0}", textBoxCueSheetPath.Text));
		}

        double duration;

		/// <summary>
		/// parsing in a cue sheet
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void buttonParseCuesheet_Click(object sender, EventArgs e)
		{
			if(!File.Exists(textBoxCueSheetPath.Text) || !textBoxCueSheetPath.Text.ToLower().EndsWith(".cue")) return;

			string cueText = File.ReadAllText(textBoxCueSheetPath.Text, Encoding.Default);
			
			if( cueText.Length < 10 ) return;
			
			FileInfo cueFileInfo = new FileInfo(textBoxCueSheetPath.Text);
			
			Regex performer = new Regex( @"PERFORMER\s+?""(?<performer>[^""]+?)""", RegexOptions.Singleline );
			Regex title = new Regex( @"TITLE\s+?""(?<title>[^""]+?)""", RegexOptions.Singleline );
			Regex file = new Regex(@"FILE\s+?""(?<filename>[^""]+?)""\s+?(MP3|WAVE)", RegexOptions.Singleline);
			
			Regex trackMatch = null;
			
			int ti = cueText.IndexOf("TRACK");
			
			if( ti == -1 ) return;
			
			string subCueText = cueText.Substring( ti, cueText.Length - ti -1 );

			if (subCueText.IndexOf("PERFORMER") < subCueText.IndexOf("TITLE"))
			{
				trackMatch = new Regex(@"TRACK (?<trk>\d{2}) AUDIO.+?PERFORMER ""(?<perf>.*?)"".+?TITLE ""(?<tit>.*?)"".+?INDEX \d{2} (?<mins>\d{1,3}):(?<secs>\d{2}):(?<frames>\d{2})", RegexOptions.Singleline );
			}

			else {
				trackMatch = new Regex(@"TRACK (?<trk>\d{2}) AUDIO[^T]+?TITLE ""(?<tit>[^""]*?)""[^P]+?PERFORMER ""(?<perf>[^""]*?)"".+?INDEX \d{2} (?<mins>\d{1,3}):(?<secs>\d{2}):(?<frames>\d{2})", RegexOptions.Singleline);
			}
			
			if( title.IsMatch( cueText ) )
				textBoxTitle.Text = title.Match(cueText).Groups["title"].Value;
				
			string old = textBoxMp3File.Text;
			if (file.IsMatch(cueText)) {
				textBoxMp3File.Text = file.Match(cueText).Groups["filename"].Value;
				
				if( textBoxMp3File.Text.StartsWith("..\\") ) {

					textBoxMp3File.Text = String.Format( "{0}\\{1}", cueFileInfo.Directory.FullName, textBoxMp3File.Text );
				}
			}
			
			if (!File.Exists(textBoxMp3File.Text) && old != String.Empty) textBoxMp3File.Text = old;
			if (!File.Exists(textBoxMp3File.Text) ) return;
			
			if (performer.IsMatch(cueText))
				textBoxArtist.Text = performer.Match(cueText).Groups["performer"].Value;

			if( _timeLine.Backmusic != null ) _timeLine.Backmusic.Stop();
			_timeLine.LoadAudioFile(textBoxMp3File.Text);
			
			int x = 1;

            Mp3Sizer mp3s = new Mp3Sizer();
           

            duration  = mp3s.GetSizeOfMp3File(textBoxMp3File.Text).TotalSeconds;// _timeLine.Backmusic.Duration;
			
			if( trackMatch.IsMatch(cueText) ) {

				_tracks = trackMatch.Matches(cueText)
					.OfType<Match>()
					.Select( m => new Track{ 
								Number=x++,
								Artist=m.Groups["perf"].Value,
								Title=m.Groups["tit"].Value,
								Position = 
									(( new TimeSpan(0, 0,
										Convert.ToInt32(m.Groups["mins"].Value), 
										Convert.ToInt32(m.Groups["secs"].Value),
										(int)Math.Floor( 
											Convert.ToDouble(
												m.Groups["frames"].Value
												) / 74 * 1000 
											) ).TotalMilliseconds / 1000) / duration )
					}).ToList();

				trackBindingSource.DataSource = _tracks;

				StringBuilder sb = new StringBuilder();

				x = 1;
				foreach (Track t in _tracks)
				{
					sb.AppendFormat( "{0:00}. {1} - {2}\r\n", x++, t.Artist, t.Title );
				}

				textBoxTracklist.Text = sb.ToString();

				_timeLine.LoadTracks(_tracks);
				RenderTimeInformation();
			}
		}

	
		private void tabPageCuesheet_Enter(object sender, EventArgs e)
		{
			CuesheetPreview();
		}

		private void CuesheetPreview()
		{
			if (tabControlCuesheet.SelectedTab == tabPageCuesheet) {
		
				textBoxCuesheetPreview.Text = GetCuesheet(false);
				SetHeightCuesheetInfoScrollbar();
			}
		}

		private void vScrollBarTimeInformation_Scroll(object sender, ScrollEventArgs e)
		{
			textBoxTimeInformation.Top = -vScrollBarTimeInformation.Value;	
		}

		private void SetHeightTimeInfoScrollbar()
		{
			SizeF size = TextRenderer.MeasureText(
						 textBoxTimeInformation.Text,
						 textBoxTimeInformation.Font,
						 textBoxTimeInformation.ClientRectangle.Size,
						 TextFormatFlags.WordBreak);

			vScrollBarTimeInformation.Maximum = Math.Max(0, (int)size.Height - tabPageTimeInfo.Height);
			
			vScrollBarTimeInformation.Enabled = vScrollBarTimeInformation.Maximum != 0;
		}
		
		private void SetHeightCuesheetInfoScrollbar()
		{
			SizeF size = TextRenderer.MeasureText(
						 textBoxCuesheetPreview.Text,
						 textBoxCuesheetPreview.Font,
						 textBoxCuesheetPreview.ClientRectangle.Size,
						 TextFormatFlags.WordBreak);

			vScrollBarCuesheet.Maximum = Math.Max(0, (int)size.Height - tabPageCuesheet.Height);
			vScrollBarCuesheet.Enabled = vScrollBarCuesheet.Maximum != 0;
		}

		private void vScrollBarCuesheet_Scroll(object sender, ScrollEventArgs e)
		{
			textBoxCuesheetPreview.Top = -vScrollBarCuesheet.Value;	
		}

		private void toolStripButtonStopPlaying_Click(object sender, EventArgs e)
		{
			_timeLine.Backmusic.Stop();
		}

		private void buttonChopTag_Click(object sender, EventArgs e)
		{
			string overrideDirectory = null;
		
			if( Directory.Exists("D:\\chop") ) { ///tim specific stuff
						
				Regex month = new Regex("[a-zA-Z]+", RegexOptions.Singleline );
												 
				string destDir = 
					String.Format( 
						@"D:\chop\{0} {1}", 
						month.Match(DateTime.Now.ToLongDateString()).Value, 
						DateTime.Now.Year );
												 
				if( !Directory.Exists(destDir) ) Directory.CreateDirectory( destDir );
				
				string nicePath = String.Format( @"{0}\{1} - {2}", 
					destDir, textBoxArtist.Text, textBoxTitle.Text );
					
				 if( MessageBox.Show( 
					String.Format( "Do you want to use: \r\n{0}", nicePath ), 
					"Chop Folder", 
					MessageBoxButtons.YesNo ) == DialogResult.Yes ) {
					
					Directory.CreateDirectory( nicePath );
					overrideDirectory = nicePath;
					
				} 
			}
			
			string fn = Path.GetTempFileName().Replace("tmp","cue");
			WriteCuesheet(fn);

			if ( overrideDirectory == null && folderBrowserDialog.ShowDialog() != DialogResult.OK) return;

			string selectedPath = overrideDirectory == null ? folderBrowserDialog.SelectedPath : overrideDirectory;

			WriteOutputWindow(String.Format("{0} selected for output...", selectedPath ));

			DirectoryInfo di = new DirectoryInfo(selectedPath);
			var filesBefore = di.GetFiles();
	
			Process proc = new Process();
			proc.StartInfo.FileName = @".\Images\mp3splt.exe";
			proc.StartInfo.Arguments = 
				String.Format( @"-a -p gap=0 -f -d ""{0}"" -c ""{1}"" -o ""[@n] @p - @t"" ""{2}""",
					selectedPath, fn, textBoxMp3File.Text);
			
			WriteOutputWindow(String.Format( "Splitting MP3 into chunks from {0}...",  fn));

			proc.StartInfo.CreateNoWindow = true;
			proc.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
			proc.StartInfo.RedirectStandardError = true;
			proc.StartInfo.UseShellExecute=false;
			
			proc.Start();
			proc.PriorityClass = ProcessPriorityClass.BelowNormal;
			while( !proc.HasExited ) {

				textBoxOutputWindow.Text += proc.StandardError.ReadToEnd();
				textBoxOutputWindow.Select(textBoxOutputWindow.Text.Length - 2, 1);
				textBoxOutputWindow.ScrollToCaret();
				
				Application.DoEvents();
			}
			
			
			var filesAfter = di.GetFiles();
			var intersection = filesAfter.Intersect( filesBefore );
			var outputFiles = filesAfter.Where( f=>!intersection.Contains(f) );
			
			Regex trackDetails = new Regex( 
				@"\[(?<num>\d{1,2})\]\s(?<art>.+?)\s-\s(?<tit>.+?)\.mp3$",
				RegexOptions.Singleline );
			
			foreach( var file in outputFiles.Where( f=>f.Extension == ".mp3" ) ) 
			{
				string newFile = Regex.Replace( file.Name, @"\[(\d{1})\]", "[0$1]" ) ;

				if (File.Exists(newFile) && newFile != file.Name ) File.Delete(newFile);

				file.MoveTo(String.Format("{0}\\{1}", file.Directory.FullName, newFile ));
				
				Match m = trackDetails.Match(file.Name);
				
				WriteOutputWindow(String.Format( "Tagging {0}...",  file.Name ));
				
				Process tagProc = new Process();

				tagProc.StartInfo.CreateNoWindow = true;
				tagProc.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
				tagProc.StartInfo.FileName = @".\Images\id3.exe";

				tagProc.StartInfo.Arguments = String.Format(@"-2 -t ""{0}"" ""{1}""", m.Groups["tit"].Value, file.FullName );
				tagProc.Start();
				tagProc.WaitForExit();

				tagProc.StartInfo.Arguments = String.Format(@"-2 -a ""{0}"" ""{1}""", m.Groups["art"].Value, file.FullName);
				tagProc.Start();
				tagProc.WaitForExit();

				tagProc.StartInfo.Arguments = String.Format(@"-2 -n ""{0}"" ""{1}""", m.Groups["num"].Value, file.FullName);
				tagProc.Start();
				tagProc.WaitForExit();

				tagProc.StartInfo.Arguments = String.Format(@"-2 -l ""{0}"" ""{1}""", textBoxArtist.Text, file.FullName);	
				tagProc.Start();
				tagProc.WaitForExit();
			}

			WriteOutputWindow("\r\nALL DONE!!!");
		}

		private void WriteOutputWindow(string text)
		{
			tabControlCuesheet.SelectedTab = tabPageOutputWindow;
			textBoxOutputWindow.Text += String.Format("{0}: {1}\r\n", DateTime.Now.ToString("hh:mm:ss"), text );
			textBoxOutputWindow.Select(textBoxOutputWindow.Text.Length-1,0);
			textBoxOutputWindow.ScrollToCaret();
		}

		private void button1_Click(object sender, EventArgs e)
		{
			FocusTimeline();
		}

		private void tabControlCuesheet_Enter(object sender, EventArgs e)
		{
			FocusTimeline();
		}
		
	}

	abstract class Win32Messages
	{
		public const int WM_MOUSEHWHEEL = 0x020E;//discovered via Spy++
	}
}