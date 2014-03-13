using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace WaveReaderDLL
{
	public class WaveReader
	{
		private static readonly int BitsPerByte = 8;
		private static readonly int MaxBits = 8;
		public Int32[][] Data { get; private set; }
		public int CompressionCode { get; private set; }
		public int NumberOfChannels { get; private set; }
		public int SampleRate { get; private set; }
		public int BytesPerSecond { get; private set; }
		public int BitsPerSample { get; private set; }
		public int BlockAlign { get; private set; }
		public int Frames { get; private set; }
		public double TimeLength { get; private set; }

		/// <summary>
		/// Reads a Wave file from the input stream, but doesn't close the stream
		/// </summary>
		/// <param name="stream">Input WAVE file stream</param>
		public WaveReader(Stream stream)
		{
			using (BinaryReader binaryReader = new BinaryReader(stream))
			{
				binaryReader.ReadChars(4); //"RIFF"
				int length = binaryReader.ReadInt32();
				binaryReader.ReadChars(4); //"WAVE"
				string chunkName = new string(binaryReader.ReadChars(4)); //"fmt "
				int chunkLength = binaryReader.ReadInt32();
				this.CompressionCode = binaryReader.ReadInt16(); //1 for PCM/uncompressed
				this.NumberOfChannels = binaryReader.ReadInt16();
				this.SampleRate = binaryReader.ReadInt32();
				this.BytesPerSecond = binaryReader.ReadInt32();
				this.BlockAlign = binaryReader.ReadInt16();
				this.BitsPerSample = binaryReader.ReadInt16();
				if ((MaxBits % BitsPerSample) != 0)
				{
					throw new Exception("The input stream uses an unhandled SignificantBitsPerSample parameter");
				}
				binaryReader.ReadChars(chunkLength - 16);
				chunkName = new string(binaryReader.ReadChars(4));
				try
				{
					while (chunkName.ToLower() != "data")
					{
						binaryReader.ReadChars(binaryReader.ReadInt32());
						chunkName = new string(binaryReader.ReadChars(4));
					}
				}
				catch
				{
					throw new Exception("Input stream misses the data chunk");
				}
				chunkLength = binaryReader.ReadInt32();
				this.Frames = 8 * chunkLength / this.BitsPerSample / this.NumberOfChannels;
				this.TimeLength = ((double)this.Frames) / ((double)this.SampleRate);
				this.Data = new Int32[this.NumberOfChannels][];
				for (int channel = 0; channel < this.NumberOfChannels; channel++)
				{
					this.Data[channel] = new Int32[this.Frames];
				}
				int readedBits = 0;
				int numberOfReadedBits = 0;
				for (int frame = 0; frame < this.Frames; frame++)
				{
					for (int channel = 0; channel < this.NumberOfChannels; channel++)
					{
						while (numberOfReadedBits < this.BitsPerSample)
						{
							readedBits |= Convert.ToInt32(binaryReader.ReadByte()) << numberOfReadedBits;
							numberOfReadedBits += BitsPerByte;
						}
						int numberOfExcessBits = numberOfReadedBits - BitsPerSample;
						this.Data[channel][frame] = readedBits >> numberOfExcessBits;
						readedBits = readedBits % (1 << numberOfExcessBits);
						numberOfReadedBits = numberOfExcessBits;
					}
				}
			}
		}
	}
}