import 'package:pdf/pdf.dart';

/// Nominal pixels-per-inch used *only* to translate a prepared raster's own
/// pixel dimensions into PDF MediaBox points (1 point == 1/72 inch).
///
/// This is not a claim about the physical scanning DPI, and it never causes
/// a page to be resized to a physical paper size (e.g. A4) — the resulting
/// MediaBox always has exactly the raster's own aspect ratio.
const double kNominalPdfPixelsPerInch = 300;

/// Builds a marginless [PdfPageFormat] whose aspect ratio exactly matches a
/// prepared raster of [pixelWidth]x[pixelHeight], using [pixelsPerInch] only
/// to establish sensible absolute MediaBox metadata (in points).
PdfPageFormat pdfPageFormatForRaster(
  int pixelWidth,
  int pixelHeight, {
  double pixelsPerInch = kNominalPdfPixelsPerInch,
}) {
  assert(pixelWidth > 0 && pixelHeight > 0);
  assert(pixelsPerInch > 0);
  return PdfPageFormat(
    pixelWidth / pixelsPerInch * PdfPageFormat.inch,
    pixelHeight / pixelsPerInch * PdfPageFormat.inch,
    marginAll: 0,
  );
}
