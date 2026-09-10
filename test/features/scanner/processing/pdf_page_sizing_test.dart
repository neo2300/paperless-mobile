import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/features/scanner/processing/pdf_page_sizing.dart';

void main() {
  group('planPdfPageSizing — ordinary portrait/landscape pages', () {
    test('leaves a small page completely untouched (no upscale)', () {
      final plan = planPdfPageSizing(const Size(600, 800));

      expect(plan.isSegmented, isFalse);
      final segment = plan.segments.single;
      expect(segment.sourceRect, const Rect.fromLTWH(0, 0, 600, 800));
      // Never upscaled: target size equals the (small) source size exactly.
      expect(segment.targetSize, const Size(600, 800));
    });

    test('proportionally downscales an over-budget portrait page, preserving '
        'aspect ratio, and does not segment it', () {
      // 4000x5000 = 20MP, well over budget, ordinary aspect ratio (1.25).
      const source = Size(4000, 5000);
      final plan = planPdfPageSizing(source);

      expect(plan.isSegmented, isFalse);
      final target = plan.segments.single.targetSize;

      expect(
        target.width * target.height,
        lessThanOrEqualTo(kMaxPdfPagePixelBudget),
      );
      // Aspect ratio preserved.
      expect(
        (target.width / target.height),
        closeTo(source.width / source.height, 1e-9),
      );
      // Downscaled, not upscaled.
      expect(target.width, lessThan(source.width));
      expect(target.height, lessThan(source.height));
    });

    test(
      'proportionally downscales an over-budget landscape page the same way',
      () {
        const source = Size(6000, 3000);
        final plan = planPdfPageSizing(source);

        expect(plan.isSegmented, isFalse);
        final target = plan.segments.single.targetSize;
        expect(
          target.width * target.height,
          // A tiny floating-point tolerance: `sqrt`-derived scale factors can
          // land a `width * height` product a few ULPs above the exact
          // budget for some source sizes; this is not a real overage.
          lessThanOrEqualTo(kMaxPdfPagePixelBudget * (1 + 1e-9)),
        );
        expect(
          (target.width / target.height),
          closeTo(source.width / source.height, 1e-9),
        );
      },
    );

    test('a page exactly at the budget is left unchanged', () {
      // Choose a size whose pixel count equals the budget exactly.
      const width = 2000.0;
      final height = kMaxPdfPagePixelBudget / width;
      final plan = planPdfPageSizing(Size(width, height));

      expect(plan.isSegmented, isFalse);
      expect(plan.segments.single.targetSize, Size(width, height));
    });
  });

  group('planPdfPageSizing — extreme long/narrow pages', () {
    test(
      'does not segment an extreme-aspect page that still fits the budget',
      () {
        // Aspect ratio 10, but small enough to fit under budget entirely.
        const source = Size(500, 5000); // 2.5MP
        final plan = planPdfPageSizing(source);

        expect(plan.isSegmented, isFalse);
        expect(plan.segments.single.targetSize, source);
      },
    );

    test('splits a very long vertical document into ordered, overlapping, '
        'content-complete segments', () {
      const shortEdge = 1000.0;
      const longEdge = 30000.0; // extreme + over budget
      final plan = planPdfPageSizing(const Size(shortEdge, longEdge));

      expect(plan.isSegmented, isTrue);
      expect(plan.segments.length, greaterThan(1));
      _expectOrderedOverlappingCoverage(
        plan,
        longEdge: longEdge,
        shortEdge: shortEdge,
        longAxisIsHeight: true,
      );
    });

    test('splits a very long horizontal document into ordered, overlapping, '
        'content-complete segments', () {
      const shortEdge = 900.0;
      const longEdge = 40000.0;
      final plan = planPdfPageSizing(const Size(longEdge, shortEdge));

      expect(plan.isSegmented, isTrue);
      _expectOrderedOverlappingCoverage(
        plan,
        longEdge: longEdge,
        shortEdge: shortEdge,
        longAxisIsHeight: false,
      );
    });

    test('keeps the short edge at native resolution when segmenting', () {
      const shortEdge = 1200.0;
      const longEdge = 50000.0;
      final plan = planPdfPageSizing(const Size(shortEdge, longEdge));

      expect(plan.isSegmented, isTrue);
      for (final segment in plan.segments) {
        // The short edge of every segment's source rect should be the
        // full native short edge (never itself cropped).
        expect(segment.sourceRect.width, shortEdge);
        // With shortEdge=1200, a native-resolution segment already fits
        // under budget on its own, so no further per-segment downscale
        // should be necessary.
        expect(segment.targetSize.width, segment.sourceRect.width);
        expect(segment.targetSize.height, segment.sourceRect.height);
      }
    });

    test('falls back to a single (downscaled) page when the configured '
        'minimum segment length would reach (or exceed) the long edge', () {
      // With a deliberately large minSegmentLongEdge relative to the
      // page's own long edge, splitting would be meaningless (the
      // "segment" would cover the whole page), so this must fall back to
      // a single, proportionally downscaled page instead.
      const source = Size(1000, 5000); // extreme (aspect ratio 5), over a
      // tiny budget below.
      final plan = planPdfPageSizing(
        source,
        budget: 1000,
        minSegmentLongEdge: 10000,
      );

      expect(plan.isSegmented, isFalse);
      final target = plan.segments.single.targetSize;
      expect(target.width, lessThan(source.width));
      expect(target.height, lessThan(source.height));
    });
  });
}

/// Shared assertions for a segmented [PdfPageSizingPlan]: segments must be
/// ordered, start at 0, end exactly at the long edge, never leave a gap,
/// and (for all but possibly the final pair) overlap by roughly the
/// configured overlap fraction.
void _expectOrderedOverlappingCoverage(
  PdfPageSizingPlan plan, {
  required double longEdge,
  required double shortEdge,
  required bool longAxisIsHeight,
}) {
  final segments = plan.segments;
  double start(int i) => longAxisIsHeight
      ? segments[i].sourceRect.top
      : segments[i].sourceRect.left;
  double end(int i) => longAxisIsHeight
      ? segments[i].sourceRect.bottom
      : segments[i].sourceRect.right;

  // Ordered by index and ascending position.
  for (var i = 0; i < segments.length; i++) {
    expect(segments[i].index, i);
    expect(segments[i].count, segments.length);
  }

  // First segment starts exactly at 0; last ends exactly at longEdge.
  expect(start(0), 0);
  expect(end(segments.length - 1), closeTo(longEdge, 1e-6));

  // Short edge is always fully covered and matches for every segment.
  for (final segment in segments) {
    final width = longAxisIsHeight
        ? segment.sourceRect.width
        : segment.sourceRect.height;
    expect(width, shortEdge);
  }

  // No gaps between consecutive segments (each next start <= previous end),
  // and segments are strictly ordered (monotonically non-decreasing start).
  for (var i = 1; i < segments.length; i++) {
    expect(start(i), greaterThanOrEqualTo(start(i - 1)));
    expect(
      start(i),
      lessThanOrEqualTo(end(i - 1)),
      reason:
          'segment $i must overlap or touch the previous segment '
          '(no coverage gap)',
    );
  }

  // Every non-final pair should overlap by a "small" amount relative to
  // segment length (bounded above; the very last pair may need a larger
  // overlap purely to reach full coverage, which is acceptable).
  for (var i = 1; i < segments.length - 1; i++) {
    final overlap = end(i - 1) - start(i);
    final segmentLength = end(i) - start(i);
    expect(overlap, greaterThanOrEqualTo(0));
    expect(overlap, lessThan(segmentLength));
  }
}
