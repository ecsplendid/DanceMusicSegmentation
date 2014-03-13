using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Shapes;
using System.Windows;
using System.Windows.Media;
using System.Windows.Input;
using System.Windows.Controls;


namespace CuesheetCreator
{
	public class IndexMarker : Shape
	{
		private bool isDragging;
		private Point controlPoint, mousePoint, newMousePoint;

		public IndexMarker()
		{
			
		}

		protected override Geometry DefiningGeometry
		{
			get
			{
				return new RectangleGeometry(new Rect(new Size(this.Width, this.Height)));
			}
		}

		protected override void OnMouseDown(MouseButtonEventArgs e)
		{
			base.OnMouseDown(e);

			isDragging = true;

			controlPoint = new Point(Canvas.GetLeft(this), Canvas.GetTop(this));
			mousePoint = new Point(Mouse.GetPosition((IInputElement)this.Parent).X, Mouse.GetPosition((IInputElement)this.Parent).Y);
		}

		protected override void OnMouseMove(MouseEventArgs e)
		{
			base.OnMouseMove(e);

			if (isDragging == true)
			{
				newMousePoint = new Point(Mouse.GetPosition((IInputElement)this.Parent).X, Mouse.GetPosition((IInputElement)this.Parent).Y);

				Canvas.SetLeft(this, (controlPoint.X + newMousePoint.X - mousePoint.X));
				
				
				
			}
		}

		protected override void OnMouseUp(MouseButtonEventArgs e)
		{
			base.OnMouseUp(e);

			isDragging = false;
		}
	}

}


