namespace CuesheetCreator
{
	partial class FormMain
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.components = new System.ComponentModel.Container();
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FormMain));
			this.textBoxTracklist = new System.Windows.Forms.TextBox();
			this.textBoxArtist = new System.Windows.Forms.TextBox();
			this.textBoxTitle = new System.Windows.Forms.TextBox();
			this.label1 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.label3 = new System.Windows.Forms.Label();
			this.textBoxMp3File = new System.Windows.Forms.TextBox();
			this.panel1 = new System.Windows.Forms.Panel();
			this.buttonParseCuesheet = new System.Windows.Forms.Button();
			this.label5 = new System.Windows.Forms.Label();
			this.textBoxCueSheetPath = new System.Windows.Forms.TextBox();
			this.pageSetupDialog1 = new System.Windows.Forms.PageSetupDialog();
			this.panel3 = new System.Windows.Forms.Panel();
			this.buttonChopTag = new System.Windows.Forms.Button();
			this.buttonSaveOverride = new System.Windows.Forms.Button();
			this.buttonRelativeSave = new System.Windows.Forms.Button();
			this.buttonTestCuesheet = new System.Windows.Forms.Button();
			this.buttonSaveCueAs = new System.Windows.Forms.Button();
			this.toolStrip1 = new System.Windows.Forms.ToolStrip();
			this.toolStripButton4 = new System.Windows.Forms.ToolStripButton();
			this.toolStripButton3 = new System.Windows.Forms.ToolStripButton();
			this.toolStripButton2 = new System.Windows.Forms.ToolStripButton();
			this.toolStripButton1 = new System.Windows.Forms.ToolStripButton();
			this.toolStripButton5 = new System.Windows.Forms.ToolStripButton();
			this.buttonParseTracklist = new System.Windows.Forms.Button();
			this.tabControlCuesheet = new System.Windows.Forms.TabControl();
			this.tabPage1 = new System.Windows.Forms.TabPage();
			this.tabPageParsedInput = new System.Windows.Forms.TabPage();
			this.dataGridViewParsedInput = new System.Windows.Forms.DataGridView();
			this.numberDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
			this.artistDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
			this.titleDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
			this.dataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
			this.trackBindingSource = new System.Windows.Forms.BindingSource(this.components);
			this.tabPageTimeInfo = new System.Windows.Forms.TabPage();
			this.vScrollBarTimeInformation = new System.Windows.Forms.VScrollBar();
			this.textBoxTimeInformation = new System.Windows.Forms.TextBox();
			this.tabPageCuesheet = new System.Windows.Forms.TabPage();
			this.vScrollBarCuesheet = new System.Windows.Forms.VScrollBar();
			this.textBoxCuesheetPreview = new System.Windows.Forms.TextBox();
			this.tabPageOutputWindow = new System.Windows.Forms.TabPage();
			this.textBoxOutputWindow = new System.Windows.Forms.TextBox();
			this.tabPage2 = new System.Windows.Forms.TabPage();
			this.button1 = new System.Windows.Forms.Button();
			this.elementHost1 = new System.Windows.Forms.Integration.ElementHost();
			this.timeline1 = new CuesheetCreator.Timeline();
			this.saveFileDialog1 = new System.Windows.Forms.SaveFileDialog();
			this.openFileDialogCueSheets = new System.Windows.Forms.OpenFileDialog();
			this.openFileDialogMp3 = new System.Windows.Forms.OpenFileDialog();
			this.panel4 = new System.Windows.Forms.Panel();
			this.folderBrowserDialog = new System.Windows.Forms.FolderBrowserDialog();
			this.panel1.SuspendLayout();
			this.panel3.SuspendLayout();
			this.toolStrip1.SuspendLayout();
			this.tabControlCuesheet.SuspendLayout();
			this.tabPage1.SuspendLayout();
			this.tabPageParsedInput.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.dataGridViewParsedInput)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.trackBindingSource)).BeginInit();
			this.tabPageTimeInfo.SuspendLayout();
			this.tabPageCuesheet.SuspendLayout();
			this.tabPageOutputWindow.SuspendLayout();
			this.tabPage2.SuspendLayout();
			this.panel4.SuspendLayout();
			this.SuspendLayout();
			// 
			// textBoxTracklist
			// 
			this.textBoxTracklist.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
						| System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.textBoxTracklist.BackColor = System.Drawing.Color.White;
			this.textBoxTracklist.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.textBoxTracklist.Font = new System.Drawing.Font("Consolas", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.textBoxTracklist.ForeColor = System.Drawing.Color.Black;
			this.textBoxTracklist.Location = new System.Drawing.Point(3, 3);
			this.textBoxTracklist.Multiline = true;
			this.textBoxTracklist.Name = "textBoxTracklist";
			this.textBoxTracklist.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
			this.textBoxTracklist.Size = new System.Drawing.Size(909, 511);
			this.textBoxTracklist.TabIndex = 1;
			this.textBoxTracklist.WordWrap = false;
			// 
			// textBoxArtist
			// 
			this.textBoxArtist.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.textBoxArtist.BackColor = System.Drawing.Color.White;
			this.textBoxArtist.Font = new System.Drawing.Font("Consolas", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.textBoxArtist.ForeColor = System.Drawing.Color.Black;
			this.textBoxArtist.Location = new System.Drawing.Point(60, 78);
			this.textBoxArtist.Name = "textBoxArtist";
			this.textBoxArtist.Size = new System.Drawing.Size(927, 26);
			this.textBoxArtist.TabIndex = 3;
			// 
			// textBoxTitle
			// 
			this.textBoxTitle.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.textBoxTitle.BackColor = System.Drawing.Color.White;
			this.textBoxTitle.Font = new System.Drawing.Font("Consolas", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.textBoxTitle.ForeColor = System.Drawing.Color.Black;
			this.textBoxTitle.Location = new System.Drawing.Point(60, 110);
			this.textBoxTitle.Name = "textBoxTitle";
			this.textBoxTitle.Size = new System.Drawing.Size(927, 26);
			this.textBoxTitle.TabIndex = 4;
			// 
			// label1
			// 
			this.label1.AutoSize = true;
			this.label1.Font = new System.Drawing.Font("Segoe UI", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.label1.ForeColor = System.Drawing.Color.Black;
			this.label1.Location = new System.Drawing.Point(11, 81);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(41, 17);
			this.label1.TabIndex = 4;
			this.label1.Text = "Artist:";
			// 
			// label2
			// 
			this.label2.AutoSize = true;
			this.label2.Font = new System.Drawing.Font("Segoe UI", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.label2.ForeColor = System.Drawing.Color.Black;
			this.label2.Location = new System.Drawing.Point(11, 113);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(35, 17);
			this.label2.TabIndex = 5;
			this.label2.Text = "Title:";
			// 
			// label3
			// 
			this.label3.AutoSize = true;
			this.label3.Font = new System.Drawing.Font("Segoe UI", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.label3.ForeColor = System.Drawing.Color.Black;
			this.label3.Location = new System.Drawing.Point(11, 49);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(30, 17);
			this.label3.TabIndex = 6;
			this.label3.Text = "File:";
			// 
			// textBoxMp3File
			// 
			this.textBoxMp3File.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.textBoxMp3File.BackColor = System.Drawing.Color.White;
			this.textBoxMp3File.Font = new System.Drawing.Font("Consolas", 12F);
			this.textBoxMp3File.ForeColor = System.Drawing.Color.Black;
			this.textBoxMp3File.Location = new System.Drawing.Point(60, 46);
			this.textBoxMp3File.Name = "textBoxMp3File";
			this.textBoxMp3File.Size = new System.Drawing.Size(927, 26);
			this.textBoxMp3File.TabIndex = 2;
			// 
			// panel1
			// 
			this.panel1.BackColor = System.Drawing.SystemColors.ButtonFace;
			this.panel1.Controls.Add(this.buttonParseCuesheet);
			this.panel1.Controls.Add(this.label5);
			this.panel1.Controls.Add(this.textBoxCueSheetPath);
			this.panel1.Controls.Add(this.textBoxTitle);
			this.panel1.Controls.Add(this.textBoxMp3File);
			this.panel1.Controls.Add(this.textBoxArtist);
			this.panel1.Controls.Add(this.label3);
			this.panel1.Controls.Add(this.label1);
			this.panel1.Controls.Add(this.label2);
			this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
			this.panel1.Font = new System.Drawing.Font("Consolas", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.panel1.Location = new System.Drawing.Point(0, 0);
			this.panel1.Name = "panel1";
			this.panel1.Size = new System.Drawing.Size(1006, 149);
			this.panel1.TabIndex = 8;
			// 
			// buttonParseCuesheet
			// 
			this.buttonParseCuesheet.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
			this.buttonParseCuesheet.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.buttonParseCuesheet.Image = ((System.Drawing.Image)(resources.GetObject("buttonParseCuesheet.Image")));
			this.buttonParseCuesheet.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
			this.buttonParseCuesheet.Location = new System.Drawing.Point(815, 15);
			this.buttonParseCuesheet.Name = "buttonParseCuesheet";
			this.buttonParseCuesheet.Size = new System.Drawing.Size(172, 24);
			this.buttonParseCuesheet.TabIndex = 30;
			this.buttonParseCuesheet.Text = "Load/Parse In Cuesheet";
			this.buttonParseCuesheet.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			this.buttonParseCuesheet.UseVisualStyleBackColor = true;
			this.buttonParseCuesheet.Click += new System.EventHandler(this.buttonParseCuesheet_Click);
			// 
			// label5
			// 
			this.label5.AutoSize = true;
			this.label5.Font = new System.Drawing.Font("Segoe UI", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.label5.ForeColor = System.Drawing.Color.Black;
			this.label5.Location = new System.Drawing.Point(11, 17);
			this.label5.Name = "label5";
			this.label5.Size = new System.Drawing.Size(33, 17);
			this.label5.TabIndex = 26;
			this.label5.Text = "Cue:";
			// 
			// textBoxCueSheetPath
			// 
			this.textBoxCueSheetPath.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.textBoxCueSheetPath.BackColor = System.Drawing.Color.White;
			this.textBoxCueSheetPath.Font = new System.Drawing.Font("Consolas", 12F);
			this.textBoxCueSheetPath.ForeColor = System.Drawing.Color.Black;
			this.textBoxCueSheetPath.Location = new System.Drawing.Point(60, 16);
			this.textBoxCueSheetPath.Name = "textBoxCueSheetPath";
			this.textBoxCueSheetPath.Size = new System.Drawing.Size(749, 26);
			this.textBoxCueSheetPath.TabIndex = 1;
			// 
			// panel3
			// 
			this.panel3.BackColor = System.Drawing.SystemColors.ButtonFace;
			this.panel3.Controls.Add(this.buttonChopTag);
			this.panel3.Controls.Add(this.buttonSaveOverride);
			this.panel3.Controls.Add(this.buttonRelativeSave);
			this.panel3.Controls.Add(this.buttonTestCuesheet);
			this.panel3.Controls.Add(this.buttonSaveCueAs);
			this.panel3.Dock = System.Windows.Forms.DockStyle.Bottom;
			this.panel3.Location = new System.Drawing.Point(0, 717);
			this.panel3.Name = "panel3";
			this.panel3.Size = new System.Drawing.Size(1006, 46);
			this.panel3.TabIndex = 20;
			// 
			// buttonChopTag
			// 
			this.buttonChopTag.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.buttonChopTag.Image = global::CuesheetCreator.Properties.Resources.grouped;
			this.buttonChopTag.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
			this.buttonChopTag.Location = new System.Drawing.Point(875, 11);
			this.buttonChopTag.Name = "buttonChopTag";
			this.buttonChopTag.Size = new System.Drawing.Size(121, 23);
			this.buttonChopTag.TabIndex = 26;
			this.buttonChopTag.Text = "Chop + Tag Media";
			this.buttonChopTag.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			this.buttonChopTag.UseVisualStyleBackColor = true;
			this.buttonChopTag.Click += new System.EventHandler(this.buttonChopTag_Click);
			// 
			// buttonSaveOverride
			// 
			this.buttonSaveOverride.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.buttonSaveOverride.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F);
			this.buttonSaveOverride.Image = global::CuesheetCreator.Properties.Resources.save;
			this.buttonSaveOverride.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
			this.buttonSaveOverride.Location = new System.Drawing.Point(376, 11);
			this.buttonSaveOverride.Name = "buttonSaveOverride";
			this.buttonSaveOverride.Size = new System.Drawing.Size(169, 23);
			this.buttonSaveOverride.TabIndex = 27;
			this.buttonSaveOverride.Text = "Overwrite Cuesheet In Place";
			this.buttonSaveOverride.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			this.buttonSaveOverride.UseVisualStyleBackColor = true;
			this.buttonSaveOverride.Click += new System.EventHandler(this.buttonSaveOverride_Click);
			// 
			// buttonRelativeSave
			// 
			this.buttonRelativeSave.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.buttonRelativeSave.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.buttonRelativeSave.Image = global::CuesheetCreator.Properties.Resources.save;
			this.buttonRelativeSave.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
			this.buttonRelativeSave.Location = new System.Drawing.Point(230, 11);
			this.buttonRelativeSave.Name = "buttonRelativeSave";
			this.buttonRelativeSave.Size = new System.Drawing.Size(140, 23);
			this.buttonRelativeSave.TabIndex = 24;
			this.buttonRelativeSave.Text = "Save in .\\Cuesheets\\";
			this.buttonRelativeSave.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			this.buttonRelativeSave.UseVisualStyleBackColor = true;
			this.buttonRelativeSave.Click += new System.EventHandler(this.buttonRelativeSave_Click);
			// 
			// buttonTestCuesheet
			// 
			this.buttonTestCuesheet.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.buttonTestCuesheet.Image = global::CuesheetCreator.Properties.Resources._00642;
			this.buttonTestCuesheet.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
			this.buttonTestCuesheet.Location = new System.Drawing.Point(692, 11);
			this.buttonTestCuesheet.Name = "buttonTestCuesheet";
			this.buttonTestCuesheet.Size = new System.Drawing.Size(177, 23);
			this.buttonTestCuesheet.TabIndex = 23;
			this.buttonTestCuesheet.Text = "Test Cuesheet (Shell Execute)";
			this.buttonTestCuesheet.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			this.buttonTestCuesheet.UseVisualStyleBackColor = true;
			this.buttonTestCuesheet.Click += new System.EventHandler(this.buttonTestCuesheet_Click);
			// 
			// buttonSaveCueAs
			// 
			this.buttonSaveCueAs.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.buttonSaveCueAs.Image = global::CuesheetCreator.Properties.Resources.save;
			this.buttonSaveCueAs.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
			this.buttonSaveCueAs.Location = new System.Drawing.Point(551, 11);
			this.buttonSaveCueAs.Name = "buttonSaveCueAs";
			this.buttonSaveCueAs.Size = new System.Drawing.Size(135, 23);
			this.buttonSaveCueAs.TabIndex = 18;
			this.buttonSaveCueAs.Text = "Save Cuesheet As...";
			this.buttonSaveCueAs.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
			this.buttonSaveCueAs.UseVisualStyleBackColor = true;
			this.buttonSaveCueAs.Click += new System.EventHandler(this.buttonSaveCueAs_Click);
			// 
			// toolStrip1
			// 
			this.toolStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden;
			this.toolStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripButton4,
            this.toolStripButton3,
            this.toolStripButton2,
            this.toolStripButton1,
            this.toolStripButton5});
			this.toolStrip1.Location = new System.Drawing.Point(3, 3);
			this.toolStrip1.Name = "toolStrip1";
			this.toolStrip1.RenderMode = System.Windows.Forms.ToolStripRenderMode.Professional;
			this.toolStrip1.Size = new System.Drawing.Size(959, 25);
			this.toolStrip1.TabIndex = 23;
			this.toolStrip1.Text = "toolStrip1";
			// 
			// toolStripButton4
			// 
			this.toolStripButton4.CheckOnClick = true;
			this.toolStripButton4.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
			this.toolStripButton4.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton4.Image")));
			this.toolStripButton4.ImageTransparentColor = System.Drawing.Color.Magenta;
			this.toolStripButton4.Name = "toolStripButton4";
			this.toolStripButton4.Size = new System.Drawing.Size(23, 22);
			this.toolStripButton4.Text = "Link all Indexes to the right";
			// 
			// toolStripButton3
			// 
			this.toolStripButton3.CheckOnClick = true;
			this.toolStripButton3.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
			this.toolStripButton3.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton3.Image")));
			this.toolStripButton3.ImageTransparentColor = System.Drawing.Color.Magenta;
			this.toolStripButton3.Name = "toolStripButton3";
			this.toolStripButton3.Size = new System.Drawing.Size(23, 22);
			this.toolStripButton3.Text = "Link all Indexes";
			// 
			// toolStripButton2
			// 
			this.toolStripButton2.CheckOnClick = true;
			this.toolStripButton2.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
			this.toolStripButton2.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton2.Image")));
			this.toolStripButton2.ImageTransparentColor = System.Drawing.Color.Magenta;
			this.toolStripButton2.Name = "toolStripButton2";
			this.toolStripButton2.Size = new System.Drawing.Size(23, 22);
			this.toolStripButton2.Text = "Link All Indexes To Left";
			// 
			// toolStripButton1
			// 
			this.toolStripButton1.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
			this.toolStripButton1.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton1.Image")));
			this.toolStripButton1.ImageTransparentColor = System.Drawing.Color.Magenta;
			this.toolStripButton1.Name = "toolStripButton1";
			this.toolStripButton1.Size = new System.Drawing.Size(23, 22);
			this.toolStripButton1.Text = "toolStripButton1";
			// 
			// toolStripButton5
			// 
			this.toolStripButton5.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
			this.toolStripButton5.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButton5.Image")));
			this.toolStripButton5.ImageTransparentColor = System.Drawing.Color.Magenta;
			this.toolStripButton5.Name = "toolStripButton5";
			this.toolStripButton5.Size = new System.Drawing.Size(23, 22);
			this.toolStripButton5.Text = "toolStripButton5";
			// 
			// buttonParseTracklist
			// 
			this.buttonParseTracklist.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
			this.buttonParseTracklist.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.buttonParseTracklist.Image = ((System.Drawing.Image)(resources.GetObject("buttonParseTracklist.Image")));
			this.buttonParseTracklist.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
			this.buttonParseTracklist.Location = new System.Drawing.Point(8, 518);
			this.buttonParseTracklist.Name = "buttonParseTracklist";
			this.buttonParseTracklist.Size = new System.Drawing.Size(261, 24);
			this.buttonParseTracklist.TabIndex = 20;
			this.buttonParseTracklist.Text = "Parse Tracklist && Load Index Markers";
			this.buttonParseTracklist.UseVisualStyleBackColor = true;
			this.buttonParseTracklist.Click += new System.EventHandler(this.buttonParseTracklist_Click);
			// 
			// tabControlCuesheet
			// 
			this.tabControlCuesheet.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
						| System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.tabControlCuesheet.Controls.Add(this.tabPage1);
			this.tabControlCuesheet.Controls.Add(this.tabPageParsedInput);
			this.tabControlCuesheet.Controls.Add(this.tabPageTimeInfo);
			this.tabControlCuesheet.Controls.Add(this.tabPageCuesheet);
			this.tabControlCuesheet.Controls.Add(this.tabPageOutputWindow);
			this.tabControlCuesheet.Controls.Add(this.tabPage2);
			this.tabControlCuesheet.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.tabControlCuesheet.Location = new System.Drawing.Point(14, 6);
			this.tabControlCuesheet.Name = "tabControlCuesheet";
			this.tabControlCuesheet.SelectedIndex = 0;
			this.tabControlCuesheet.Size = new System.Drawing.Size(973, 562);
			this.tabControlCuesheet.TabIndex = 21;
			this.tabControlCuesheet.Enter += new System.EventHandler(this.tabControlCuesheet_Enter);
			// 
			// tabPage1
			// 
			this.tabPage1.BackColor = System.Drawing.SystemColors.ButtonFace;
			this.tabPage1.Controls.Add(this.textBoxTracklist);
			this.tabPage1.Controls.Add(this.buttonParseTracklist);
			this.tabPage1.Location = new System.Drawing.Point(4, 25);
			this.tabPage1.Name = "tabPage1";
			this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
			this.tabPage1.Size = new System.Drawing.Size(965, 533);
			this.tabPage1.TabIndex = 0;
			this.tabPage1.Text = "Raw Input";
			// 
			// tabPageParsedInput
			// 
			this.tabPageParsedInput.Controls.Add(this.dataGridViewParsedInput);
			this.tabPageParsedInput.Location = new System.Drawing.Point(4, 25);
			this.tabPageParsedInput.Name = "tabPageParsedInput";
			this.tabPageParsedInput.Padding = new System.Windows.Forms.Padding(3);
			this.tabPageParsedInput.Size = new System.Drawing.Size(965, 533);
			this.tabPageParsedInput.TabIndex = 1;
			this.tabPageParsedInput.Text = "Editable Track Data";
			this.tabPageParsedInput.UseVisualStyleBackColor = true;
			// 
			// dataGridViewParsedInput
			// 
			this.dataGridViewParsedInput.AutoGenerateColumns = false;
			this.dataGridViewParsedInput.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
			this.dataGridViewParsedInput.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
			this.dataGridViewParsedInput.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.numberDataGridViewTextBoxColumn,
            this.artistDataGridViewTextBoxColumn,
            this.titleDataGridViewTextBoxColumn,
            this.dataGridViewTextBoxColumn1});
			this.dataGridViewParsedInput.DataSource = this.trackBindingSource;
			this.dataGridViewParsedInput.Dock = System.Windows.Forms.DockStyle.Fill;
			this.dataGridViewParsedInput.Location = new System.Drawing.Point(3, 3);
			this.dataGridViewParsedInput.Name = "dataGridViewParsedInput";
			this.dataGridViewParsedInput.Size = new System.Drawing.Size(959, 527);
			this.dataGridViewParsedInput.TabIndex = 0;
			// 
			// numberDataGridViewTextBoxColumn
			// 
			this.numberDataGridViewTextBoxColumn.DataPropertyName = "Number";
			this.numberDataGridViewTextBoxColumn.HeaderText = "Number";
			this.numberDataGridViewTextBoxColumn.Name = "numberDataGridViewTextBoxColumn";
			this.numberDataGridViewTextBoxColumn.Width = 81;
			// 
			// artistDataGridViewTextBoxColumn
			// 
			this.artistDataGridViewTextBoxColumn.DataPropertyName = "Artist";
			this.artistDataGridViewTextBoxColumn.HeaderText = "Artist";
			this.artistDataGridViewTextBoxColumn.Name = "artistDataGridViewTextBoxColumn";
			this.artistDataGridViewTextBoxColumn.Width = 62;
			// 
			// titleDataGridViewTextBoxColumn
			// 
			this.titleDataGridViewTextBoxColumn.DataPropertyName = "Title";
			this.titleDataGridViewTextBoxColumn.HeaderText = "Title";
			this.titleDataGridViewTextBoxColumn.Name = "titleDataGridViewTextBoxColumn";
			this.titleDataGridViewTextBoxColumn.Width = 59;
			// 
			// dataGridViewTextBoxColumn1
			// 
			this.dataGridViewTextBoxColumn1.DataPropertyName = "Position";
			this.dataGridViewTextBoxColumn1.HeaderText = "Position";
			this.dataGridViewTextBoxColumn1.Name = "dataGridViewTextBoxColumn1";
			this.dataGridViewTextBoxColumn1.Width = 81;
			// 
			// trackBindingSource
			// 
			this.trackBindingSource.DataSource = typeof(CuesheetCreator.Track);
			// 
			// tabPageTimeInfo
			// 
			this.tabPageTimeInfo.Controls.Add(this.vScrollBarTimeInformation);
			this.tabPageTimeInfo.Controls.Add(this.textBoxTimeInformation);
			this.tabPageTimeInfo.Location = new System.Drawing.Point(4, 25);
			this.tabPageTimeInfo.Name = "tabPageTimeInfo";
			this.tabPageTimeInfo.Padding = new System.Windows.Forms.Padding(3);
			this.tabPageTimeInfo.Size = new System.Drawing.Size(965, 533);
			this.tabPageTimeInfo.TabIndex = 2;
			this.tabPageTimeInfo.Text = "Time Information";
			this.tabPageTimeInfo.UseVisualStyleBackColor = true;
			// 
			// vScrollBarTimeInformation
			// 
			this.vScrollBarTimeInformation.Dock = System.Windows.Forms.DockStyle.Right;
			this.vScrollBarTimeInformation.LargeChange = 1;
			this.vScrollBarTimeInformation.Location = new System.Drawing.Point(945, 3);
			this.vScrollBarTimeInformation.Maximum = 0;
			this.vScrollBarTimeInformation.Name = "vScrollBarTimeInformation";
			this.vScrollBarTimeInformation.Size = new System.Drawing.Size(17, 527);
			this.vScrollBarTimeInformation.TabIndex = 1;
			this.vScrollBarTimeInformation.Scroll += new System.Windows.Forms.ScrollEventHandler(this.vScrollBarTimeInformation_Scroll);
			// 
			// textBoxTimeInformation
			// 
			this.textBoxTimeInformation.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
						| System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.textBoxTimeInformation.BackColor = System.Drawing.Color.White;
			this.textBoxTimeInformation.BorderStyle = System.Windows.Forms.BorderStyle.None;
			this.textBoxTimeInformation.Font = new System.Drawing.Font("Consolas", 12F);
			this.textBoxTimeInformation.ForeColor = System.Drawing.Color.Black;
			this.textBoxTimeInformation.Location = new System.Drawing.Point(0, 1);
			this.textBoxTimeInformation.Multiline = true;
			this.textBoxTimeInformation.Name = "textBoxTimeInformation";
			this.textBoxTimeInformation.ReadOnly = true;
			this.textBoxTimeInformation.Size = new System.Drawing.Size(933, 3047);
			this.textBoxTimeInformation.TabIndex = 0;
			this.textBoxTimeInformation.WordWrap = false;
			// 
			// tabPageCuesheet
			// 
			this.tabPageCuesheet.Controls.Add(this.vScrollBarCuesheet);
			this.tabPageCuesheet.Controls.Add(this.textBoxCuesheetPreview);
			this.tabPageCuesheet.Location = new System.Drawing.Point(4, 25);
			this.tabPageCuesheet.Name = "tabPageCuesheet";
			this.tabPageCuesheet.Padding = new System.Windows.Forms.Padding(3);
			this.tabPageCuesheet.Size = new System.Drawing.Size(965, 533);
			this.tabPageCuesheet.TabIndex = 3;
			this.tabPageCuesheet.Text = "Cuesheet Preview";
			this.tabPageCuesheet.UseVisualStyleBackColor = true;
			this.tabPageCuesheet.Enter += new System.EventHandler(this.tabPageCuesheet_Enter);
			// 
			// vScrollBarCuesheet
			// 
			this.vScrollBarCuesheet.Dock = System.Windows.Forms.DockStyle.Right;
			this.vScrollBarCuesheet.Location = new System.Drawing.Point(945, 3);
			this.vScrollBarCuesheet.Name = "vScrollBarCuesheet";
			this.vScrollBarCuesheet.Size = new System.Drawing.Size(17, 527);
			this.vScrollBarCuesheet.TabIndex = 3;
			this.vScrollBarCuesheet.Scroll += new System.Windows.Forms.ScrollEventHandler(this.vScrollBarCuesheet_Scroll);
			// 
			// textBoxCuesheetPreview
			// 
			this.textBoxCuesheetPreview.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
						| System.Windows.Forms.AnchorStyles.Right)));
			this.textBoxCuesheetPreview.BackColor = System.Drawing.Color.White;
			this.textBoxCuesheetPreview.BorderStyle = System.Windows.Forms.BorderStyle.None;
			this.textBoxCuesheetPreview.Font = new System.Drawing.Font("Consolas", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.textBoxCuesheetPreview.ForeColor = System.Drawing.Color.Black;
			this.textBoxCuesheetPreview.Location = new System.Drawing.Point(3, 0);
			this.textBoxCuesheetPreview.Multiline = true;
			this.textBoxCuesheetPreview.Name = "textBoxCuesheetPreview";
			this.textBoxCuesheetPreview.ReadOnly = true;
			this.textBoxCuesheetPreview.Size = new System.Drawing.Size(912, 4003);
			this.textBoxCuesheetPreview.TabIndex = 2;
			this.textBoxCuesheetPreview.WordWrap = false;
			// 
			// tabPageOutputWindow
			// 
			this.tabPageOutputWindow.Controls.Add(this.textBoxOutputWindow);
			this.tabPageOutputWindow.Location = new System.Drawing.Point(4, 25);
			this.tabPageOutputWindow.Name = "tabPageOutputWindow";
			this.tabPageOutputWindow.Padding = new System.Windows.Forms.Padding(3);
			this.tabPageOutputWindow.Size = new System.Drawing.Size(965, 533);
			this.tabPageOutputWindow.TabIndex = 4;
			this.tabPageOutputWindow.Text = "Output Window";
			this.tabPageOutputWindow.UseVisualStyleBackColor = true;
			// 
			// textBoxOutputWindow
			// 
			this.textBoxOutputWindow.Dock = System.Windows.Forms.DockStyle.Fill;
			this.textBoxOutputWindow.Font = new System.Drawing.Font("Consolas", 12F);
			this.textBoxOutputWindow.Location = new System.Drawing.Point(3, 3);
			this.textBoxOutputWindow.Multiline = true;
			this.textBoxOutputWindow.Name = "textBoxOutputWindow";
			this.textBoxOutputWindow.ScrollBars = System.Windows.Forms.ScrollBars.Both;
			this.textBoxOutputWindow.Size = new System.Drawing.Size(959, 527);
			this.textBoxOutputWindow.TabIndex = 0;
			this.textBoxOutputWindow.WordWrap = false;
			// 
			// tabPage2
			// 
			this.tabPage2.Controls.Add(this.button1);
			this.tabPage2.Controls.Add(this.toolStrip1);
			this.tabPage2.Controls.Add(this.elementHost1);
			this.tabPage2.Location = new System.Drawing.Point(4, 25);
			this.tabPage2.Name = "tabPage2";
			this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
			this.tabPage2.Size = new System.Drawing.Size(965, 533);
			this.tabPage2.TabIndex = 5;
			this.tabPage2.Text = "Timeline View";
			this.tabPage2.UseVisualStyleBackColor = true;
			// 
			// button1
			// 
			this.button1.Location = new System.Drawing.Point(821, 481);
			this.button1.Name = "button1";
			this.button1.Size = new System.Drawing.Size(111, 23);
			this.button1.TabIndex = 24;
			this.button1.Text = "Force Focus";
			this.button1.UseVisualStyleBackColor = true;
			this.button1.Click += new System.EventHandler(this.button1_Click);
			// 
			// elementHost1
			// 
			this.elementHost1.BackColor = System.Drawing.Color.White;
			this.elementHost1.Dock = System.Windows.Forms.DockStyle.Fill;
			this.elementHost1.Location = new System.Drawing.Point(3, 3);
			this.elementHost1.Name = "elementHost1";
			this.elementHost1.Size = new System.Drawing.Size(959, 527);
			this.elementHost1.TabIndex = 5;
			this.elementHost1.Text = "elementHost1";
			this.elementHost1.Child = this.timeline1;
			// 
			// openFileDialogCueSheets
			// 
			this.openFileDialogCueSheets.Filter = "CueSheets|*.cue";
			// 
			// openFileDialogMp3
			// 
			this.openFileDialogMp3.Filter = "MP3 Files|*.mp3";
			// 
			// panel4
			// 
			this.panel4.BackColor = System.Drawing.SystemColors.ButtonFace;
			this.panel4.Controls.Add(this.tabControlCuesheet);
			this.panel4.Dock = System.Windows.Forms.DockStyle.Fill;
			this.panel4.Location = new System.Drawing.Point(0, 149);
			this.panel4.Name = "panel4";
			this.panel4.Size = new System.Drawing.Size(1006, 568);
			this.panel4.TabIndex = 2;
			// 
			// FormMain
			// 
			this.AllowDrop = true;
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(1006, 763);
			this.Controls.Add(this.panel4);
			this.Controls.Add(this.panel1);
			this.Controls.Add(this.panel3);
			this.DoubleBuffered = true;
			this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.MinimumSize = new System.Drawing.Size(972, 721);
			this.Name = "FormMain";
			this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Show;
			this.Text = "Liveset Cuesheet Creator/Editor";
			this.DragDrop += new System.Windows.Forms.DragEventHandler(this.FormMain_DragDrop);
			this.DragEnter += new System.Windows.Forms.DragEventHandler(this.FormMain_DragEnter);
			this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.FormMain_FormClosing);
			this.Resize += new System.EventHandler(this.FormMain_Resize);
			this.panel1.ResumeLayout(false);
			this.panel1.PerformLayout();
			this.panel3.ResumeLayout(false);
			this.toolStrip1.ResumeLayout(false);
			this.toolStrip1.PerformLayout();
			this.tabControlCuesheet.ResumeLayout(false);
			this.tabPage1.ResumeLayout(false);
			this.tabPage1.PerformLayout();
			this.tabPageParsedInput.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)(this.dataGridViewParsedInput)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.trackBindingSource)).EndInit();
			this.tabPageTimeInfo.ResumeLayout(false);
			this.tabPageTimeInfo.PerformLayout();
			this.tabPageCuesheet.ResumeLayout(false);
			this.tabPageCuesheet.PerformLayout();
			this.tabPageOutputWindow.ResumeLayout(false);
			this.tabPageOutputWindow.PerformLayout();
			this.tabPage2.ResumeLayout(false);
			this.tabPage2.PerformLayout();
			this.panel4.ResumeLayout(false);
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.TextBox textBoxTracklist;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.TextBox textBoxTitle;
		private System.Windows.Forms.TextBox textBoxArtist;
		private System.Windows.Forms.Panel panel1;
		private System.Windows.Forms.TextBox textBoxMp3File;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.PageSetupDialog pageSetupDialog1;
		private System.Windows.Forms.Button buttonSaveCueAs;
		private System.Windows.Forms.Panel panel3;
		private System.Windows.Forms.Button buttonParseTracklist;
		private System.Windows.Forms.TabControl tabControlCuesheet;
		private System.Windows.Forms.TabPage tabPage1;
		private System.Windows.Forms.TabPage tabPageParsedInput;
		private System.Windows.Forms.SaveFileDialog saveFileDialog1;
		private System.Windows.Forms.Button buttonTestCuesheet;
		private System.Windows.Forms.TabPage tabPageTimeInfo;
		private System.Windows.Forms.Button buttonSaveOverride;
		private System.Windows.Forms.Label label5;
		private System.Windows.Forms.TextBox textBoxCueSheetPath;
		private System.Windows.Forms.Button buttonRelativeSave;
		private System.Windows.Forms.Button buttonParseCuesheet;
		private System.Windows.Forms.TextBox textBoxTimeInformation;
		private System.Windows.Forms.OpenFileDialog openFileDialogCueSheets;
		private System.Windows.Forms.OpenFileDialog openFileDialogMp3;
		private System.Windows.Forms.Button buttonChopTag;
		private System.Windows.Forms.Panel panel4;
		private System.Windows.Forms.TabPage tabPageCuesheet;
		private System.Windows.Forms.DataGridView dataGridViewParsedInput;
		private System.Windows.Forms.DataGridViewTextBoxColumn positionDataGridViewTextBoxColumn;
		private System.Windows.Forms.TextBox textBoxCuesheetPreview;
		private System.Windows.Forms.VScrollBar vScrollBarTimeInformation;
		private System.Windows.Forms.VScrollBar vScrollBarCuesheet;
		private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog;
		private System.Windows.Forms.TabPage tabPageOutputWindow;
		private System.Windows.Forms.TextBox textBoxOutputWindow;
		private System.Windows.Forms.ToolStrip toolStrip1;
		private System.Windows.Forms.ToolStripButton toolStripButton2;
		private System.Windows.Forms.ToolStripButton toolStripButton3;
		private System.Windows.Forms.ToolStripButton toolStripButton4;
		private System.Windows.Forms.DataGridViewTextBoxColumn numberDataGridViewTextBoxColumn;
		private System.Windows.Forms.DataGridViewTextBoxColumn artistDataGridViewTextBoxColumn;
		private System.Windows.Forms.DataGridViewTextBoxColumn titleDataGridViewTextBoxColumn;
		private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn1;
		private System.Windows.Forms.BindingSource trackBindingSource;
		private System.Windows.Forms.ToolStripButton toolStripButton1;
		private System.Windows.Forms.ToolStripButton toolStripButton5;
		private System.Windows.Forms.TabPage tabPage2;
		private System.Windows.Forms.Integration.ElementHost elementHost1;
		private Timeline timeline1;
		private System.Windows.Forms.Button button1;
	}
}

