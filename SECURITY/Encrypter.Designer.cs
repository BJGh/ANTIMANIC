
namespace RansomwarePOC
{
    partial class Form1
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.lblCount = new System.Windows.Forms.Label();
            this.lblBitcoinAmount = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.txtBitcoinAddress = new System.Windows.Forms.TextBox();
            this.txtEmailAddress = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.label5 = new System.Windows.Forms.Label();
            this.richTextBox1 = new System.Windows.Forms.RichTextBox();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // lblCount
            // 
            this.lblCount.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.lblCount.Font = new System.Drawing.Font("Microsoft Sans Serif", 27.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblCount.ForeColor = System.Drawing.Color.White;
            this.lblCount.Location = new System.Drawing.Point(16, 523);
            this.lblCount.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblCount.Name = "lblCount";
            this.lblCount.Size = new System.Drawing.Size(1219, 68);
            this.lblCount.TabIndex = 0;
            this.lblCount.Text = "Танай файлнууд(amount: n) шифрлэх тээ!";
            this.lblCount.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lblBitcoinAmount
            // 
            this.lblBitcoinAmount.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.lblBitcoinAmount.Font = new System.Drawing.Font("Microsoft Sans Serif", 24F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblBitcoinAmount.ForeColor = System.Drawing.Color.White;
            this.lblBitcoinAmount.Location = new System.Drawing.Point(16, 698);
            this.lblBitcoinAmount.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblBitcoinAmount.Name = "lblBitcoinAmount";
            this.lblBitcoinAmount.Size = new System.Drawing.Size(1219, 68);
            this.lblBitcoinAmount.TabIndex = 1;
            this.lblBitcoinAmount.Text = " n Dogecoin(s) хэрэгтэй BTC address эльгээжэ:";
            this.lblBitcoinAmount.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label2
            // 
            this.label2.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 24F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.Color.White;
            this.label2.Location = new System.Drawing.Point(16, 827);
            this.label2.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(1219, 68);
            this.label2.TabIndex = 2;
            this.label2.Text = "Next, E-mail your transaction ID to the following address:";
            this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // txtBitcoinAddress
            // 
            this.txtBitcoinAddress.Anchor = System.Windows.Forms.AnchorStyles.Bottom;
            this.txtBitcoinAddress.Font = new System.Drawing.Font("Microsoft Sans Serif", 24F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtBitcoinAddress.Location = new System.Drawing.Point(181, 769);
            this.txtBitcoinAddress.Margin = new System.Windows.Forms.Padding(4);
            this.txtBitcoinAddress.Name = "txtBitcoinAddress";
            this.txtBitcoinAddress.ReadOnly = true;
            this.txtBitcoinAddress.Size = new System.Drawing.Size(901, 53);
            this.txtBitcoinAddress.TabIndex = 3;
            this.txtBitcoinAddress.Text = "1BtUL5dhVXHwKLqSdhjyjK9Pe64Vc6CEH1";
            this.txtBitcoinAddress.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // txtEmailAddress
            // 
            this.txtEmailAddress.Anchor = System.Windows.Forms.AnchorStyles.Bottom;
            this.txtEmailAddress.Font = new System.Drawing.Font("Microsoft Sans Serif", 24F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txtEmailAddress.Location = new System.Drawing.Point(181, 898);
            this.txtEmailAddress.Margin = new System.Windows.Forms.Padding(4);
            this.txtEmailAddress.Name = "txtEmailAddress";
            this.txtEmailAddress.ReadOnly = true;
            this.txtEmailAddress.Size = new System.Drawing.Size(901, 53);
            this.txtEmailAddress.TabIndex = 4;
            this.txtEmailAddress.Text = "friendly.cyber.criminal@gmail.com";
            this.txtEmailAddress.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // label3
            // 
            this.label3.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 27.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.ForeColor = System.Drawing.Color.White;
            this.label3.Location = new System.Drawing.Point(16, 591);
            this.label3.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(1219, 107);
            this.label3.TabIndex = 5;
            this.label3.Text = "Тайлах тулоо...";
            this.label3.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // 
            // pictureBox1
            // 
            this.pictureBox1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.pictureBox1.Image = ((System.Drawing.Image)(resources.GetObject("pictureBox1.Image")));
            this.pictureBox1.Location = new System.Drawing.Point(13, 13);
            this.pictureBox1.Margin = new System.Windows.Forms.Padding(4);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(205, 276);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pictureBox1.TabIndex = 6;
            this.pictureBox1.TabStop = false;
            // 
            // label5
            // 
            this.label5.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 24F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.ForeColor = System.Drawing.Color.Crimson;
            this.label5.Location = new System.Drawing.Point(16, 956);
            this.label5.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(1219, 87);
            this.label5.TabIndex = 8;
            this.label5.Text = ".";
            this.label5.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // richTextBox1
            // 
            this.richTextBox1.Location = new System.Drawing.Point(273, 37);
            this.richTextBox1.Name = "richTextBox1";
            this.richTextBox1.Size = new System.Drawing.Size(923, 483);
            this.richTextBox1.TabIndex = 9;
            this.richTextBox1.Text = resources.GetString("richTextBox1.Text");
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Crimson;
            this.ClientSize = new System.Drawing.Size(1251, 1055);
            this.Controls.Add(this.richTextBox1);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.txtEmailAddress);
            this.Controls.Add(this.txtBitcoinAddress);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.lblBitcoinAmount);
            this.Controls.Add(this.lblCount);
            this.Controls.Add(this.pictureBox1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.SizableToolWindow;
            this.Margin = new System.Windows.Forms.Padding(4);
            this.Name = "Form1";
            this.Text = "WannaCry by Burin-Zhargal Papaev";
            this.WindowState = System.Windows.Forms.FormWindowState.Minimized;
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblCount;
        private System.Windows.Forms.Label lblBitcoinAmount;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtBitcoinAddress;
        private System.Windows.Forms.TextBox txtEmailAddress;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.RichTextBox richTextBox1;
    }
}

