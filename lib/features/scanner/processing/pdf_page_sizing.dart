import 'dart:math' as math;
import 'dart:ui';

/// Approximate maximum pixel budget for a single rasterized PDF page.
///
/// This intentionally sits in the ~8.7–9.0 megapixel range. The commonly
/// cited rationale is "A4 at roughly 300 DPI" (2481×3508 ≈ 8.7 MP), but that
/// is size *rationale* only — this budget is not a physical DPI guarantee
/// and pages are never resized to a physical paper size (see
/// [pdf_page_format.dart] for how the *nominal* DPI is used only to derive
/// PDF MediaBox metadata from the raster's own pixel size).
const double kMaxPdfPagePixelBudget = 8.8e6;

/// Aspect ratio (long edge / short edge) at or above which an over-budget
/// page is considered "extreme" long/narrow (e.g. a receipt or banner) and
/// therefore a candidate for segmentation instead of a simple proportional
/// downscale. Ordinary portrait/landscape pages stay well under this ratio
/// and are only ever downscaled as a whole, never split.
const double kExtremePdfPageAspectRatio = 3.0;

/// Minimum long-axis segment length (in source pixels) used when splitting
/// an extreme long/narrow page.
///
/// Without a floor, a very large short edge combined with an extreme aspect
/// ratio could mathematically demand a tiny (or zero) long-axis segment
/// length to keep every segment under [kMaxPdfPagePixelBudget]. This floor
/// keeps the number of segments sane; in that rare situation an individual
/// segment may end up slightly over-budget and receive its own additional
/// proportional downscale (still never upscaled).
const double kMinPdfPageSegmentLongEdge = 900;

/// Fractional overlap (relative to a segment's long-axis length) applied
/// between consecutive segments so that content straddling a split point
/// (e.g. a line of text) is not lost for OCR purposes.
const double kPdfPageSegmentOverlapFraction = 0.06;

/// A single ordered piece of a source page that will become one rasterized
/// PDF page.
///
/// [sourceRect] is expressed in the *source* image's pixel coordinate space
/// (before any resize). [targetSize] is the final raster pixel size after
/// any (down-only) scaling has been applied; it always preserves the aspect
/// ratio of [sourceRect].
class PdfPageSegment {
  final Rect sourceRect;
  final Size targetSize;
  final int index;
  final int count;

  const PdfPageSegment({
    required this.sourceRect,
    required this.targetSize,
    required this.index,
    required this.count,
  });

  @override
  String toString() =>
      'PdfPageSegment(index: $index/$count, sourceRect: $sourceRect, '
      'targetSize: $targetSize)';
}

/// The ordered plan of one or more [PdfPageSegment]s a single source page is
/// broken into.
class PdfPageSizingPlan {
  final List<PdfPageSegment> segments;

  const PdfPageSizingPlan(this.segments);

  /// Whether the source page had to be split into more than one segment.
  bool get isSegmented => segments.length > 1;
}

/// Plans how a single decoded page of pixel dimensions [source] should be
/// prepared for embedding into a PDF.
///
/// Rules (see task requirements this implements):
///  * Never upscale — if the page already fits [budget] it is left exactly
///    as-is (single segment, unchanged size).
///  * Ordinary portrait/landscape pages (aspect ratio under
///    [extremeAspectRatio]) are only ever proportionally downscaled to fit
///    the budget; they are never segmented.
///  * Only an "extreme" long/narrow page that still exceeds the budget is
///    split along its long axis into ordered, content-complete segments
///    with a small overlap, so no simple destructive longest-edge cap is
///    ever applied.
PdfPageSizingPlan planPdfPageSizing(
  Size source, {
  double budget = kMaxPdfPagePixelBudget,
  double extremeAspectRatio = kExtremePdfPageAspectRatio,
  double minSegmentLongEdge = kMinPdfPageSegmentLongEdge,
  double overlapFraction = kPdfPageSegmentOverlapFraction,
}) {
  final width = source.width;
  final height = source.height;
  assert(width > 0 && height > 0, 'source size must be positive');

  final totalPixels = width * height;
  final isWidthLongEdge = width >= height;
  final longEdge = isWidthLongEdge ? width : height;
  final shortEdge = isWidthLongEdge ? height : width;
  final aspectRatio = longEdge / shortEdge;

  PdfPageSizingPlan singlePage() {
    final target = totalPixels <= budget
        ? source
        : Size(
            width * math.sqrt(budget / totalPixels),
            height * math.sqrt(budget / totalPixels),
          );
    return PdfPageSizingPlan([
      PdfPageSegment(
        sourceRect: Rect.fromLTWH(0, 0, width, height),
        targetSize: target,
        index: 0,
        count: 1,
      ),
    ]);
  }

  if (totalPixels <= budget || aspectRatio < extremeAspectRatio) {
    return singlePage();
  }

  // Extreme long/narrow AND over budget: try to keep the short edge at (or
  // close to) native resolution by choosing a long-axis segment length that
  // fits the pixel budget on its own, splitting into ordered segments.
  var segmentLongLength = (budget / shortEdge).floorToDouble();
  segmentLongLength = math.max(segmentLongLength, minSegmentLongEdge);
  segmentLongLength = math.min(segmentLongLength, longEdge);

  if (segmentLongLength >= longEdge) {
    // Degenerate case (extremely large short edge): fall back to a single,
    // proportionally downscaled page rather than a meaningless "split".
    return singlePage();
  }

  final overlap = (segmentLongLength * overlapFraction).clamp(
    0.0,
    segmentLongLength / 2,
  );
  final stride = segmentLongLength - overlap;
  final segmentCount = math.max(
    1,
    ((longEdge - segmentLongLength) / stride).ceil() + 1,
  );

  final segments = <PdfPageSegment>[];
  for (var i = 0; i < segmentCount; i++) {
    final isLast = i == segmentCount - 1;
    final start = isLast
        ? longEdge - segmentLongLength
        : math.min(i * stride, longEdge - segmentLongLength);

    final rect = isWidthLongEdge
        ? Rect.fromLTWH(start, 0, segmentLongLength, shortEdge)
        : Rect.fromLTWH(0, start, shortEdge, segmentLongLength);

    final segmentPixels = rect.width * rect.height;
    final targetSize = segmentPixels <= budget
        ? rect.size
        : Size(
            rect.width * math.sqrt(budget / segmentPixels),
            rect.height * math.sqrt(budget / segmentPixels),
          );

    segments.add(
      PdfPageSegment(
        sourceRect: rect,
        targetSize: targetSize,
        index: i,
        count: segmentCount,
      ),
    );
  }

  return PdfPageSizingPlan(segments);
}
