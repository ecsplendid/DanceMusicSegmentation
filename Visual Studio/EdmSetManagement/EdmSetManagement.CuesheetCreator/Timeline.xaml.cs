using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Controls.Primitives;
using System.IO;
using Microsoft.DirectX.AudioVideoPlayback;
using System.Threading;
using System.Windows.Media.Animation;
using System.Diagnostics;

namespace CuesheetCreator
{
	/// <summary>
	/// Interaction logic for Timeline.xaml
	/// </summary>
	public partial class Timeline : UserControl
	{
		/// <summary>
		/// in seconds, NOT INT
		/// </summary>

		public string Track = null;
		private List<Track> _tracks = null;
		private Audio _backmusic;
		public bool IsQuitting = false;

		public Audio Backmusic
		{
			get { return _backmusic; }
			set { _backmusic = value; }
		}

		private Thread _scrubThread;
		private DateTime _lastScrubbed = DateTime.Now;



		public Timeline()
		{
			KickScrubPauseThreadOff();
			InitializeComponent();


			main.MouseWheel+=new MouseWheelEventHandler(main_MouseWheel);
			
			

		}

		void main_MouseWheel(object sender, MouseWheelEventArgs e)
		{
		
			bool zoomIn = e.Delta > 0;
		
			double zoomAmount = 1.1d;
		
			if( zoomIn ) {



				Canvas.SetLeft(indexCanvas, Canvas.GetLeft(indexCanvas)- (e.GetPosition(main).X - main.Width) * zoomAmount);

				indexCanvas.Width *= zoomAmount;
				timeline.Width *= zoomAmount;
				
				
				
			}

			else {
				Canvas.SetLeft(indexCanvas, Canvas.GetLeft(indexCanvas) +  (e.GetPosition(main).X - main.Width) * 0.6667d);
				indexCanvas.Width *= 1 / zoomAmount;
				timeline.Width *= 1 / zoomAmount;
			}

			RefreshIndexPositions();
		
		}

		private void RefreshIndexPositions()
		{
			var indexes = indexCanvas
					.Children
					.OfType<UIElement>()
					.Where(t => t is Thumb);

			foreach (Thumb index in indexes)
			{
				Canvas.SetLeft(index, ((Track)index.Tag).Position * indexCanvas.Width);
			}
		}

		public delegate void ScrubbingEventHandler(object sender, EventArgs args);
		public event ScrubbingEventHandler Scrubbing;

		private void KickScrubPauseThreadOff()
		{
			_scrubThread = new Thread(new ThreadStart(delegate()
			{
				while (!IsQuitting)
				{
					Thread.Sleep(1000);

					if (_lastScrubbed.AddSeconds(4) < DateTime.Now && _backmusic != null)
						_backmusic.Pause();
				}

			}));

			_scrubThread.Start();
		}

		private void LoadAudioFile()
		{
			if (_backmusic == null)
				_backmusic = new Audio(Track);
			else _backmusic.Stop();

			if (File.Exists(Track) &&
				(Track.EndsWith(".mp3") || Track.EndsWith(".wav")))
			{
				_backmusic.Open(Track);
			}
		}


		Thumb _lastThumb = null;
		Point _thumbMouseDownPosition;
		double _initialPosition = 0d;
		
		private void Thumb_DragDelta(object sender,
			System.Windows.Controls.Primitives.DragDeltaEventArgs e)
		{
			Thumb thumb = e.Source as Thumb;
			Track track = (Track)thumb.Tag;

			if( track == null ) return;

			///got the mouse position now in relative to some constant point on the selected index
			Point pos = Mouse.GetPosition( thumb );

			double y = pos.Y;
					
			///set left, ensure cant go off edges
			//double left = Canvas.GetLeft(thumb) + changeX;
			double left = Canvas.GetLeft(thumb) + Math.Round(e.HorizontalChange);
			left = Math.Max(0, left);
			left = Math.Min(indexCanvas.Width, left);
			Canvas.SetLeft(thumb, left);

			track.Position = left / indexCanvas.Width;
			
			///play the music
			//_backmusic.CurrentPosition = track.Position * _backmusic.Duration;
			//_backmusic.Play();
			//_lastScrubbed = DateTime.Now;
			
			///set the scrub text
			TextBlock scrubText = (TextBlock)thumb.Template.FindName("scrubText", thumb);
			TimeSpan ts = new TimeSpan(0, 0, 0, 0, (int)(track.Position * _backmusic.Duration * 1000));

			scrubText.Text = String.Format("{0:00}:{1:00}:{2:00}F",
				Math.Floor(ts.TotalMinutes),
				Math.Floor((double)ts.Seconds),
				Math.Floor(((double)ts.Milliseconds / 1000) * 74));

			///set variables
			_lastThumb = thumb;

			// Has any objects interested in scrubbing? :)
			if (Scrubbing != null)
			{
				// Yes, notify all the objects
				Scrubbing(sender, e);
			}
		}

		internal void LoadAudioFile(string audioFile)
		{
			if (!File.Exists(audioFile)) return;

			Track = audioFile;

			//if (_backmusic == null) _backmusic = new Audio(audioFile);
			//else _backmusic.Open(audioFile);
		}

		internal void LoadTracks(List<Track> tracks)
		{
			indexCanvas
				.Children
				.OfType<UIElement>()
				.Where(e => e is Thumb)
				.ToList()
				.ForEach(e => indexCanvas.Children.Remove(e));

			for (int x = 0; x < tracks.Count; x++)
			{
				Thumb t = new Thumb();

				t.DragDelta += new System.Windows.Controls.Primitives.DragDeltaEventHandler(Thumb_DragDelta);
				t.DragStarted += new DragStartedEventHandler(thumb_DragStarted);
				
				t.Background = Brushes.White;
				t.Foreground = Brushes.White;
				t.Style = (Style)TryFindResource("ThumbStyle1");
				t.Width = 10;
				t.Height = 75;
				t.Tag = tracks[x];
				Canvas.SetLeft(t, tracks[x].Position * indexCanvas.Width);
				Canvas.SetTop(t, 15);

				indexCanvas.Children.Add(t);
			}

			_tracks = tracks;
		}


			

		int zIndexHighest = 100;

		void thumb_DragStarted(object sender, DragStartedEventArgs e)
		{
			Thumb thumb = e.Source as Thumb;
			Track main_track = (Track)thumb.Tag;

			_thumbMouseDownPosition = Mouse.GetPosition(thumb);
			_initialPosition = main_track.Position;
			
			Canvas.SetZIndex(thumb, zIndexHighest++);

			TextBlock scrubText = (TextBlock)thumb.Template.FindName("scrubText", thumb);

			TimeSpan ts = new TimeSpan(0, 0, 0, 0, (int)(main_track.Position * _backmusic.Duration * 1000));

			scrubText.Text = String.Format("{0:00}:{1:00}:{2:00}F",
				Math.Floor(ts.TotalMinutes),
				Math.Floor((double)ts.Seconds),
				Math.Floor(((double)ts.Milliseconds / 1000) * 74 ) );

			var indexes = indexCanvas
				.Children
				.OfType<UIElement>()
				.Where(t => t is Thumb);

			foreach (Thumb index in indexes)
			{
				Track track = (Track)index.Tag;

				NamePreviewTrackLabel(index, track);

				TextBlock next = (TextBlock)index.Template.FindName("nextTrack", index);

				if (index != thumb)
				{
					((Storyboard)index.Template.Resources["BackToNormal"]).Begin(index, index.Template, false);
				}
			}
		}

		private void NamePreviewTrackLabel(Thumb index, Track track)
		{
			TextBlock next = (TextBlock)index.Template.FindName("nextTrack", index);
			TextBlock prev = (TextBlock)index.Template.FindName("prevTrack", index);

			if (track.Number <= _tracks.Count)
			{
				next.Text = String.Format("{0:0}: {1} - {2}",
					_tracks[track.Number - 1].Number,
					_tracks[track.Number - 1].Artist,
					_tracks[track.Number - 1].Title);
			}
			
			else next.Text = String.Empty;

			if (track.Number > 1)
			{
				prev.Text = String.Format("{0:0}: {1} - {2}",
					_tracks[track.Number - 2].Number,
					_tracks[track.Number - 2].Artist,
					_tracks[track.Number - 2].Title);
			}
			else prev.Text = String.Empty;
		}
	}
}
