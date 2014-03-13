using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Windows.Forms.Integration;
using System.Windows.Controls;

namespace CuesheetCreator
{
	public partial class WpfHostTest : Form
	{
		private ElementHost host;
			// Any Wpf user control or Wpf custom control
		
			
		public WpfHostTest()
		{
			InitializeComponent();
			
			
			host = new ElementHost();
			host.Child = new Timeline();
			host.Dock = DockStyle.Fill;
			
			this.Controls.Add(host);
			
		
		}
	}
}
