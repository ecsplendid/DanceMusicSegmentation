using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;

namespace EdmSetManagement.Core.CuesheetTools.Downloading
{
	public class WebDownloader
	{
		public static string DownloadUrl(string url, string referrer, string useragent) {

			return DownloadUrlVerbose(url, referrer, useragent, true, true).html;
		}
	
		public static WebDownloaderResult DownloadUrlVerbose(string url, string referrer, string useragent, bool autoredirect, bool defaultEncoding)
		{
			using (WebClient wcDownload = new WebClient())
			{
				// Create a request to the file we are downloading
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
				request.KeepAlive = true;
				request.Referer = referrer;
				request.UserAgent = useragent;
				request.AllowAutoRedirect = autoredirect;
				
				// Set default authentication for retrieving the file
				request.Credentials = CredentialCache.DefaultCredentials;
				// Retrieve the response from the server
				
				HttpWebResponse response = (HttpWebResponse)request.GetResponse();
				
				WebDownloaderResult result = new WebDownloaderResult{ Code = response.StatusCode };

				string exceptionResponseString = string.Empty;
				if (response != null)
				{
					using (Stream respStream = response.GetResponseStream())
					{
						StreamReader textReader = null;

						if (defaultEncoding) {
							textReader = new StreamReader(respStream, Encoding.Default);
						}
						else {
							textReader = new StreamReader(respStream);
						}
						
						using (textReader)
						{
							exceptionResponseString = textReader.ReadToEnd();
						}
					}
				}
				
				response.Close();
				
				result.html = exceptionResponseString;

				return result;
			}
		}
		
		public class WebDownloaderResult {
			public HttpStatusCode Code;
			public string html;
		}
	
	}
}
