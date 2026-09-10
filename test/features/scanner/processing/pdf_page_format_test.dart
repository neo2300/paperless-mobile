import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/pdf.dart';
import 'package:paperless_mobile/features/scanner/processing/pdf_page_format.dart';

void main() {
  test(
    'derives a marginless MediaBox matching the raster aspect ratio using '
    'the nominal pixels-per-inch, without forcing any physical paper size',
    () {
      final format = pdfPageFormatForRaster(3000, 2000);

      // width/height in points == pixels / dpi * 72.
      final expectedWidth =
          3000 / kNominalPdfPixelsPerInch * PdfPageFormat.inch;
      final expectedHeight =
          2000 / kNominalPdfPixelsPerInch * PdfPageFormat.inch;

      expect(format.width, closeTo(expectedWidth, 1e-9));
      expect(format.height, closeTo(expectedHeight, 1e-9));

      // Aspect ratio matches the raster's own aspect ratio exactly, not
      // A4 (or any other fixed paper size).
      expect(format.width / format.height, closeTo(3000 / 2000, 1e-9));
      expect(format.width / format.height, isNot(closeTo(210 / 297, 0.01)));
    },
  );

  test('is marginless', () {
    final format = pdfPageFormatForRaster(1000, 1000);
    expect(format.marginLeft, 0);
    expect(format.marginTop, 0);
    expect(format.marginRight, 0);
    expect(format.marginBottom, 0);
  });

  test('preserves a portrait raster aspect ratio (taller than wide)', () {
    final format = pdfPageFormatForRaster(1000, 4000);
    expect(format.width / format.height, closeTo(1000 / 4000, 1e-9));
  });

  test('preserves a landscape raster aspect ratio (wider than tall)', () {
    final format = pdfPageFormatForRaster(4000, 1000);
    expect(format.width / format.height, closeTo(4000 / 1000, 1e-9));
  });

  test('respects a custom nominal pixels-per-inch', () {
    final format = pdfPageFormatForRaster(1200, 600, pixelsPerInch: 150);
    expect(format.width, closeTo(1200 / 150 * PdfPageFormat.inch, 1e-9));
    expect(format.height, closeTo(600 / 150 * PdfPageFormat.inch, 1e-9));
  });
}
