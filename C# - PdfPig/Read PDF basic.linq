<Query Kind="Statements">
  <NuGetReference>PdfPig</NuGetReference>
  <Namespace>UglyToad.PdfPig</Namespace>
  <Namespace>UglyToad.PdfPig.Content</Namespace>
  <Namespace>UglyToad.PdfPig.XObjects</Namespace>
  <Namespace>System.Drawing</Namespace>
</Query>

using (PdfDocument document = PdfDocument.Open(@"T:\Input.pdf"))
{
	foreach (Page page in document.GetPages())
	{
		if(page.Number != 23)
		{
			//continue;			
		}
		string pageText = page.Text;

		foreach (var item in page.GetWords())				
		{
			Console.WriteLine(item.Text);
		}

		foreach (var item in page.GetImages())
		{
		  var bytes = ((XObjectImage)item).RawBytes.ToArray();
			MemoryStream ms = new MemoryStream(bytes);	
			ms.Flush();
		  //var bmp = Image.FromStream(ms);
		  //bmp.Dump();
		}
	}
}