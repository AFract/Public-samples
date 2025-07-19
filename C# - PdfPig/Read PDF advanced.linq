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
  <Namespace>UglyToad.PdfPig.Util</Namespace>
</Query>

var sb = new StringBuilder();

using (var document = PdfDocument.Open(@"T:\Input.pdf"))
{
	//foreach (var page in document.GetPages())
	var page = document.GetPage(2);
	//page.Rotation .Dump();

	// 0. Preprocessing
	var letters = page.Letters; // no preprocessing

	// 1. Extract words
	//var wordExtractor = NearestNeighbourWordExtractor.Instance;.
	var wordExtractorOptions = new NearestNeighbourWordExtractor.NearestNeighbourWordExtractorOptions()
	{
		Filter = (pivot, candidate) =>
		{
			// check if white space (default implementation of 'Filter')
			if (string.IsNullOrWhiteSpace(candidate.Value))
			{
				// pivot and candidate letters cannot belong to the same word 
				// if candidate letter is null or white space.
				// ('FilterPivot' already checks if the pivot is null or white space by default)
				return false;
			}

			// check for height difference
			var maxHeight = Math.Max(pivot.PointSize, candidate.PointSize);
			var minHeight = Math.Min(pivot.PointSize, candidate.PointSize);
			if (minHeight != 0 && maxHeight / minHeight > 2.0)
			{
				// pivot and candidate letters cannot belong to the same word 
				// if one letter is more than twice the size of the other.
				return false;
			}

			// check for colour difference
			var pivotRgb = pivot.Color.ToRGBValues();
			var candidateRgb = candidate.Color.ToRGBValues();
			if (!pivotRgb.Equals(candidateRgb))
			{
				// pivot and candidate letters cannot belong to the same word 
				// if they don't have the same colour.
				return false;
			}

			return true;
		}
	};

	//var wordExtractor = new NearestNeighbourWordExtractor(wordExtractorOptions);
	var wordExtractor = NearestNeighbourWordExtractor.Instance;
	//var wordExtractor = DefaultWordExtractor.Instance;

	var words = wordExtractor.GetWords(letters);

	// 2. Segment page
	var pageSegmenter = DocstrumBoundingBoxes.Instance;
	//		var pageSegmenterOptions = new DocstrumBoundingBoxes.DocstrumBoundingBoxesOptions()
	//		{
	//
	//		};

	//var pageSegmenter = DefaultPageSegmenter.Instance;
	var textBlocks = pageSegmenter.GetBlocks(words/*, pageSegmenterOptions*/);

	// 3. Postprocessing
	var readingOrder = UnsupervisedReadingOrderDetector.Instance;
	var orderedTextBlocks = readingOrder.Get(textBlocks);

	// 4. Extract text
	foreach (var block in orderedTextBlocks)
	{
		block.Text.Dump();

		sb.Append(block.Text.Normalize(NormalizationForm.FormKC)); // normalise text
		sb.AppendLine();
	}

	sb.AppendLine();

}

//Console.WriteLine(sb.ToString());


