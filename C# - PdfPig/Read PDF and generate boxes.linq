<Query Kind="Statements">
  <NuGetReference>PdfPig</NuGetReference>
  <Namespace>UglyToad.PdfPig</Namespace>
  <Namespace>UglyToad.PdfPig.Content</Namespace>
  <Namespace>UglyToad.PdfPig.XObjects</Namespace>
  <Namespace>System.Drawing</Namespace>
  <Namespace>UglyToad.PdfPig.Writer</Namespace>
  <Namespace>UglyToad.PdfPig.Fonts.Standard14Fonts</Namespace>
  <Namespace>UglyToad.PdfPig.DocumentLayoutAnalysis.WordExtractor</Namespace>
  <Namespace>UglyToad.PdfPig.DocumentLayoutAnalysis.PageSegmenter</Namespace>
  <Namespace>UglyToad.PdfPig.DocumentLayoutAnalysis.ReadingOrderDetector</Namespace>
</Query>

//using UglyToad.PdfPig.DocumentLayoutAnalysis.PageSegmenter;
//using UglyToad.PdfPig.DocumentLayoutAnalysis.ReadingOrderDetector;
//using UglyToad.PdfPig.DocumentLayoutAnalysis.WordExtractor;
//using UglyToad.PdfPig.Fonts.Standard14Fonts;

var sourcePdfPath = "";
var outputPath = "T:\\test.pdf";
var pageNumber = 1;
using (var document = PdfDocument.Open(@"T:\Input.pdf"))
{
	var builder = new PdfDocumentBuilder { };
	PdfDocumentBuilder.AddedFont font = builder.AddStandard14Font(Standard14Font.Helvetica);
	var pageBuilder = builder.AddPage(document, pageNumber);
	pageBuilder.SetStrokeColor(0, 255, 0);
	var page = document.GetPage(pageNumber);

	var letters = page.Letters; // no preprocessing

	// 1. Extract words
	var wordExtractor = NearestNeighbourWordExtractor.Instance;

	var words = wordExtractor.GetWords(letters);

	// 2. Segment page
	var pageSegmenter = DocstrumBoundingBoxes.Instance;

	var textBlocks = pageSegmenter.GetBlocks(words);

	textBlocks.Select(t => t.Text).Dump();

	// 3. Postprocessing
	var readingOrder = UnsupervisedReadingOrderDetector.Instance;
	var orderedTextBlocks = readingOrder.Get(textBlocks);

	orderedTextBlocks.Select(t => t.Text).Dump();

	// 4. Add debug info - Bounding boxes and reading order
	foreach (var block in orderedTextBlocks)
	{
		//block.Text.Dump();

		var bbox = block.BoundingBox;
		pageBuilder.DrawRectangle(bbox.BottomLeft, (decimal)bbox.Width, (decimal)bbox.Height);
		//pageBuilder.AddText(block.ReadingOrder.ToString(), 8, bbox.TopLeft, font);
	}

	// 5. Write result to a file
	byte[] fileBytes = builder.Build();
	File.WriteAllBytes(outputPath, fileBytes); // save to file
}